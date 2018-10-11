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
    
    
    let motionManager = CMMotionManager()
    let gameTimerCount = Timer()
    var accelerateX: CGFloat = 0
    var player: SKSpriteNode!
    var goodThing = ["goodthing1", "goodthing2"]
    var badThing: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: self.frame.size.width/2, y: player.size.height/2 + 50)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = physic.player
        player.physicsBody?.contactTestBitMask = physic.goodThing
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        addChild(player)
        DispatchQueue.main.async {
            self.addGoodThing()
        }
        
        DispatchQueue.main.async {
            let gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.addGoodThing), userInfo: nil, repeats: true)
            let gameTimerBad = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.addBadThing), userInfo: nil, repeats: true)
            self.motionManager.accelerometerUpdateInterval = 0.2
            self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
                if let accelerometerData = data {
                    let acceleration = accelerometerData.acceleration
                    self.accelerateX = CGFloat(acceleration.x * 0.75) + self.accelerateX * 0.25
                }
            }
        }
    }
    
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
    
    //movementnya pake di tilt
    
    override func didSimulatePhysics() {
        player.position.x += accelerateX * 50
        
        if player.position.x < 20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    func playerCatchGood(goodies: SKSpriteNode, player: SKSpriteNode) {
        print("Good!")
        goodies.removeFromParent()
    }
    
    func playerCatchBad(baddies: SKSpriteNode, player: SKSpriteNode) {
        print("Bad!")
        baddies.removeFromParent()
    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for touch in touches {
    //            DispatchQueue.global().async {
    //                let location = touch.location(in: self.player)
    //                self.player.position.x = location.x
    //                self.player.position.y = self.player.position.y
    //            }
    //        }
    //    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

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
