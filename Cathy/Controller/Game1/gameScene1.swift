//
//  gameScene1.swift
//  Cathy
//
//  Created by Terretino on 09/10/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    struct physic {
        static let none : UInt32 = 0
        static let all  : UInt32 = UInt32.max
        static let player : UInt32 = 0b001
        static let goodThing : UInt32 = 0b010
        static let badThing : UInt32 = 0b101
    }
    
    var background: SKSpriteNode!
    let motionManager = CMMotionManager()
    let gameTimerCount = Timer()
    var accelerateX: CGFloat = 0
    var player: SKSpriteNode!
    var goodThing = ["goodThing0", "goodThing1", "goodThing2"]
    var badThing: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameCountdownLabel: SKLabelNode!
    var gameTime: Int = 45 {
        didSet {
            gameCountdownLabel.text = "\(gameTime)"
        }
    }
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        player = SKSpriteNode(imageNamed: "player")
        background = SKSpriteNode(imageNamed: "CTTBackground")
        scoreLabel = SKLabelNode(text: "Score: 0")
        gameCountdownLabel = SKLabelNode(text: "\(gameTime)")
        
        player.position = CGPoint(x: self.frame.size.width/2, y: player.size.height/2 + 50)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = physic.player
        player.physicsBody?.contactTestBitMask = physic.goodThing
        
        background.position = CGPoint(x: self.frame.size.width/2, y: frame.size.height/2)
        
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 65)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontColor = UIColor.black
        
        gameCountdownLabel.position = CGPoint(x: 325, y: self.frame.size.height - 65)
        gameCountdownLabel.fontName = "AmericanTypewriter-Bold"
        gameCountdownLabel.fontColor = UIColor.black
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        addChild(background)
        addChild(player)
        addChild(gameCountdownLabel)
        
        DispatchQueue.main.async {
            self.addGoodThing()
        }
        
        DispatchQueue.main.async {
            _ = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.addGoodThing), userInfo: nil, repeats: true)
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.addBadThing), userInfo: nil, repeats: true)
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
            self.motionManager.accelerometerUpdateInterval = 0.2
            self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
                if let accelerometerData = data {
                    let acceleration = accelerometerData.acceleration
                    self.accelerateX = CGFloat(acceleration.x * 0.75) + self.accelerateX * 0.25
                }
            }
        }
        addChild(scoreLabel)
    }
    
    //fungsi tambahin bad thing
    
    @objc func addBadThing() {
        badThing = SKSpriteNode(imageNamed: "badThing")
        let baddiesPosisition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let posisition = CGFloat(baddiesPosisition.nextInt())
        
        badThing.position = CGPoint(x: posisition, y : self.frame.size.height + badThing.size.height)
        badThing.physicsBody = SKPhysicsBody(rectangleOf: badThing.size)
        badThing.physicsBody?.isDynamic = true
        badThing.physicsBody?.collisionBitMask = physic.none
        badThing.physicsBody?.categoryBitMask = physic.badThing
        badThing.physicsBody?.contactTestBitMask = physic.player
        
        self.addChild(badThing)
        
        let animationDuration: TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        DispatchQueue.main.async {
            actionArray.append(SKAction.move(to: CGPoint(x: posisition, y: -self.badThing.size.height), duration: animationDuration))
            actionArray.append(SKAction.removeFromParent())
            self.badThing.run(SKAction.sequence(actionArray))
        }
        
    }
    
    //fungsi tambahin random good thing
    
    @objc func addGoodThing() {
        goodThing = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: goodThing) as! [String]
        
        let goodiesNode = SKSpriteNode(imageNamed: goodThing[0])
        let goodiesPosisition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let posisition = CGFloat(goodiesPosisition.nextInt())
        
        goodiesNode.position = CGPoint(x: posisition, y : self.frame.size.height + goodiesNode.size.height)
        goodiesNode.physicsBody = SKPhysicsBody(rectangleOf: goodiesNode.size)
        goodiesNode.physicsBody?.isDynamic = true
        goodiesNode.physicsBody?.collisionBitMask = physic.none
        goodiesNode.physicsBody?.categoryBitMask = physic.goodThing
        goodiesNode.physicsBody?.contactTestBitMask = physic.player
        
        self.addChild(goodiesNode)
        
        let animationDuration: TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        DispatchQueue.main.async {
            actionArray.append(SKAction.move(to: CGPoint(x: posisition, y: -goodiesNode.size.height), duration: animationDuration))
            actionArray.append(SKAction.removeFromParent())
            goodiesNode.run(SKAction.sequence(actionArray))
        }
    }
    
    // fungsi countdown waktu
    
    @objc func countdown(){
        if gameTime >= 0 {
            gameTime -= 1
            print(gameTime)
        } else {
            gameTimerCount.invalidate()
        }
    }
    
    //movementnya pake di tilt
    
    override func didSimulatePhysics() {
        player.position.x += accelerateX * 50
        
        if player.position.x < 20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    // fungsi animasi player nangkep barang
    
    func catchAnimation(node: SKSpriteNode){
        let animationDuration = 0.5
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: player.position.y + 20), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        node.run(SKAction.sequence(actionArray))
    }
    
    // fungsi kalo player catch good
    
    func playerCatchGood(goodies: SKSpriteNode, player: SKSpriteNode) {
        DispatchQueue.main.async {
            self.run(SKAction.playSoundFileNamed("interactionOk", waitForCompletion: false))
        }
        let catchGoodThing = SKSpriteNode(imageNamed: "goodThingCatch")
        DispatchQueue.main.async {
            self.addChild(catchGoodThing)
        }
        catchAnimation(node: catchGoodThing)
        catchGoodThing.position = CGPoint(x: player.position.x, y: player.position.y)
        print("Good!")
        score += 10
        goodies.removeFromParent()
    }
    
    // fungsi kalo player catch bad
    
    func playerCatchBad(baddies: SKSpriteNode, player: SKSpriteNode) {
        DispatchQueue.main.async {
            self.run(SKAction.playSoundFileNamed("backButtonSFX", waitForCompletion: false))
        }
        let catchBadThing = SKSpriteNode(imageNamed: "badThingCatch")
        DispatchQueue.main.async {
            self.addChild(catchBadThing)
        }
        catchAnimation(node: catchBadThing)
        catchBadThing.position = CGPoint(x: player.position.x, y: player.position.y)
        print("Bad!")
        score -= 15
        baddies.removeFromParent()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// extensi phsycic, buat nentuin apa nabrak apa

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if ((firstBody.categoryBitMask & physic.player != 0) && (secondBody.categoryBitMask & physic.goodThing != 0)) {
            DispatchQueue.main.async {
                self.playerCatchGood(goodies: secondBody.node as! SKSpriteNode, player: firstBody.node as! SKSpriteNode)
            }
        } else if ((firstBody.categoryBitMask & physic.player != 0) && (secondBody.categoryBitMask & physic.badThing != 0)) {
            DispatchQueue.main.async {
                self.playerCatchBad(baddies: secondBody.node as! SKSpriteNode, player: firstBody.node as! SKSpriteNode)
            }
        }
    }
}
