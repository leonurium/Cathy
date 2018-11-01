//
//  URLSessionWrapper.swift
//  Cathy
//
//  Created by Rangga Leo on 21/09/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import SystemConfiguration

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
        DispatchQueue.global().async {
            task.progressHandler?(percent)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let index = sessionTasks.index(where: {$0.task == task}) else {return}
        
        let task = sessionTasks.remove(at: index)
        
        DispatchQueue.global().async {
            if let e = error {
                task.completionHandler?(.failure(e))
                
            } else {
                task.completionHandler?(.success(task.buffer))
            }
        }
    }
}


enum ReachabilityType: CustomStringConvertible {
    case wwan
    case wiFi
    
    var description: String {
        switch self {
        case .wwan: return "WWAN"
        case .wiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case offline
    case online(ReachabilityType)
    case unknown
    
    var description: String {
        switch self {
        case .offline: return "Offline"
        case .online(let type): return "Online (\(type))"
        case .unknown: return "Unknown"
        }
    }
}

public class ReachabilityWrapper {
    
    func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    
    func monitorReachabilityChanges() {
        let host = "google.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (reach, flags, pointer) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: String(describing: ReachabilityWrapper.self)),
                                            object: nil,
                                            userInfo: ["Status": status.description])
        }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), RunLoopMode.commonModes as CFString)
    }
    
}

extension ReachabilityStatus {
    init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wiFi)
            }
        } else {
            self =  .offline
        }
    }
}
