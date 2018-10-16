//
//  ChronologyModel.swift
//  Cathy
//
//  Created by Rangga Leo on 16/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation

class Chronologies : NSObject, Decodable, Encodable {
    let id : Int
    let title : String
    let chronology : [Chronology]
}

class Chronology: NSObject, Decodable, Encodable {
    let type: String
    let subject: String?
    let text: String?
    let subjectChronology: [subjectChronology]?
    let target: Int?
    
    let optionText: [String]?
    let optionTarget: [Int]?
    
    let subtype: String?
    let background: String?
}

class subjectChronology: Decodable, Encodable {
    let subject: String?
    let expression: String?
}

class ChronologyModel {
    var chronologies = [Chronologies]()
    let checkpoint = CheckpointModel()
//    let api = connectApiClass()
    let api = ApiHandle()
    var idCheckpoint: Int = 0
    var idChronologyCheckpoint: Int = 0
//    let playerName: String = deviceNameModel.current.name
    
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

