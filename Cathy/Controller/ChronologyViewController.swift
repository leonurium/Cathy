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
    let checkpointModel = CheckpointModel()
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
    
    //Outlet Grid Menu
    @IBOutlet weak var outletGridMenu: UIView!
    @IBOutlet weak var outletMenuCollectionView: UICollectionView!
    
    @IBAction func actionButtonCloseMenu(_ sender: Any) {
        outletGridMenu.isHidden = true
    }
    
    @IBAction func actionButtonMenu(_ sender: Any) {
        if outletGridMenu.isHidden == true{
        outletGridMenu.isHidden = false
        }else{
            outletGridMenu.isHidden = true
        }
    }
    
    //BUTTONS
    //Button buat next ke chronology berikutnya, bisa di ganti pake all view screen
    @IBAction func tapAnywhere(_ sender: UIView) {
        if outletGridMenu.isHidden == true{
        generateChronology(index: indexChronology)
        }else{
            
        }
    }
    
    @IBAction func actionButtonOption(_ sender: UIButton) {
        generateChronology(index: sender.tag)
        animateButtonOption(button: sender)
    }
    
    override func viewDidLoad() {
        masks()
        startChronology(index: 0)
        generateChronology(index: chronologyModel.idChronologyCheckpoint)
        outletMenuCollectionView.delegate = self
        outletMenuCollectionView.dataSource = self
    }

    //FUNCTIONS
    func relaunch() {
        let controller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    func startChronology(index : Int) {
        if chronologyModel.chronologies.count > 0 {
            outletImageViewBackgroud.image = UIImage(named: chronologyModel.chronologies[0].background)
        } else {
            chronologyModel.api.autoUpdateData()
            relaunch()
        }
        
        hiddenAll()
    }
    
    func endChronology(index: Int) {
        //change chronology
        if(index == 999) {
            chronologyModel.idCheckpoint = chronologyModel.idCheckpoint + 1
            chronologyModel.idChronologyCheckpoint = 0
            if checkpointModel.updateObject(id: chronologyModel.idCheckpoint, idChronology: 0) {
                print("Update checkpoint new chronology")
                indexChronology = 0
                
                chronologyModel.api.autoUpdateData()
                let newChronology = chronologyModel.api.getFromDisk(id: chronologyModel.idCheckpoint)
                
                if newChronology.count > 0 {
                    chronologyModel.chronologies.removeAll()
                    chronologyModel.chronologies = newChronology
                    generateChronology(index: 0)
                    print("END Chronology")
                    
                } else {
                    print("To be continued")
                }
            }
            
            //change chapter
        } else if(index == 1000) {
            chronologyModel.idCheckpoint = chronologyModel.idCheckpoint + 1
            chronologyModel.idChronologyCheckpoint = 0
            if checkpointModel.updateObject(id: chronologyModel.idCheckpoint, idChronology: 0) {
                print("Update checkpoint new Chapter")
                indexChronology = 0
                
                chronologyModel.api.autoUpdateData()
                let newChronology = chronologyModel.api.getFromDisk(id: chronologyModel.idCheckpoint)
                
                if newChronology.count > 0 {
                    chronologyModel.chronologies.removeAll()
                    chronologyModel.chronologies = newChronology
                    generateChronology(index: 0)
                    print("END chapter")
                    
                } else {
                    print("To be continued")
                }
            }
        }
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
        
        if chronologyModel.chronologies.count > 0 {
            
            if checkpointModel.updateObject(id: chronologyModel.idCheckpoint, idChronology: index) {
                print("checkpoint updated")
            }
            let nowChronology = chronologyModel.chronologies[0].chronology[index]
        
            //filter type chronology
            switch nowChronology.type {
            case "text":
                hiddenAll()
                outletLabelSubject.isHidden = false
                outletLabelText.isHidden = false
                
                outletLabelSubject.text = nowChronology.subject
                outletLabelText.text = nowChronology.text
                indexChronology = nowChronology.target!
                endChronology(index: nowChronology.target!)
                break
                
            case "option":
                hiddenAll()
                outletLabelSubject.isHidden = false
                outletLabelSubject.text = nowChronology.subject
                
                let optionText = nowChronology.optionText!
                let optionTarget = nowChronology.optionTarget!
                
                var optionTextUsed : [String] = []
                
                for i in optionText {
                    if (optionTextUsed.contains(i)) {
                        //do nothing
                    } else {
                        outletButtonOption1.setTitle(i, for: .normal)
                        outletButtonOption1.isHidden = false
                        outletButtonOption1.tag = optionTarget[0]
                        endChronology(index: optionTarget[0])
                        optionTextUsed.append(i)
                        
                        for j in optionText {
                            if optionTextUsed.contains(j) {
                                //do nothing
                            } else {
                                outletButtonOption2.setTitle(j, for: .normal)
                                outletButtonOption2.isHidden = false
                                outletButtonOption2.tag = optionTarget[1]
                                endChronology(index: optionTarget[1])
                                optionTextUsed.append(j)
                                
                                for k in optionText {
                                    if optionTextUsed.contains(k) {
                                        //do nothing
                                    } else {
                                        outletButtonOption3.setTitle(k, for: .normal)
                                        outletButtonOption3.isHidden = false
                                        outletButtonOption3.tag = optionTarget[2]
                                        endChronology(index: optionTarget[2])
                                        optionTextUsed.append(k)
                                        
                                        for l in optionText {
                                            if optionTextUsed.contains(l) {
                                                //do nothing
                                            } else {
                                                outletButtonOption4.setTitle(l, for: .normal)
                                                outletButtonOption4.isHidden = false
                                                outletButtonOption4.tag = optionTarget[3]
                                                endChronology(index: optionTarget[3])
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
                
            case "narator" :
                hiddenAll()
                outletLabelText.text = nowChronology.text
                indexChronology = nowChronology.target!
                endChronology(index: nowChronology.target!)
                outletLabelText.isHidden = false
                break
                
            case "interaction":
                switch nowChronology.subtype {
                    case "face_detection":
                        faceDetect()
                        break
                    
                    default:
                        print("do something in interaction")
                        break
                }
                break
                
            default:
                print("something wrong with type chronology")
                break
            }
        
        } else {
            relaunch()
        }
    }
    
    func faceDetect() {
        let controller = UIStoryboard(name: "Screen", bundle: nil).instantiateViewController(withIdentifier: "FaceDetect") as! FaceDetectViewController
        self.addChildViewController(controller)
        
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
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

extension ChronologyViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testMenu", for: indexPath) as! menuCollectionViewCell
        cell.menuImageCell.image = (UIImage(named: "happyTerre"))
        return cell
    }
}

extension ChronologyViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            performSegue(withIdentifier: "map", sender: self)
        }else if(indexPath.row == 1){
            performSegue(withIdentifier: "about", sender: self)
        }else if(indexPath.row == 2){
            performSegue(withIdentifier: "gallery", sender: self)
        }else if(indexPath.row == 3){
            performSegue(withIdentifier: "miniGames", sender: self)
        }else if(indexPath.row == 4){
            performSegue(withIdentifier: "option", sender: self)
        }else if(indexPath.row == 5){
            performSegue(withIdentifier: "exit", sender: self)
        }
    }
}



