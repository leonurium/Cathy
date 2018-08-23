//
//  textBoxDialogue.swift
//  Cathy
//
//  Created by Victor  Christopher on 16/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit

class textBoxDialogue: UIViewController {
    //OUTLETS
    @IBOutlet weak var dialogueLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    // character box
    @IBOutlet weak var mainCharacterBox: UIImageView!
    @IBOutlet weak var firstCharBox: UIImageView!
    @IBOutlet weak var secondCharBox: UIImageView!
    
    //menu outlets
    @IBOutlet weak var outButtonMenu: UIButton!
    @IBOutlet weak var outChapterLbl: UILabel!
    @IBOutlet weak var outDayLbl: UILabel!
    @IBOutlet weak var outNoonLbl: UILabel!
    
    //choose outlets
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var outChoosefirst: UIButton!
    @IBOutlet weak var outChooseSecond: UIButton!
    @IBOutlet weak var outChooseThird: UIButton!
    @IBOutlet weak var outChooseFourth: UIButton!
    
    //func animate
    func animateButton(button: UIButton)
    {
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 0
            
        }, completion: {
            (Completed : Bool) -> Void in
            UIView.animate (withDuration: 0.5, delay:0, options: UIViewAnimationOptions.curveLinear, animations: {
                button.alpha = 1
                
            })
        })
    }
    
    //ACTIONS
    //choose actions
    @IBAction func actionChooseFirst(_ sender: Any) {
        animateButton(button: outChoosefirst)
    }
    
    @IBAction func actionChooseSecond(_ sender: Any) {
        animateButton(button: outChooseSecond)
    }
    
    @IBAction func actionChooseThird(_ sender: Any) {
        animateButton(button: outChooseThird)

    }
    
    @IBAction func actionChooseFourth(_ sender: Any) {
        animateButton(button: outChooseFourth)
    }
    
    //button menu
    @IBAction func actionButtonMenu(_ sender: Any) {
        if(chooseView.isHidden == true){
            chooseView.isHidden = false
        }else{
            chooseView.isHidden = true
        }
    }
    
    //tap anywhere (next)
    @IBAction func tapAnywhere(_ sender: Any) {
        print("ok")
    }

    func masks(){
        // MENU MASKS
        //menu
        outButtonMenu.layer.cornerRadius = 5
        outButtonMenu.layer.masksToBounds = true
        //chapter
        outChapterLbl.layer.cornerRadius = 5
        outChapterLbl.layer.masksToBounds = true
        //day
        outDayLbl.layer.cornerRadius = 5
        outDayLbl.layer.masksToBounds = true
        //noon
        outNoonLbl.layer.cornerRadius = 5
        outNoonLbl.layer.masksToBounds = true
        
        //CHOOSE BOX MASKS
        //first box
        outChoosefirst.layer.cornerRadius = 5
        outChoosefirst.layer.masksToBounds = true
        
        //second box
        outChooseSecond.layer.cornerRadius = 5
        outChooseSecond.layer.masksToBounds = true
        
        //third box
        outChooseThird.layer.cornerRadius = 5
        outChooseThird.layer.masksToBounds = true
        
        //fourth box
        outChooseFourth.layer.cornerRadius = 5
        outChooseFourth.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        masks()
        backgroundImg.image = UIImage(named: "room")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
