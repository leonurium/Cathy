//
//  ChronologyModel.swift
//  Cathy
//
//  Created by Rangga Leo on 16/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation

class Chronologies : NSObject, NSCoding, Decodable, Encodable {
    let id : Int
    let title : String
    let background : String
    let chronology : [Chronology]
    
    init(id: Int, title: String, background: String, chronology: [Chronology]) {
        self.id = id
        self.title = title
        self.background = background
        self.chronology = chronology
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(background, forKey: "background")
        aCoder.encode(chronology, forKey: "chronology")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! Int
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let background = aDecoder.decodeObject(forKey: "background") as! String
        let chronology = aDecoder.decodeObject(forKey: "chronology") as! [Chronology]
        
        self.init(id: id, title: title, background: background, chronology: chronology)
    }
}

class Chronology: NSObject, NSCoding, Decodable, Encodable {
    
    let type: String
    let subject: String?
    let text: String?
    let expression: String?
    let target: Int?
    
    let optionText: [String]?
    let optionExpression: [String]?
    let optionTarget: [Int]?
    
    let subtype: String?
    
    init(type: String,
         subject: String?,
         text: String?,
         expression: String?,
         target: Int?,
         optionText: [String]?,
         optionExpression: [String]?,
         optionTarget: [Int]?,
         subtype: String?
        ) {
        self.type = type
        self.subject = subject
        self.text = text
        self.expression = expression
        self.target = target
        
        self.optionText = optionText
        self.optionExpression = optionExpression
        self.optionTarget = optionTarget
        
        self.subtype = subtype
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(subject, forKey: "subject")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(expression, forKey: "expression")
        aCoder.encode(target, forKey: "target")
        
        aCoder.encode(optionText, forKey: "optionText")
        aCoder.encode(optionExpression, forKey: "optionExpression")
        aCoder.encode(optionTarget, forKey: "optionTarget")
        
        aCoder.encode(subtype, forKey: "subtype")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let type = aDecoder.decodeObject(forKey: "type") as! String
        let subject = aDecoder.decodeObject(forKey: "subject") as? String
        let text = aDecoder.decodeObject(forKey: "text") as? String
        let expression = aDecoder.decodeObject(forKey: "expression") as? String
        let target = aDecoder.decodeObject(forKey: "target") as? Int
        
        
        let optionText = aDecoder.decodeObject(forKey: "optionText") as? [String]
        let optionExpression = aDecoder.decodeObject(forKey: "optionExpression") as? [String]
        let optionTarget = aDecoder.decodeObject(forKey: "optionTarget") as? [Int]
        
        let subtype = aDecoder.decodeObject(forKey: "subtype") as? String
        
        self.init(type: type, subject: subject, text: text, expression: expression, target: target, optionText: optionText, optionExpression: optionExpression, optionTarget: optionTarget, subtype: subtype)
        
    }
}

class ChronologyModel {
    var chronologies = [Chronologies]()
    let checkpoint = CheckpointModel()
    let api = connectApiClass()
    var idCheckpoint: Int = 0
    var idChronologyCheckpoint: Int = 0
    //let playerName: String = deviceNameModel.current.name
    
    init() {
        if chronologies.count > 0 {
            if let dataCheckpoint = checkpoint.fetchObject() {
                
                if dataCheckpoint.count > 0 {
                    idCheckpoint = Int(dataCheckpoint[0].id)
                    idChronologyCheckpoint = Int(dataCheckpoint[0].id_chronology)
                    
                    if idCheckpoint == chronologies[0].id {
                        //not need update
                    } else {
                        chronologies.removeAll()
                        chronologies = api.getFromDisk(id: idCheckpoint)
                    }
                    
                } else {
                    if checkpoint.updateObject(id: 0, idChronology: 0) {
                        if let dataCheckpoint2 = checkpoint.fetchObject() {
                            chronologies.removeAll()
                            chronologies = api.getFromDisk(id: Int(dataCheckpoint2[0].id))
                            
                        } else {
                            print("failed fetchObject")
                        }
                        
                    } else {
                        print("failed update")
                    }
                }
                
            } else {
                print("not found data")
            }

        } else {
            if let dataCheckpoint = checkpoint.fetchObject() {
                
                if dataCheckpoint.count > 0 {
                    idCheckpoint = Int(dataCheckpoint[0].id)
                    idChronologyCheckpoint = Int(dataCheckpoint[0].id_chronology)
                    chronologies = api.getFromDisk(id: idCheckpoint)

                } else {
                    
                    if checkpoint.updateObject(id: 0, idChronology: 0) {
                        if let dataCheckpoint2 = checkpoint.fetchObject() {
                            chronologies = api.getFromDisk(id: Int(dataCheckpoint2[0].id))
                            
                        } else {
                            print("failed fetchObject")
                        }
                        
                    } else {
                        print("failed update")
                    }
                }
                
            } else {
                print("failed fetchObject")
            }
        }
    }
}

