//
//  CloudKitHelper.swift
//  Cathy
//
//  Created by Rangga Leo on 24/10/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

protocol ProtocolCloudKitManager {
    var id: String? { get }
    var createdAt: Date? { get }
    var lastModifiedAt: Date? { get }
    
    var DBPublic: CKDatabase { get }
    var DBPrivate: CKDatabase { get }
    var DBShared: CKDatabase { get }
    
    func save(data: [String : Any], DB: CKDatabase, _ completionHandler: @escaping (Bool) -> Void) -> Void
}

class CloudKitManager: ProtocolCloudKitManager {
    var record: CKRecord
    
    var id: String? {
        return record.recordID.recordName
    }
    
    var createdAt: Date? {
        return record.creationDate
    }
    
    var lastModifiedAt: Date? {
        return record.modificationDate
    }
    
    init(record: CKRecord) {
        self.record = record
    }
    
    var DBPublic: CKDatabase {
        return CKContainer.default().publicCloudDatabase
    }
    
    var DBPrivate: CKDatabase {
        return CKContainer.default().privateCloudDatabase
    }
    
    var DBShared: CKDatabase {
        return CKContainer.default().sharedCloudDatabase
    }
    
    func save(data: [String : Any], DB: CKDatabase, _ completionHandler: @escaping (Bool) -> Void) {
        for i in data {
            record[i.key] = i.value as? __CKRecordObjCValue
        }
        
        DB.save(record) { (records, error) in
            if let r = records {
                print("SAVED TO CLOUD : \(r)")
                completionHandler(true)
            }
            
            if let e = error {
                print("Error: \(e.localizedDescription)")
                completionHandler(false)
            }
            
            completionHandler(false)
        }
    }
}

struct ProgressChronology {
    let id: Int
    let id_chronology: Int
}

class CloudKitProgress: CloudKitManager {
    override init(record: CKRecord) {
        super.init(record: record)
    }
    
    func update(data: [String: Any], DB: CKDatabase, completionHandler: @escaping (Bool) -> Bool) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: record.recordType, predicate: predicate)
        
        DB.perform(query, inZoneWith: nil) { (records, error) in
            if let r = records {
                
                if r.count != 0 {
                    if let newRecord = r.first {
                        self.record = newRecord
                        self.save(data: data, DB: DB, { (hasSuccess) in
                            completionHandler(hasSuccess)
                        })
                    }
                    
                } else {
                    self.save(data: data, DB: DB, { (hasSuccess) in
                        completionHandler(hasSuccess)
                    })
                    
                    completionHandler(false)
                }
                
            }
            if let e = error {
                print("Error: \(e.localizedDescription)")
                completionHandler(false)
            }
            
            completionHandler(false)
        }
    }
    
    func updateObject(id: Int, idChronology: Int) -> Bool {
        self.update(data: ["idChapter": id, "idChronology": idChronology], DB: self.DBPublic) { (isSuccess) in
            if isSuccess {
                return true
            } else {
                return false
            }
        }
        return false
    }

    func fetch(searchPredicateQuery: [String : Int]?, DB: CKDatabase, completionHandler: @escaping ([ProgressChronology]?) -> [ProgressChronology]) {
        var progress: [ProgressChronology] = []
        if let q = searchPredicateQuery {
            let predicate = NSPredicate(format: "\(q.keys.first!) = %@", "\(q.values.first!)")
            let query = CKQuery(recordType: record.recordType, predicate: predicate)

            DB.perform(query, inZoneWith: nil) { (records, error) in
                if let e = error {
                    print("Error: \(e.localizedDescription)")
                }

                if let r = records {
                    print("---PERFORM QUERY CLOUDKIT---")
                    print(r)
                    print("---CONVERT DATA---")
                    r.forEach({ (v) in
                        let s = self.convertCKRecordToProgress(record: v)
                        progress.append(s)
                    })
                    completionHandler(progress)
                }
            }
            
        } else {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: record.recordType, predicate: predicate)
            
            DB.perform(query, inZoneWith: nil) { (records, error) in
                if let r = records {
                    r.forEach({ (v) in
                        let s = self.convertCKRecordToProgress(record: v)
                        progress.append(s)
                    })
                    completionHandler(progress)
                }
            }
        }
        completionHandler(progress)
    }
    
    func deleteAll(DB: CKDatabase, completionHandler: @escaping (Bool) -> Void) {
        let q = CKQuery(recordType: record.recordType, predicate: NSPredicate(value: true))
        
        DB.perform(q, inZoneWith: nil) { (records, error) in
            if let r = records {
                for i in r {
                    DB.delete(withRecordID: i.recordID, completionHandler: { (recordID, errors) in
                        if let rID = recordID {
                            print("delete: \(rID)")
                            completionHandler(true)
                        }
                        
                        if let err = errors {
                            print("Error : \(err.localizedDescription)")
                            completionHandler(false)
                        }
                        
                        completionHandler(false)
                    })
                }
            }
            
            if let e = error {
                print("Error: \(e.localizedDescription)")
                completionHandler(false)
            }
            completionHandler(false)
        }
    }
    
    func cleanAll() -> Bool {
        self.deleteAll(DB: self.DBPublic) { (isTrue) in
            return isTrue
        }
        
        return false
    }
    
    func fetchObject() -> [ProgressChronology]? {
        self.fetch(searchPredicateQuery: nil, DB: self.DBPublic) { (progress) in
            if let p = progress {
                return p
            }
            
            return [ProgressChronology]()
        }
        
        return [ProgressChronology]()
    }

    func convertCKRecordToProgress(record: CKRecord) -> ProgressChronology {
        let idChapter = record["idChapter"] as! Int
        let idChronology = record["idChronology"] as! Int

        return ProgressChronology(id: idChapter, id_chronology: idChronology)
    }
}
