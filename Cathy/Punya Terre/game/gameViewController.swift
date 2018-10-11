//
//  gameViewController.swift
//  Cathy
//
//  Created by Terretino on 09/10/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var outletLabelWaktu: UILabel!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCountdownScene()
        let countdownTime = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameViewController.update), userInfo: nil, repeats: false)
    }
    
    
    func showCountdownScene() {
            let scene = GameScene(fileNamed: "startGameScene")
            let skView = view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.presentScene(scene)
    }
    
    func showGameScene() {
            let scene = GameScene(size: view.bounds.size)
            let skView = view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.presentScene(scene)
    }
    
    @objc func update(){
        showGameScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
