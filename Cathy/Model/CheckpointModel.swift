//
//  CheckpointModel.swift
//  Cathy
//
//  Created by Rangga Leo on 26/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CheckpointModel: NSObject {
    
    override init() {
        print("checkpoint model inisalize")
    }
    
    private func getContext() -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveObject(username: String, id: Int, idChronology: Int) -> Bool
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
        } catch let e {
            print("error \(e)")
            return false
        }
    }
    
    func updateObject(id: Int, idChronology: Int) -> Bool {
        
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
                } catch let e {
                    print("error \(e)")
                    return false
                }
            } else {
                return saveObject(username: username, id: id, idChronology: idChronology)
            }
        } catch let e {
            print("error \(e)")
            return false
        }
    }
    
    func fetchObject() -> [Checkpoint]?
    {
        let context = getContext()
        var checkpoint: [Checkpoint]? = nil
        do {
            checkpoint = try context.fetch(Checkpoint.fetchRequest())
            return checkpoint
        } catch let e {
            print("error \(e)")
            return checkpoint
        }
    }
    
    func deleteObject(checkpoint: Checkpoint) -> Bool
    {
        let context = getContext()
        context.delete(checkpoint)
        
        do {
            try context.save()
            return true
        } catch let e {
            print("error \(e)")
            return false
        }
    }
    
    func cleanAll() -> Bool
    {
        let context = getContext()
        let cleaning = NSBatchDeleteRequest(fetchRequest: Checkpoint.fetchRequest())
        
        do {
            try context.execute(cleaning)
            return true
        } catch let e {
            print("error \(e)")
            return false
        }
    }
}
