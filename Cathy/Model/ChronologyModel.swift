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
    var playerName = deviceName.current.name
    
    
    init() {
        chronologies.append(Chronologies(id: 1, title: "Awal-Awal", background: "none", chronology:[
            0 : [
                "type"      : "narator",
                "text"      : "in this story you will play the main character part so, lets begin, your name is \(playerName), right?",
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
                "text"      : "But one day a disaster came, my wife was killed in a car accident, suddenly I lost myself, I could not accept this happening to me.",
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
                    "Angry",
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
                "subject"   : "Gabriel",
                "text"      : "And don’t be late ‘kay? I don’t want boss cut up our live cause of you",
                "target"    : 6
            ],
            
            6 : [
                "type"      : "narator",
                "text"      : "I don't really have choice I guess...",
                "target"    : 002
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
            
            ],
            
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
                "text"      : "Hmmm, is that the girl...",
                "target"    : 16
            ],
            
            16 : [
                "type"      : "interaction",
                "subtype"   : "scene_cathy_playing",
                "target"    : 17
            ],
            
            17 : [
                "type"      : "narator",
                "text"      : "Hmmm that girl again, somehow definetely she is someone... Nghhh, I don't really wan to think about it",
                "target"    : 18
            ],
            
            18 : [
                "type"      : "narator",
                "text"      : "Anyway I must go...",
                "target"    : 002
            
            
            ]
            ]))
        
        chronologies.append(Chronologies(id: 4, title: "Bab 3 New Star", background: "leo.jpg", chronology: [
            0 : [
                "type"      : "text",
                "subject"   : "gabriel",
                "text"      : "Hey kid watcha doin’?",
                "target"    : 1
            ],
            
            1 : [
                "type"              : "option",
                "subject"           : "Gabriel",
                "optionText"        : [
                    "Nothing much",
                    "Stop that"
                ],
                "optionTarget"      : [
                    2,
                    3
                ]
            ],
            
            2 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "happy",
                "text"          : "Ohhh you have been busy lately haha...?",
                "target"        : 4
            ],
            
            3 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "happy",
                "text"          : "Take it easy boy haha",
                "target"        : 4
            ],
            
            4 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "normal",
                "text"          : "Oh yea, did you hear what is the new? He said we gonna do some another community service huh...",
                "target"        : 5
            ],
            
            5 : [
                "type"          : "narator",
                "text"          : "Oh yea?",
                "target"        : 6
            ],
            
            6 : [
                "type"          : "narator",
                "text"          : "What is the point anyway doing this…? Why can’t they leave us in peace?",
                "target"        : 7
            ],
            
            7 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "happy",
                "text"          : "Ahhh you should happy man, the opportunity to help each other… hahahaha.",
                "target"        : 8
            ],
            
            8 : [
                "type"          : "narator",
                "text"          : "Yeah whatever",
                "target"        : 9
            ],
            
            9 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "normal",
                "text"          : "Eyyy man, what’s wrong? please tell me it ain’t that your wife again huh?",
                "target"        : 10
            ],
            
            10 : [
                "type"          : "text",
                "subject"       : "Protagonist",
                "text"          : "No it isn’t and never was. I already told you to not bring it up right?",
                "target"        : 11
            ],
            
            11 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "normal",
                "text"          : "Yeah, that’s right.. but I watchin’ you lately, and you seem back to your “was”",
                "target"        : 12
            ],
            
            12 : [
                "type"          : "option",
                "subject"       : "Gabriel",
                "optionText"    : [
                    "Maybe you just imagining it",
                    "What if you wrong?"
                ],
                "optionTarget"  : [
                    13,
                    14
                ]
            ],
            
            13 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "normal",
                "text"          : "Huh…? I’m not your typical designer or big picture thinking m8...",
                "target"        : 15
            ],
            
            14 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "angry",
                "text"          : "And if not?",
                "target"        : 15
            ],
            
            15 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "normal",
                "text"          : "Anyway m8, about the community service, I heard it going to the same place as before... Man… I’m sensing we getting new sponsor right now, hahahaha.",
                "target"        : 16
            ],
            
            16 : [
                "type"          : "narator",
                "text"          : "Same place again...",
                "target"        : 17
            ],
            
            17 : [
                "type"          : "interaction",
                "subtype"       : "pop-up scene",
                "target"        : 18
            ],
            
            18 : [
                "type"          : "narator",
                "text"          : "Arghh, Why that memory always cross over my mind this lately...?! I don’t want to remember it again, but it always come...",
                "target"        : 19
            ],
            
            19 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "normal",
                "text"          : "Hey are you alrigt m8?",
                "target"        : 20
            ],
            
            20 : [
                "type"          : "narator",
                "subject"       : "protagonist",
                "text"          : "I’m fine, just being overthinking...",
                "target"        : 21
            ],
            
            21 : [
                "type"          : "narator",
                "text"          : "That Girl...",
                "target"        : 22
            ],
            
            22 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "happy",
                "text"          : "Anyway man, don’t let your feeling letting down your performance m8. It just not me thingking ‘bout that, but everyone else does think the same way.",
            ],
            
            23 : [
                "type"          : "narator",
                "subject"       : "Protagonist",
                "text"          : "yeah noted",
                "target"        : 24
            ],
            
            24 : [
                "type"          : "narator",
                "text"          : "I hate to admit, but I remembered my dream with her… A dream that we can enjoy together",
                "target"        : 25
            ],
            
            25 : [
                "type"          : "interaction",
                "subtype"       : "cathy_scene",
                "target"        : 26
            ],
            
            26 : [
                "type"          : "narator",
                "text"          : "No! I won’t let that feeling happen again. I promise!",
                "target"        : 002
            ]
            ]))
        
        chronologies.append(Chronologies(id: 5, title: "Bab 3 New Star Part 2", background: "leo.jpg", chronology: [
            
            0 : [
                "type"      : "narator",
                "text"      : "The day of community service has come. I and other member of company have prepared to do the community service. we are going to the same place as before. Now I’m ready to do it again... let’s go.",
                "target"    : 1
            ],
            
            1 : [
                "type"      : "text",
                "subject"   : "Childrens",
                "text"      : "Waaaaaa!!",
                "target"    : 2
            ],
            
            2 : [
                "type"      : "narator",
                "text"      : "The children welcome us happiliy",
                "target"    : 3
            ],
            
            3 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "happy",
                "text"          : "Hehey… watcha’ think eh? guess we back.",
                "target"        : 4
            ],
            
            4 : [
                "type"          : "text",
                "subject"       : "Protagonist",
                "text"          : "Hmmm, yeah",
                "target"        : 5
            ],
            
            5 : [
                "type"          : "text",
                "subject"       : "Childrens",
                "text"          : "Mister! Mister!",
                "target"        : 6
            ],
            
            6 : [
                "type"          : "text",
                "subject"       : "Children",
                "text"          : "We miss you misters!",
                "target"        : 7
            ],
            
            7 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "happy",
                "text"          : "Woooow! Easy kids!",
                "target"        : 8
            ],
            
            8 : [
                "type"          : "narator",
                "text"          : "t seem they are all happy. Childrens always happy right, they always innocent, don’t know the real world… just thiking if I was become a boy again...",
                "target"        : 9
            ],
            
            9 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "normal",
                "text"          : "Ayy man, what are you doing there? Lets go inside!",
                "target"        : 10
            ],
            
            10 : [
                "type"          : "text",
                "subject"       : "Player",
                "text"          : "Let's Go!",
                "target"        : 002
            ]
            ]))
        
        chronologies.append(Chronologies(id: 6, title: "Bab 3 New Star Part 3", background: "leo.jpg", chronology: [
            
            0 : [
                "type"             : "text",
                "subject"          : "Children",
                "text"             : "Hey-hey mister! Mister! what you brought up today? hei?! hei?!",
                "target"           :  1
            ],
            
            1 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "happy",
                "text"          : "Hohohoho, you’all see! Hiyaahhhh!",
                "target"        : 2
            ],
            
            2 : [
                "type"          : "narator",
                "text"          : "Gabriel play his role as a pirate… well at least the children likes it",
                "target"        : 3
            ],
            
            3 : [
                "type"          : "interaction",
                "subtype"       : "mini_games2",
                "target"        : 4
            ],
            
            4 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "sad",
                "text"          : "Hoooh man... I’m beat..."
            ],
            
            5 : [
                "type"          : "narator",
                "text"          : "Gabriel is riden by 5 children",
                "target"        : 6
            ],
            
            6 : [
                "type"          : "narator",
                "text"          : ". . . . .",
                "target"        : 7
            ],
            
            7 : [
                "type"          : "narator",
                "text"          : "Yeah, I'm beat too.",
                "target"        : 8
            ],
            
            8 : [
                "type"          : "narator",
                "text"          : ". . . . Still that girl",
                "target"        : 9
            ],
            
            9 : [
                "type"          : "interaction",
                "subtype"       : "remember past scene",
                "target"        : 10
            ],
            
            10 : [
                "type"          : "narator",
                "text"          : "Again?! Why that Girl is somehow bring back that memories?",
                "target"        : 11
            ],
            
            11 : [
                "type"          : "interaction",
                "subtype"       : "remember_past_scene",
                "target"        : 12
            ],
            
            12 : [
                "type"          : "narator",
                "text"          : "Later that day...",
                "target"        : 13
            ],
            
            13 : [
                "type"          : "text",
                "subject"       : "Gabriel",
                "expression"    : "normal",
                "text"          : "Hey pal, sorry but we gotta go...",
                "target"        : 14
            ],
            
            14 : [
                "type"          : "text",
                "subject"       : "Player",
                "text"          : "Let's go",
                "target"        : 15
            ],
            
            15 : [
                "type"          : "narator",
                "subject"       : "Player"
            
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
        /*chronologies.append(Chronologies(id: 1, title: "Test", background: "leo.jpg", chronology: [
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
            
            ]))*/
    }
}
