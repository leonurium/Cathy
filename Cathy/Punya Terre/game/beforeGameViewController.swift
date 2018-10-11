//
//  beforeGameViewController.swift
//  Cathy
//
//  Created by Terretino on 10/10/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class beforeGameUIViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var gameTutorialPageControl: UIPageControl!
    @IBOutlet weak var gameScrollViewController: UIScrollView!
    
    var images: [String] = ["game1Tutor0", "game1Tutor1", "game1Tutor2"]
    var frame = CGRect(x:0,y:0,width:0,height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTutorialPageControl.numberOfPages = images.count
        for i in 0..<images.count {
            frame.origin.x = gameScrollViewController.frame.size.width * CGFloat(i)
            frame.size = gameScrollViewController.frame.size
            let tutorialView = UIImageView(frame: frame)
            tutorialView.image = UIImage(named: images[i])
            self.gameScrollViewController.addSubview(tutorialView)
        }
        gameScrollViewController.contentSize = CGSize(width: (gameScrollViewController.frame.size.width * CGFloat(images.count)), height: (gameScrollViewController.frame.size.height))
        gameScrollViewController.delegate = self
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = gameScrollViewController.contentOffset.x / gameScrollViewController .frame.size.width
        gameTutorialPageControl.currentPage = Int(pageNumber)
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
