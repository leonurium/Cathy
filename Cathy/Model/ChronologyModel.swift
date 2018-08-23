//
//  ChronologyModel.swift
//  Cathy
//
//  Created by Rangga Leo on 16/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation

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

class ChronologyModel {
    var chronologies = [Chronologies]()
    
    init() {
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
}
