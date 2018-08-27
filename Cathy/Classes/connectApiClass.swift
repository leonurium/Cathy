//
//  connectApiClass.swift
//  Cathy
//
//  Created by Rangga Leo on 24/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class connectApiClass {
    let endpoint: String = "https://ranggaleo3.000webhostapp.com/cathy/"
    let superClassUserDefault = UserDefaults.standard
    
    init() {
        print("inisiasi class connectApiClass")
    }
    
    func getData(id: Int) {
        guard let url = URL(string: "\(endpoint)chronology_\(id).php") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 200:
                    guard let data = data, err == nil else {return}
                    if data.count > 0 {
                        do {
                            let jsonResponse = try JSONDecoder().decode(Chronologies.self, from: data)
                            if self.saveToDisk(chronologies: jsonResponse, id: id) {
                                self.getData(id: id+1)
                                return
                            }
                            
                        } catch let e {
                            print("Error", e)
                        }
                    }
                    break
                    
                case 404:
                    self.superClassUserDefault.set(Int(id+1), forKey: "UPDATE_CHRONOLOGY")
                    print(404, "not found data")
                    return
                    break
                    
                default:
                    print("response code:", response.statusCode)
                    break
                }
            }
        }
        
        task.resume()
    }
    
    func autoUpdateData() {
        if let updateData = superClassUserDefault.object(forKey: "UPDATE_CHRONOLOGY") {
            getData(id: updateData as! Int)
        
        } else {
            getData(id: ChronologyModel().idCheckpoint)
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
