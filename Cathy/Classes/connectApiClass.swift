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
    var isSaved : Bool = false
    
    init(id: Int) {
        guard let url = URL(string: "\(endpoint)chronology_\(id).php") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data, err == nil else {return}
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                    case 200:
                        do {
                            let jsonResponse = try JSONDecoder().decode(Chronologies.self, from: data)
                            if self.saveToDisk(chronologies: jsonResponse) {
                                self.isSaved = true
                                print("SAVED")
                            }
                            
                        } catch let e {
                            print("Error", e)
                        }
                        break
                    
                    case 404:
                        print(404, "not found data")
                        break
                    
                    default:
                        print("response code:", response.statusCode)
                        break
                }
            }
        }
        
        task.resume()
    }
    
    func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            print("cant define URL")
            return URL(fileURLWithPath: "www.error.com")
        }
    }
    
    func saveToDisk(chronologies: Chronologies) -> Bool {
        let url = getDocumentsURL().appendingPathComponent("chronologies.json")
        do {
            let data = try JSONEncoder().encode(chronologies)
            try data.write(to: url, options: [])
            return true
        } catch let e {
            print("Error", e)
            return false
        }
    }
    
    func getFromDisk() -> [Chronologies] {
        let error = [Chronologies]()
        
//        if isSaved {
            let url = getDocumentsURL().appendingPathComponent("chronologies.json")
            do {
                let data = try Data(contentsOf: url, options: [])
                let result = try JSONDecoder().decode(Chronologies.self, from: data)
                return [result]
            } catch let e {
                print("Error", e)
                return error
            }
        
//        } else {
//            return error
//        }
    }
}
