//
//  DebugViewController.swift
//  Cathy
//
//  Created by Rangga Leo on 16/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class ChronologyViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let chronologyModel = ChronologyModel()
    let checkpointModel = CheckpointModel()
    var indexChronology: Int = 0
    var sessionShake = false
    var sessionFaceDetect = false
    
    //PROPERTY UNTUK faceDetect
    var captureSession = AVCaptureSession()
    var previewFaceDetect: CALayer!
    var permissionCameraGranted = false
    var resultFaceDetect = false
    //var backgroundMusic = backgroundSound()
    
    var data = [iconData(iconImage: UIImage(named: "mapsMenu")), iconData(iconImage: UIImage(named: "aboutMenu")), iconData(iconImage: UIImage(named: "galleryMenu")), iconData(iconImage: UIImage(named: "miniGamesMenu")), iconData(iconImage: UIImage(named: "settingsMenu")), iconData(iconImage: UIImage(named: "exitMenu"))]
    
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
    @IBOutlet weak var outletLabelText: UITextView!
    
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
        if outletGridMenu.isHidden == true {
            outletGridMenu.isHidden = false
            
        } else {
            outletGridMenu.isHidden = true
        }
    }
    
    //BUTTONS
    //Button buat next ke chronology berikutnya, bisa di ganti pake all view screen
    @IBAction func tapAnywhere(_ sender: UIView) {
        if outletGridMenu.isHidden == true {
            generateChronology(index: indexChronology)
        } else {
            
        }
        outletLabelText.text = nil
    }
    
    @IBAction func actionButtonOption(_ sender: UIButton) {
        if outletGridMenu.isHidden == true {
            generateChronology(index: sender.tag)
            animateButtonOption(button: sender)
        } else {
            //Do something
        }
    }
    
    override func viewDidLoad() {
//        cleanApp()
        //backgroundMusic.playSound()
        masks()
        startChronology(index: 0)
        generateChronology(index: chronologyModel.idChronologyCheckpoint)
        outletMenuCollectionView.delegate = self
        outletMenuCollectionView.dataSource = self
    }
    
    func cleanApp()
    {
        if checkpointModel.cleanAll() {
            UserDefaults.standard.removeObject(forKey: "UPDATE_CHRONOLOGY")
            stopCaptureSession()
            sessionShake = false
            sessionFaceDetect = false
            resultFaceDetect = false
        }
    }

    //FUNCTIONS
    func relaunch() {
        let controller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        controller.rootViewController = storyboard.instantiateInitialViewController()
        controller.rootViewController = storyboard.instantiateViewController(withIdentifier: "Main") as! ChronologyViewController
    }
    
    func startChronology(index : Int) {
        DispatchQueue.main.async {
            if self.chronologyModel.chronologies.count > 0 {
                self.outletImageViewBackgroud.image = UIImage(named: self.chronologyModel.chronologies[0].background)
            } else {
                self.chronologyModel.api.autoUpdateData(view: self.view)
                self.relaunch()
            }
            
            self.hiddenAll()
        }
    }
    
    func endChronology(index: Int) {
        //change chronology
        if(index == 999) {
            chronologyModel.idCheckpoint = chronologyModel.idCheckpoint + 1
            chronologyModel.idChronologyCheckpoint = 0
            if checkpointModel.updateObject(id: chronologyModel.idCheckpoint, idChronology: 0) {
                print("Update checkpoint new chronology")
                indexChronology = 0
                
                chronologyModel.api.autoUpdateData(view: view)
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
                
                chronologyModel.api.autoUpdateData(view: view)
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
        
        outletGridMenu.isHidden = true
    }
    
    func generateChronology(index : Int) -> Void {
        
        if chronologyModel.chronologies.count > 0 {
            
            if checkpointModel.updateObject(id: chronologyModel.idCheckpoint, idChronology: index) {
                print("checkpoint updated")
                print("id : \(chronologyModel.idCheckpoint)")
                print("id_chronology : \(index)")
            }
            let nowChronology = chronologyModel.chronologies[0].chronology[index]
        
            //filter type chronology
            DispatchQueue.main.async {
                switch nowChronology.type {
                case "text":
                    self.hiddenAll()
                    let expression = nowChronology.expression!
                    let subject = nowChronology.subject!
                    
                    self.outletImageViewChar2.image = UIImage(named: "\(expression)\(subject)")
                    self.outletLabelSubject.isHidden = false
                    self.outletLabelText.isHidden = false
                    self.outletImageViewChar2.isHidden = false
                    self.outletLabelSubject.text = nowChronology.subject
                    //outletLabelText.text = nowChronology.text
                    //implement animation
                    self.typeOn(textView: self.outletLabelText, string: nowChronology.text!)
                    self.indexChronology = nowChronology.target!
                    self.endChronology(index: nowChronology.target!)
                    break
                    
                case "option":
                    self.hiddenAll()
                    self.outletLabelSubject.isHidden = false
                    self.outletLabelSubject.text = nowChronology.subject
                    
                    let optionText = nowChronology.optionText!
                    let optionTarget = nowChronology.optionTarget!
                    
                    var optionTextUsed : [String] = []
                    
                    for i in optionText {
                        if (optionTextUsed.contains(i)) {
                            //do nothing
                        } else {
                            self.outletButtonOption1.setTitle(i, for: .normal)
                            self.outletButtonOption1.isHidden = false
                            self.outletButtonOption1.tag = optionTarget[0]
                            self.endChronology(index: optionTarget[0])
                            optionTextUsed.append(i)
                            
                            for j in optionText {
                                if optionTextUsed.contains(j) {
                                    //do nothing
                                } else {
                                    self.outletButtonOption2.setTitle(j, for: .normal)
                                    self.outletButtonOption2.isHidden = false
                                    self.outletButtonOption2.tag = optionTarget[1]
                                    self.endChronology(index: optionTarget[1])
                                    optionTextUsed.append(j)
                                    
                                    for k in optionText {
                                        if optionTextUsed.contains(k) {
                                            //do nothing
                                        } else {
                                            self.outletButtonOption3.setTitle(k, for: .normal)
                                            self.outletButtonOption3.isHidden = false
                                            self.outletButtonOption3.tag = optionTarget[2]
                                            self.endChronology(index: optionTarget[2])
                                            optionTextUsed.append(k)
                                            
                                            for l in optionText {
                                                if optionTextUsed.contains(l) {
                                                    //do nothing
                                                } else {
                                                    self.outletButtonOption4.setTitle(l, for: .normal)
                                                    self.outletButtonOption4.isHidden = false
                                                    self.outletButtonOption4.tag = optionTarget[3]
                                                    self.endChronology(index: optionTarget[3])
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
                    self.hiddenAll()
                    // outletLabelText.text = nowChronology.text
                    // implement animation
                    self.typeOn(textView: self.outletLabelText, string: nowChronology.text!)
                    self.indexChronology = nowChronology.target!
                    self.endChronology(index: nowChronology.target!)
                    self.outletLabelText.isHidden = false
                    break
                    
                case "interaction":
                    switch nowChronology.subtype {
                    case "face_detection":
                        self.sessionFaceDetect = true
                        self.runFaceDetect()
                        break
                        
                    case "shake":
                        self.sessionShake = true
                        break
                        
                    case "maps":
                        self.toMaps()
                        break
                        
                    default:
                        print("do something in interaction")
                        break
                    }
                    break
                    
                default:
                    print("something wrong with type chronology : \(nowChronology.type)")
                    break
                }
            }
            
        } else {
            relaunch()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toMaps":
            if let controllerDestination = segue.destination as? MapsViewController {
                print("controller OK")
            }
            
        default:
            print("undefined identifier segue")
        }
    }
    
    @IBAction func unwindToChronology(segue: UIStoryboardSegue) {
        if let identifierSegue = segue.identifier {
            
            switch identifierSegue {
                case "unwindToChronology":
                    generateChronology(index: indexChronology + 1)
                    print(indexChronology + 1)
                    break
                
                default:
                    print("not define identifier unwind segue")
                    break
            }
            print("\(identifierSegue)")
        
        } else {
            print("not found unwind segue")
        }
    }
    
    //TO MAPS
    func toMaps()
    {
        performSegue(withIdentifier: "toMaps", sender: self)
    }
    //END TO MAPS
    
    //HANDSHAKE
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if sessionShake {
            if event?.subtype == UIEventSubtype.motionShake {
                sessionShake = false
                indexChronology = indexChronology + 1
                generateChronology(index: indexChronology)
                print("shake ok")
            } else {
                print("shake not ok")
            }
        }
    }
    //END HANDSHAKE
    
    //FACE DETECT
    func runFaceDetect() {
        if sessionFaceDetect {
            checkPermission()
            do {
                captureSession.startRunning()
                guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {return}
                
                let captureDeviceIput = try AVCaptureDeviceInput(device: captureDevice)
                
                if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                    for input in inputs {
                        captureSession.removeInput(input)
                    }
                }
                
                if captureSession.inputs.isEmpty {
                    captureSession.addInput(captureDeviceIput)
                }
                
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                self.previewFaceDetect = previewLayer
                
                let dataOutput = AVCaptureVideoDataOutput()
                
                if captureSession.canAddOutput(dataOutput) {
                    captureSession.addOutput(dataOutput)
                }
                
                captureSession.commitConfiguration()
                dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "faceDetect"))
                
                print("face detect start running")
                
            } catch let e {
                print("Error", e)
            }
        }
    }
    
    func stopCaptureSession() {
        captureSession.stopRunning()
        
        if let input = captureSession.inputs as? [AVCaptureDeviceInput] {
            
            for i in input {
                captureSession.removeInput(i)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let context = CIContext()
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        let images = UIImage(cgImage: cgImage)
        
        if sessionFaceDetect {
            faceDetectSmile(image: images)
            
            if resultFaceDetect {
                stopCaptureSession()
                generateChronology(index: Int(indexChronology + 1))
                resultFaceDetect = false
                sessionFaceDetect = false
            }
        }
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            permissionCameraGranted = true
            break
        case .notDetermined:
            requestPermission()
            break
        default:
            permissionCameraGranted = false
            break
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
            (granted) in
            self.permissionCameraGranted = granted
        })
    }
    
    func faceDetectSmile(image: UIImage) {
        let images = CIImage(image: image)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        
        if let faces = faceDetector?.features(in: images!, options: [CIDetectorSmile: true]) {
            
            for face in faces as! [CIFaceFeature] {
                
                print(face.hasSmile)
                resultFaceDetect = face.hasSmile
            }
        }
    }
    //END FACE DETECT
    
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
    
    var timer = Timer()
    public func typeOn(textView: UITextView ,string: String) {
        let characterArray = string.characterArray
        var characterIndex = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if characterIndex != characterArray.count{
                textView.text.append(characterArray[characterIndex])
                characterIndex += 1
            }
            else if characterIndex == characterArray.count {
                timer.invalidate()
            }
        }
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
        cell.menuImageCell.image = data[indexPath.row].iconImage
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

extension String {
    var characterArray: [Character]{
        var characterArray = [Character]()
        for character in self.characters {
            characterArray.append(character)
        }
        return characterArray
    }
}

