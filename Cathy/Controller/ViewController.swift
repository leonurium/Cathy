//
//  ViewController.swift
//  outletLabelTitle
//
//  Created by Rangga Leo on 14/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit
import CloudKit
 
class ViewController: UIViewController {
    
    @IBOutlet weak var outletNewGame: UIButton!
    @IBOutlet weak var outletOption: UIButton!
    @IBOutlet weak var outletChapterSelect: UIButton!
    @IBOutlet weak var outletContinue: UIButton!
    @IBOutlet weak var outletImageBG: UIImageView!
    
    @IBOutlet weak var tapAnywhere: UILabel!
    @IBOutlet weak var outletLabelTitle: UILabel!
    
    
    
    let chronologyModel = ChronologyModel()
    
    var backgroundMusic = backgroundSound.shared

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
                self.outletImageBG.alpha = 1
                
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
//        backgroundMusic.musicPlayer.stop()
        let controller = ChronologyViewController()
        controller.cleanApp()
        print("ok")
    }
    
    @IBAction func actionOption(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        backgroundMusic.playSound(namaMusic: "defaultMusic")
        super.viewDidLoad()
        self.outletNewGame.alpha = 0
        self.outletOption.alpha = 0
        self.outletChapterSelect.alpha = 0
        self.outletContinue.alpha = 0
        animateLabel(label: tapAnywhere)
        
        //NO function
        outletChapterSelect.isHidden = true
        outletOption.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.startChronology(_:)), name: Notification.Name(String(describing: ReachabilityWrapper.self)), object: nil)
        ReachabilityWrapper().monitorReachabilityChanges()
    }
    
    @objc func startChronology(_ notification: NSNotification) {
        if chronologyModel.chronologies.count > 0 {
            if(chronologyModel.idCheckpoint > 0 || chronologyModel.idChronologyCheckpoint > 0) {
                outletContinue.isHidden = false
            }
        } else {
            let status = ReachabilityWrapper().connectionStatus()
            switch status {
                
            case .offline:
                print("Offline")
                break
                
            case .online(.wwan), .unknown:
                print("koneksi kurang stable")
                break
                
            case .online(.wiFi):
                let progressCloud = CloudKitProgress(record: CKRecord(recordType: "ProgressCeritaku"))
                
                if let dataProgress = progressCloud.fetchObject() {
                    if dataProgress.count > 0 {
                        chronologyModel.checkpoint.updateObject(id: dataProgress[0].id, idChronology: dataProgress[0].id_chronology)
                    }
                }
                
                chronologyModel.api.autoUpdateData(view: view)
                break
            }
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
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        if let identifierSegue = segue.identifier {
            
            switch identifierSegue {
            case "unwindToHomeFromChronology":
                print("OK \(identifierSegue)")
                break
                
            default:
                print("undefine identifier \(identifierSegue)")
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

}

