//
//  ViewController.swift
//  Cathy
//
//  Created by Rangga Leo on 14/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var newGamelbl: UILabel!
    @IBOutlet weak var optionlbl: UILabel!
    @IBOutlet weak var tapAnywhere: UILabel!
    @IBOutlet weak var cathy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newGamelbl.alpha = 0
        self.optionlbl.alpha = 0
    }

    @IBAction func tapScreen(_ sender: Any) {
        if(tapAnywhere.isHidden == false){
            tapAnywhere.isHidden = true
            
            UIView.animate(withDuration: 2){
                self.cathy.center.x -= 225
                self.cathy.center.y -= 80
            }
            
            UIView.animate(withDuration: 1, delay: 2, options: .beginFromCurrentState, animations: {
                
                
                self.newGamelbl.center.y -= 30
                self.optionlbl.center.y -= 30
                self.newGamelbl.alpha = 1
                self.optionlbl.alpha = 1
            }, completion:
                {
                    (animate) in
                }
            )
        }else{}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

