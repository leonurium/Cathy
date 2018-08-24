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

struct Chronologies {
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

class ChronologyModel: NSObject {
    var chronologies = [Chronologies]()
    
    override init() {
        chronologies.append(Chronologies(id: 1, title: "Test", background: "room", chronology: [
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
        
        let username = "C4THY"
        let predicate = NSPredicate(format: "username == %@", username)
        
        let fetchRequest = NSFetchRequest<Checkpoint>(entityName: "Checkpoint")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedEntities = try context.fetch(fetchRequest)
            fetchedEntities.first?.id = Int32(id)
            fetchedEntities.first?.id_chronology = Int32(idChronology)
            
            if fetchedEntities.count > 0 {
                do {
                    try context.save()
                    return true
                } catch {
                    print("GAGAL SAVE UPDATE")
                    return false
                }
            } else {
                return saveObject(username: username, id: id, idChronology: idChronology)
            }
        } catch {
            print("GAGAL SAVE UPDATE")
            return false
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
