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
        chronologies.append(Chronologies(id: 1, title: "Awal-Awal", background: "none", chronology:[
            0 : [
                "type"      : "narator",
                "text"      : "Hi… Welcome to our interactive storytelling, in this story you will play the main character part so, lets begin…",
                "target"    : 1
            ],
            
            1 : [
                "type"      : "narator",
                "text"      : "I’am a 25 years old man, I work as a market analyst at ABC,  I’m an independent type of person, I don’t care about my surrondings also I dont like to interact with other people,  all I care about is me, myself and I, but this is not who I was, maybe iam still mad and disappointed with my past...",
                "target"    : 2
            ],
            
            2 : [
                "type"      : "narator",
                "text"      : "3 Year ago...",
                "target"    : 3
            ],
            
            3 : [
                "type"      : "narator",
                "text"      : "I was living happily with my wife, she was pregnant, I was so ready and excited to be a father, everyday I sang twinkle for her hoping that she would remember my voice, I was looking forward to hold her in my arms and and so I did ,… in my dreams every night. ",
                "target"    : 4
            ],
            4 : [
                "type"      : "narrator",
                "text"      : " but one day a disaster came, my wife was killed in a car accident, suddenly I lost myself, I could not accept this happening to me."
                "target"    : 5
                ]
            ]))
        
        chronologies.append(Chronologies(id: 2, title: "New Star Bab 2", background: "Office.jpg", chronology:[
            0 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "Hei m8, the boss want me to inform you that this afternoon will be doing a community service...",
                "target"    : 1
            ],
            1 : [
                "type"              : "option",
                "subject"           : " ",
                "optionText"        : [
                    "No, I dont want to.",
                    "Yeah, whatever, I'll go.",
                ],
                "optionExpression"  : [
                    "Angry"
                    "Neutral"
                ],
                "optionTarget"      : [
                    2,
                    3
                ]
            ],
            2 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "Oh yea? this is a direct order from our director btw, so you must come or somethin else will happen!",
                "target"    : 4
            ],
            3 : [
                    "type"      : "text",
                    "subject"   : "Gabriel",
                    "text"      : "Wohohoho easy m8, its been a while since you ever go to a place that is not you house or the office.",
                    "target"    : 4
            ],
            
            4 : [
                "type"      : "narator",
                "text"      : "Really, then community service now community service, isn’t job is enough already?",
                "target"    : 5
            ],
            
            5 : [
                "type"      : "text",
                "subject"   : "Gabriel"
                "text"      : "And don’t be late ‘kay? I don’t want boss cut up our live cause of you",
                "target"    : 6
            ],
            
            6 : [
                "type"      : "narator"
                "text"      : "I don't really have choice I guess..."
            002
            ]
            ]))
        
        chronologies.append(Chronologies(id: 3, title: "New Star Bab 2 Part 2", background: "panti.jpg", chronology: [
            0 : [
                "type"      : "narator",
                "text"      : "So crowd, I don't know they would be this many orphans in here",
                "target"    : 1
            ],
            1 : [
                "type"      : "narator",
                "text"      : "Hmmm... that girl is definetely someone like...! That memory! I don’t really want to remember it.",
                "target"    : 101
            ],
            
            101 : [
                "type"      : "interaction",
                "subtype"   : "mini_game",
                "target"    : 2
            
            ]
            
            2 : [
                "type"      : "narator",
                "text"      : "Time has passed",
                "target"    : 3
            ],
            
            3 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "Holy moly! I’m beat dude...",
                "target"    : 4
            ],
            
            4 : [
                "type"      : "narator",
                "text"      : "Gabriel seems pretty tired now. Still, hard working man",
                "target"    : 5
            ],
            
            5 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "Huh? ay ay man, don’t be like that! Come on don’t be like a dead meat!",
                "target"    : 6
            ],
            
            6 : [
                "type"              : "option",
                "subject"           : " ",
                "optionText"        : [
                    "I'm just tired man.",
                    "Why are you so concern about me?.",
                    "Hahahahahaha"
                ],
                "optionExpression"  : [
                    "Happy",
                    "Angery",
                    "Neutral"
                ],
                "optionTarget"      : [
                    7,
                    8,
                    9
                ]
            ],
            
            7 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "Tired? you barely was doing anything. Hahahaha",
                "target"    : 10
            ],
            
            8 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "Cuz I’m your partner m8! If you get cut by boss I get cut too!",
                "target"    : 10
            ],
            
            9 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "What is wrong with you?",
                "target"    : 10
            ],
            
            10 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "Anyway, come on man, Smile!",
                "target"    : 11
            ],
            
            11 : [
                "type"      : "text",
                "subject"   : "Gabriel",
                "text"      : "That is better",
                "target"    : 12
            ],
            
            12 : [
                "type"      : "narator",
                "text"      : "So, actually this orphanage near to me huh... I never tought about it. Maybe I'll just pass by here sometime in here.",
                "target"    : 13
            ],
            
            13 : [
                "type"      : "interaction",
                "subtype"   : "next_day",
                "target"    : 14
            
            ],
            
            14 : [
                "type"      : "narator",
                "text"      : "Hmmmmm, so this is the orphanage...",
                "target"    : 15
            ],
            
            15 : [
                "type"      : "narator",
                "text"      : "Hmmm, is that the girl..."
                "target"    : 16
            ],
            
            16 : [
                "type"      : "interaction",
                "subtype"   : "scene_cathy_playing",
                "target"    : 17
            ],
            
            17 : [
                "type"      : "
            ]
            
            ]))
        
        /*chronologies.append(Chronologies(id: 2, title: "Bocah Nangis", background: "leo.jpg", chronology: [
            0 : [
                "type"      : "narator",
                "text"      : "suatu hari..",
                "target"    : 1
            ],
            
            1 : [
                "type"              : "option",
                "subject"           : "cathy",
                "optionText"        : [
                    "kamu cinta aku gak?",
                    "kamu benci aku gak?"
                ],
                
                "optionExpression"  : [
                    "normal",
                    "normal"
                ],
                
                "optionTarget"      : [
                    0,
                    2
                ]
            ]
            
            ]))
        */
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
}
