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
    
    //Button option buat choice alur
    @IBOutlet weak var outletButtonOption1: UIButton!
    @IBOutlet weak var outletButtonOption2: UIButton!
    @IBOutlet weak var outletButtonOption3: UIButton!
    @IBOutlet weak var outletButtonOption4: UIButton!
    
    //Button buat next ke chronology berikutnya, bisa di ganti pake all view screen
    @IBOutlet weak var outletButtonNext: UIButton!
    
    //Outlet image view buat charecter sama background
    @IBOutlet weak var outletImageViewBackgroud: UIImageView!
    @IBOutlet weak var outletImageViewChar1: UIImageView!
    @IBOutlet weak var outletImageViewChar2: UIImageView!
    @IBOutlet weak var outletImageViewChar3: UIImageView!
    
    //outlet label nama (subject) sama text conversation nya
    @IBOutlet weak var outletLabelSubject: UILabel!
    @IBOutlet weak var outletLabelText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startChronology(index: 0)
        generateChronology(index: 0)
        
    }
    
    func startChronology(index : Int) {
        outletImageViewBackgroud.image = UIImage(named: chronologyModel.chronologies[index].background)
        
        hiddenAll()
    }
    
    func hiddenAll() {
        outletButtonOption1.isHidden = true
        outletButtonOption2.isHidden = true
        outletButtonOption3.isHidden = true
        outletButtonOption4.isHidden = true
        
        outletButtonNext.isHidden = true
        
        outletImageViewChar1.isHidden = true
        outletImageViewChar2.isHidden = true
        outletImageViewChar3.isHidden = true
        
        outletLabelSubject.isHidden = true
        outletLabelText.isHidden = true
    }
    
    @IBAction func actionButtonNext(_ sender: UIButton) {
        generateChronology(index: sender.tag)
    }
    
    @IBAction func actionButtonOption(_ sender: UIButton) {
        generateChronology(index: sender.tag)
    }
    
    func generateChronology(index : Int) -> Void {
        let nowChronology = chronologyModel.chronologies[0].chronology[index]!
        
        //filter type chronology
        
        switch nowChronology["type"] as? String {
        case "text":
            hiddenAll()
            outletLabelSubject.isHidden = false
            outletLabelText.isHidden = false
            outletButtonNext.isHidden = false
            
            outletLabelSubject.text = nowChronology["subject"] as? String
            outletLabelText.text = nowChronology["text"] as? String
            outletButtonNext.tag = nowChronology["target"] as! Int
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
            outletButtonNext.tag = nowChronology["target"] as! Int
            outletLabelText.isHidden = false
            outletButtonNext.isHidden = false
            break
            
        case "interaction":
            print("OK ini interaksi")
            break
            
        default:
            print("something wrong with type chronology")
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
