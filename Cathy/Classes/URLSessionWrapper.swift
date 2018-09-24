//
//  URLSessionWrapper.swift
//  Cathy
//
//  Created by Rangga Leo on 21/09/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation

protocol ProtocolTask {
    var completionHandler: ResultTaskType<Data>.Completion? { get set }
    var progressHandler: ((Double) -> Void)? { get set }
    
    func resume()
    func suspend()
    func cancel()
}

public enum ResultTaskType<T> {
    
    public typealias Completion = (ResultTaskType<T>) -> Void
    
    case success(T)
    case failure(Swift.Error)
    
}

class GenericTask: ProtocolTask {
    var completionHandler: ResultTaskType<Data>.Completion?
    var progressHandler: ((Double) -> Void)?
    
    private(set) var task: URLSessionDataTask
    var expectedContentLength: Int64 = 0
    var buffer = Data()
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    deinit {
        print("Deinit: \(task.originalRequest?.url?.absoluteString ?? "")")
    }
    
    func resume() {
        task.resume()
    }
    
    func suspend() {
        task.suspend()
    }
    
    func cancel() {
        task.cancel()
    }
}

final class URLSessionWrapper: NSObject {
    public static let shared = URLSessionWrapper()
    
    private var session: URLSession!
    private var sessionTasks = [GenericTask]()
    
    private override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func request(request: URLRequest) -> ProtocolTask {
        let task = session.dataTask(with: request)
        let genericTask = GenericTask(task: task)
        
        sessionTasks.append(genericTask)
        return genericTask
    }
}

extension URLSessionWrapper: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let task = sessionTasks.first(where: {$0.task == dataTask} )  else {
            completionHandler(.cancel)
            return
        }
        
        task.expectedContentLength = response.expectedContentLength
        completionHandler(.allow)
        
        let httpResponse = response as? HTTPURLResponse
        
        switch httpResponse?.statusCode {
        case 200:
            print("Http Response:", 200)
            break
        case 404:
            print("Http Response:", 404)
            break
        default:
            print("Http Response: \(String(describing: httpResponse?.statusCode))")
            break
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let task = sessionTasks.first(where: {$0.task == dataTask}) else {return}
        
        task.buffer.append(data)
        let percent = Double(task.buffer.count) / Double(task.expectedContentLength)
        DispatchQueue.main.async {
            task.progressHandler?(percent)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let index = sessionTasks.index(where: {$0.task == task}) else {return}
        
        let task = sessionTasks.remove(at: index)
        
        DispatchQueue.main.async {
            if let e = error {
                task.completionHandler?(.failure(e))
                
            } else {
                task.completionHandler?(.success(task.buffer))
            }
        }
    }
}
