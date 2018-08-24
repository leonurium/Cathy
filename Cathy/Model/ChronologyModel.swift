//
//  ChronologyModel.swift
//  Cathy
//
//  Created by Rangga Leo on 16/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Chronologies: NSObject {
    let id : Int
    let title : String
    let background : String
    let chronology : [Int : [String : Any]]
    
    init(id: Int, title: String, background: String, chronology: [Int : [String : Any]]) {
        self.id = id
        self.title = title
        self.background = background
        self.chronology = chronology
    }
}

class ChronologyModel {
    var chronologies = [Chronologies]()
    
    init() {
        chronologies.append(Chronologies(id: 1, title: "Test", background: "leo.jpg", chronology: [
            0 : [
                "type"          : "text",
                "subject"       : "cathy",
                "text"          : "hey",
                "expression"    : "mad",
                "target"        : 1
            ],
            
            1 : [
                "type"          : "text",
                "subject"       : "carl",
                "text"          : "woi",
                "expression"    : "happy",
                "target"        : 2
            ],
            
            2 : [
                "type"              : "option",
                "subject"           : "carl",
                "optionText"        : [
                    "ok",
                    "ok bro",
                    "interaction"
                ],
                
                "optionExpression"  : [
                    "happy",
                    "mad",
                    "happy"
                ],
                
                "optionTarget"      : [
                    0,
                    3,
                    4
                ]
            ],
            
            3 : [
                "type"      : "narator",
                "text"      : "lorem ipsum",
                "target"    : 0
            ],
            
            4 : [
                "type"      : "interaction",
                "subtype"   : "face_detection",
                "target"    : 0
            ],
            
            ]))
    }
    
    private class func getContext() -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(username: String, id: Int, idChronology: Int) -> Bool
    {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Checkpoint", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(username, forKey: "username")
        manageObject.setValue(id, forKey: "id")
        manageObject.setValue(idChronology, forKey: "id_chronology")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func updateObject(id: Int, idChronology: Int) -> Bool {
        let context = getContext()
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Checkpoint")
        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        
        if let fetchResults = context.execute(fetchRequest) as? [NSManagedObject] {
            if fetchResults.count != 0 {
                
                var managedObject = fetchResults[0]
                managedObject.setValue(id, forKey: "id")
                managedObject.setValue(idChronology, forKey: "id_chronology")
                
                do {
                    try context.save()
                    return true
                } catch {
                    return false
                }
            
            } else {
                self.saveObject(username: username, id: id, idChronology: idChronology)
            }
        }
    }
    
    class func fetchObject() -> [Checkpoint]?
    {
        let context = getContext()
        var checkpoint: [Checkpoint]? = nil
        do {
            checkpoint = try context.fetch(Checkpoint.fetchRequest())
            return checkpoint
        } catch {
            return checkpoint
        }
    }
    
    class func deleteObject(checkpoint: Checkpoint) -> Bool
    {
        let context = getContext()
        context.delete(checkpoint)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func cleanAll() -> Bool
    {
        let context = getContext()
        let cleaning = NSBatchDeleteRequest(fetchRequest: Checkpoint.fetchRequest())
        
        do {
            try context.execute(cleaning)
            return true
        } catch {
            return false
        }
    }
}
