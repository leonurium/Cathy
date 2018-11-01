//
//  ApiHandle.swift
//  Cathy
//
//  Created by Rangga Leo on 20/09/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class ApiHandle {
    let userDefaultsShared = UserDefaults.standard
    let endpoint: String = "https://ranggaleo3.000webhostapp.com/cathy/"
    fileprivate var task: ProtocolTask?
    
    var reachability: Reachability?
    let hostNames = [nil, "google.com", "invalidhost"]
    
    func GET(id: Int, view: UIView?) {
        let url = URL(string: "\(endpoint)chronology_\(id).php")!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        task = URLSessionWrapper.shared.request(request: request)
        
        guard let currentView = view else {return}
        
//        let progressX = ProgressX(frame: UIScreen.main.bounds, view: currentView)
        
        DispatchQueue.main.async {
            self.task?.progressHandler = { [weak self] in
//                progressX.progressBar.progress = Float($0)
//                progressX.progressLabel.text = "\($0) Loading..."
//                currentView.addSubview(progressX)
//                view?.addSubview(progressX)
                print("progress.. \($0)")
            }
        }
        
        task?.completionHandler = { [weak self] in
            switch $0 {
            case .failure(let e):
                print(e)
                break
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(Chronologies.self, from: data)
                    
                    if (self?.saveToDisk(chronologies: result, id: id))! {
                        self?.GET(id: id + 1, view: currentView)

                    } else {
                        self?.GET(id: id, view: currentView)
                    }
                    
//                    DispatchQueue.main.async {
//                        progressX.dismiss(view: currentView)
//                    }
                    print(result)
                    
                } catch let e {
                    self?.userDefaultsShared.set(Int(id+1), forKey: "UPDATE_CHRONOLOGY")
                    print(e)
                }
                break
            }
        }
        
        task?.resume()
    }
    
    func autoUpdateData(view: UIView?) {
        if let updateData = userDefaultsShared.object(forKey: "UPDATE_CHRONOLOGY") {
            GET(id: updateData as! Int, view: view)
            
        } else {
            GET(id: ChronologyModel().idCheckpoint, view: view)
        }
    }
    
    func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            print("cant define URL")
            return URL(fileURLWithPath: "www.error.com")
        }
    }
    
    func readDisk() {
        let url = getDocumentsURL()
        do {
            try FileManager.default.createDirectory(atPath: url.relativePath, withIntermediateDirectories: true)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            
            print(directoryContents)

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveToDisk(chronologies: Chronologies, id: Int) -> Bool {
        let url = getDocumentsURL().appendingPathComponent("chronologies_\(id).json")
        do {
            let data = try JSONEncoder().encode(chronologies)
            try data.write(to: url, options: [])
            return true
        } catch let e {
            print("Error", e)
            return false
        }
    }
    
    func getFromDisk(id: Int) -> [Chronologies] {
        let error = [Chronologies]()
        let url = getDocumentsURL().appendingPathComponent("chronologies_\(id).json")
        do {
            let data = try Data(contentsOf: url, options: [])
            let result = try JSONDecoder().decode(Chronologies.self, from: data)
            return [result]
        } catch let e {
            print("Error", e)
            return error
        }
    }
}
