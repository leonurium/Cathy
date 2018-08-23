//
//  DebugViewController.swift
//  Cathy
//
//  Created by Rangga Leo on 16/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit

class ChronologyViewController: UIViewController {
    
    let chronologyModel = ChronologyModel()
    var indexChronology: Int = 0
    
    //OUTLETS
    //Outlet button option buat choice alur
    @IBOutlet weak var outletButtonOption1: UIButton!
    @IBOutlet weak var outletButtonOption2: UIButton!
    @IBOutlet weak var outletButtonOption3: UIButton!
    @IBOutlet weak var outletButtonOption4: UIButton!
    
    //Outlet image view buat charecter sama background
    @IBOutlet weak var outletImageViewBackgroud: UIImageView!
    @IBOutlet weak var outletImageViewChar1: UIImageView!
    @IBOutlet weak var outletImageViewChar2: UIImageView!
    @IBOutlet weak var outletImageViewChar3: UIImageView!
    
    //Outlet label nama (subject) sama text conversation nya
    @IBOutlet weak var outletLabelSubject: UILabel!
    @IBOutlet weak var outletLabelText: UILabel!
    
    //Outlet menu view pojok kanan atas
    @IBOutlet weak var outletMenuChapter: UILabel!
    @IBOutlet weak var outletMenuDay: UILabel!
    @IBOutlet weak var outletMenuNoon: UILabel!
    @IBOutlet weak var outletMenuPause: UIButton!
    
    
    //BUTTONS
    //Button buat next ke chronology berikutnya, bisa di ganti pake all view screen
    @IBAction func tapAnywhere(_ sender: UIView) {
        generateChronology(index: indexChronology)
    }
    
    @IBAction func actionButtonOption(_ sender: UIButton) {
        generateChronology(index: sender.tag)
        animateButtonOption(button: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        masks()
        startChronology(index: 0)
        generateChronology(index: 0)
    }
    
    
    //FUNCTIONS
    func startChronology(index : Int) {
        outletImageViewBackgroud.image = UIImage(named: chronologyModel.chronologies[index].background)
        
        hiddenAll()
    }
    
    func hiddenAll() {
        outletButtonOption1.isHidden = true
        outletButtonOption2.isHidden = true
        outletButtonOption3.isHidden = true
        outletButtonOption4.isHidden = true
        
        outletImageViewChar1.isHidden = true
        outletImageViewChar2.isHidden = true
        outletImageViewChar3.isHidden = true
        
        outletLabelSubject.isHidden = true
        outletLabelText.isHidden = true
    }
    
    func generateChronology(index : Int) -> Void {
        let nowChronology = chronologyModel.chronologies[0].chronology[index]!
        
        //filter type chronology
        switch nowChronology["type"] as? String {
        case "text":
            hiddenAll()
            outletLabelSubject.isHidden = false
            outletLabelText.isHidden = false
            
            outletLabelSubject.text = nowChronology["subject"] as? String
            outletLabelText.text = nowChronology["text"] as? String
            indexChronology = nowChronology["target"] as! Int
            break
            
        case "option":
            hiddenAll()
            outletLabelSubject.isHidden = false
            outletLabelSubject.text = nowChronology["subject"] as? String
            
            let optionText = nowChronology["optionText"] as! [String]
            let optionTarget = nowChronology["optionTarget"] as! [Int]
            
            var optionTextUsed : [String] = []
            
            for i in optionText {
                if (optionTextUsed.contains(i)) {
                    //do nothing
                } else {
                    outletButtonOption1.setTitle(i, for: .normal)
                    outletButtonOption1.isHidden = false
                    outletButtonOption1.tag = optionTarget[0]
                    optionTextUsed.append(i)
                    
                    for j in optionText {
                        if optionTextUsed.contains(j) {
                            //do nothing
                        } else {
                            outletButtonOption2.setTitle(j, for: .normal)
                            outletButtonOption2.isHidden = false
                            outletButtonOption2.tag = optionTarget[1]
                            optionTextUsed.append(j)
                            
                            for k in optionText {
                                if optionTextUsed.contains(k) {
                                    //do nothing
                                } else {
                                    outletButtonOption3.setTitle(k, for: .normal)
                                    outletButtonOption3.isHidden = false
                                    outletButtonOption3.tag = optionTarget[2]
                                    optionTextUsed.append(k)
                                    
                                    for l in optionText {
                                        if optionTextUsed.contains(l) {
                                            //do nothing
                                        } else {
                                            outletButtonOption4.setTitle(l, for: .normal)
                                            outletButtonOption4.isHidden = false
                                            outletButtonOption4.tag = optionTarget[3]
                                            optionTextUsed.append(l)
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            break
            
        case "narator":
            hiddenAll()
            outletLabelText.text = nowChronology["text"] as? String
            indexChronology = nowChronology["target"] as! Int
            outletLabelText.isHidden = false
            break
            
        case "interaction":
            print("OK ini interaksi")
            break
            
        default:
            print("something wrong with type chronology")
            break
        }
    }
    
    func labelMask(label : UILabel){
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
    }
    
    func buttonMask(button : UIButton){
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
    }
    
    //MASKS
    func masks(){
        // MENU MASKS
        //Menu
        labelMask(label: outletMenuChapter)
        labelMask(label: outletMenuNoon)
        labelMask(label: outletMenuDay)
        outletMenuPause.layer.cornerRadius = 5
        outletMenuPause.layer.masksToBounds = true
    
        
        //CHOOSE BOX MASKS
        buttonMask(button: outletButtonOption1)
        buttonMask(button: outletButtonOption2)
        buttonMask(button: outletButtonOption3)
        buttonMask(button: outletButtonOption4)

    }
    
    //ANIMATION
    func animateButtonOption(button: UIButton)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
