//
//  ViewController.swift
//  outletLabelTitle
//
//  Created by Rangga Leo on 14/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit
 
class ViewController: UIViewController {
    
    @IBOutlet weak var outletNewGame: UIButton!
    @IBOutlet weak var outletOption: UIButton!
    @IBOutlet weak var outletChapterSelect: UIButton!
    @IBOutlet weak var outletContinue: UIButton!
    
    @IBOutlet weak var tapAnywhere: UILabel!
    @IBOutlet weak var outletLabelTitle: UILabel!
    
    
    
    let chronologyModel = ChronologyModel()
    
    var backgroundMusic = backgroundSound()

    //animation awal
    @IBAction func tapScreen(_ sender: Any) {
        if(tapAnywhere.isHidden == false){
            tapAnywhere.isHidden = true
            
            UIView.animate(withDuration: 2){
                self.outletLabelTitle.center.x -= 225
                self.outletLabelTitle.center.y -= 130
                
            }
            
            UIView.animate(withDuration: 1, delay: 2, options: .beginFromCurrentState, animations: {
                self.outletNewGame.center.y -= 30
                self.outletOption.center.y -= 30
                self.outletChapterSelect.center.y -= 30
                self.outletContinue.center.y -= 30
                self.outletNewGame.alpha = 1
                self.outletOption.alpha = 1
                self.outletChapterSelect.alpha = 1
                self.outletContinue.alpha = 1
                self.startChronology(index: 0)
            }, completion:
                {
                    (animate) in
                }
            )
        }else{
            
        }
    }
    
    //animation
    @IBAction func actionNewGame(_ sender: Any) {
        backgroundMusic.musicPlayer.stop()
    }
    
    @IBAction func actionOption(_ sender: Any) {
        let controller = ChronologyViewController()
        controller.cleanApp()
        print("ok")
    }
    
    override func viewDidLoad() {
        backgroundMusic.playSound(namaMusic: "intense")
        super.viewDidLoad()
        self.outletNewGame.alpha = 0
        self.outletOption.alpha = 0
        self.outletChapterSelect.alpha = 0
        animateLabel(label: tapAnywhere)
    }
    
    func startChronology(index : Int) {
        if chronologyModel.chronologies.count > 0 {
            if(chronologyModel.idCheckpoint > 0 || chronologyModel.idChronologyCheckpoint > 0) {
                outletContinue.isHidden = false
            }
        } else {
            chronologyModel.api.autoUpdateData(view: view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        // Dispose of any resources that can be recreated.
    }
    
    func animateLabel(label: UILabel)
    {
        UIView.animate(withDuration: 1.0, animations: {
            label.alpha = 0
            
        }, completion: {
            (Completed : Bool) -> Void in
            UIView.animate (withDuration: 1.0, delay:0, options: UIViewAnimationOptions.curveLinear, animations: {
                label.alpha = 1
                
            }, completion: {
                (Completed: Bool) -> Void in
                self.animateLabel(label: label)
             }
            )
        })
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

}

