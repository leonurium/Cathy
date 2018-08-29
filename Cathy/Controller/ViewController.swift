//
//  ViewController.swift
//  Cathy
//
//  Created by Rangga Leo on 14/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit
 
class ViewController: UIViewController {
    
    @IBOutlet weak var outNewGame: UIButton!
    @IBOutlet weak var outOption: UIButton!
    @IBOutlet weak var tapAnywhere: UILabel!
    @IBOutlet weak var cathy: UIImageView!

    //animation awal
    @IBAction func tapScreen(_ sender: Any) {
        if(tapAnywhere.isHidden == false){
            tapAnywhere.isHidden = true
            
            UIView.animate(withDuration: 2){
                self.cathy.center.x -= 225
                self.cathy.center.y -= 80
            }
            
            UIView.animate(withDuration: 1, delay: 2, options: .beginFromCurrentState, animations: {
                
                self.outNewGame.center.y -= 30
                self.outOption.center.y -= 30
                self.outNewGame.alpha = 1
                self.outOption.alpha = 1
            }, completion:
                {
                    (animate) in
                }
            )
        }else{}
    }
    
    //animation
    @IBAction func actionNewGame(_ sender: Any) {
    }
    
    @IBAction func actionOption(_ sender: Any) {
        print("ok")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.outNewGame.alpha = 0
        self.outOption.alpha = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        // Dispose of any resources that can be recreated.
    }


}

