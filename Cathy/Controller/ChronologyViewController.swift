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
    
    var playerName = UIDevice.current.name
    
    var animModel = animasiIdle()
    var backgroundMusic = backgroundSound.shared
    
    var tempTypeOn: Int = 0
    var tempBanyakCharacter: Int = 0
    
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
    @IBOutlet weak var outletImageViewTextBox: UIImageView!
    @IBOutlet weak var outletContinueButton: UIImageView!
    
    
    //Outlet menu view pojok kanan atas
    @IBOutlet weak var outletMenuChapter: UILabel!
    @IBOutlet weak var outletMenuNoon: UILabel!
    @IBOutlet weak var outletMenuPause: UIButton!
    
    //Outlet Menu
    @IBOutlet weak var outletMenu: UIView!
    @IBOutlet weak var outletLog: UIButton!
    @IBOutlet weak var outletSetting: UIButton!
    @IBOutlet weak var outletExit: UIButton!
    
    
    //Outlet Indicator Interaction
    @IBOutlet weak var outletIndicator: UIImageView!
    
    
    @IBAction func actionButtonCloseMenu(_ sender: Any) {
        outletMenu.isHidden = true
    }
    
    @IBAction func actionButtonMenu(_ sender: Any) {
        if outletMenu.isHidden == true {
            outletMenu.isHidden = false
        } else {
            outletMenu.isHidden = true
        }
    }
    
    //BUTTONS
    
    //Button buat next ke chronology berikutnya, bisa di ganti pake all view screen
    @IBAction func tapAnywhere(_ sender: UIView) {
        if outletMenu.isHidden == true {
            generateChronology(index: indexChronology)
        } else {
            
        }
        // outletLabelText.text = nil
    }
    
    @IBAction func actionButtonOption(_ sender: UIButton) {
        if outletMenu.isHidden == true {
            generateChronology(index: sender.tag)
            animateButtonOption(button: sender)
        } else {
            //Do something
        }
    }
    
    override func viewDidLoad() {
        //backgroundMusic.playSound()
        defineName()
        border()
        masks()
        animateButtonContinue(img: outletContinueButton)
        startChronology(index: 0)
        generateChronology(index: chronologyModel.idChronologyCheckpoint)
    }
    
    func defineName() {
        var name = self.playerName.replacingOccurrences(of: "’s iPhone", with: "")
        name = name.replacingOccurrences(of: "iPhone X", with: "")
        name = name.replacingOccurrences(of: "iPhone", with: "")
        print("name \(name)")
        switch name.lowercased() {
        case "":
            self.playerName = "Eka"
            break
            
        default:
            self.playerName = name
            break
        }
        
        print("after define \(playerName)")
    }
    
    //function untuk border
    func border(){
        //menus
        addBorderView(view: outletMenu)
        addBorderButton(button: outletMenuPause)
        addBorderButton(button: outletLog)
        addBorderButton(button: outletSetting)
        addBorderButton(button: outletExit)
      
        
        //button choices
        addBorderButton(button: outletButtonOption1)
        addBorderButton(button: outletButtonOption2)
        addBorderButton(button: outletButtonOption3)
        addBorderButton(button: outletButtonOption4)
    }
    func addBorderLabel(label : UILabel){
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
    }
    
    func addBorderButton(button : UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func addBorderView(view : UIView){
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
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
             // controller.rootViewController = storyboard.instantiateInitialViewController()
        controller.rootViewController = storyboard.instantiateViewController(withIdentifier: "Main") as! ChronologyViewController
    }
    
    func startChronology(index : Int) {
        DispatchQueue.main.async {
            if self.chronologyModel.chronologies.count > 0 {
                self.outletMenuChapter.text = "Chapter \(self.chronologyModel.idCheckpoint + 1)"
                self.outletMenuNoon.text = "\(self.chronologyModel.chronologies[0].title)"
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
                    outletMenuChapter.text = "Chapter \(chronologyModel.idCheckpoint + 1)"
                    outletMenuNoon.text = "\(chronologyModel.chronologies[0].title)"
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
        outletLabelText.text = ""
        outletLabelText.isHidden = true
        
        outletMenu.isHidden = true
        outletIndicator.isHidden = true
        
        //TO default
        outletImageViewTextBox.image = UIImage(named: "textBoxDialogue")
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
                        
                        if let backgroundImage = nowChronology.background {
                            self.outletImageViewBackgroud.image = UIImage(named: backgroundImage)
                            
                        }
                        
                        if let subject = nowChronology.subject {
                            self.outletLabelSubject.isHidden = false
                            let sbj = subject.replacingOccurrences(of: "(nama)", with: self.playerName)
                            self.outletLabelSubject.text = sbj
                        }
                        
                        if let textConversation = nowChronology.text {
                            let txtConversation = textConversation.replacingOccurrences(of: "(nama)", with: self.playerName)
                            self.outletLabelText.isHidden = false
                            self.typeOn(textView: self.outletLabelText, string: txtConversation)
                        }
                        
                        if let subjectChronology = nowChronology.subjectChronology {
                            
                            if subjectChronology.indices.contains(0) {
                                if let subject = subjectChronology[0].subject,
                                    let expression = subjectChronology[0].expression
                                {
                                    self.outletImageViewChar2.isHidden = false
                                    
                                    let animasiKarakter = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                    self.animModel.animasi(imageView: self.outletImageViewChar2, images: animasiKarakter)
                                }
                            }
                            
                            if subjectChronology.indices.contains(1) {
                                if let subject = subjectChronology[1].subject,
                                    let expression = subjectChronology[1].expression
                                {
                                    self.outletImageViewChar1.isHidden = false
                                    let animasiKarakter2 = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                    self.animModel.animasi(imageView: self.outletImageViewChar1, images: animasiKarakter2)
                                }
                            }
                            
                            if subjectChronology.indices.contains(2) {
                                if let subject = subjectChronology[2].subject,
                                    let expression = subjectChronology[2].expression
                                {
                                    self.outletImageViewChar3.isHidden = false
                                    let animasiKarakter3 = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                    self.animModel.animasi(imageView: self.outletImageViewChar3, images: animasiKarakter3)
                                }
                            }
                        }
                        
                        if let target = nowChronology.target {
                            self.indexChronology = target
                            self.endChronology(index: target)
                        }
                    break
            
                    
                case "option":
                    self.hiddenAll()
                    
                    if let backgroundImage = nowChronology.background {
                        self.outletImageViewBackgroud.image = UIImage(named: backgroundImage)
                        
                    }
                    
                    if let subject = nowChronology.subject {
                        self.outletLabelSubject.isHidden = false
                        let sbj = subject.replacingOccurrences(of: "(nama)", with: self.playerName)
                        self.outletLabelSubject.text = sbj
                    }
                    
                    if let textConversation = nowChronology.text {
                        let txtConversation = textConversation.replacingOccurrences(of: "(nama)", with: self.playerName)
                        self.outletLabelText.isHidden = false
                        self.typeOn(textView: self.outletLabelText, string: txtConversation)
                    }
                    
                    if let subjectChronology = nowChronology.subjectChronology {
                        
                        if subjectChronology.indices.contains(0) {
                            if let subject = subjectChronology[0].subject,
                                let expression = subjectChronology[0].expression
                            {
                                self.outletImageViewChar2.isHidden = false
                                let animasiKarakter = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                self.animModel.animasi(imageView: self.outletImageViewChar2, images: animasiKarakter)
                            }
                        }
                        
                        if subjectChronology.indices.contains(1) {
                            if let subject = subjectChronology[1].subject,
                                let expression = subjectChronology[1].expression
                            {
                                self.outletImageViewChar1.isHidden = false
                                let animasiKarakter2 = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                self.animModel.animasi(imageView: self.outletImageViewChar1, images: animasiKarakter2)
                            }
                        }
                        
                        if subjectChronology.indices.contains(2) {
                            if let subject = subjectChronology[2].subject,
                                let expression = subjectChronology[2].expression
                            {
                                self.outletImageViewChar3.isHidden = false
                                let animasiKarakter3 = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                self.animModel.animasi(imageView: self.outletImageViewChar3, images: animasiKarakter3)
                            }
                        }
                    }
                    
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
                    
                case "narator" :
                    self.hiddenAll()
                    self.outletImageViewTextBox.image = UIImage(named: "textBoxNarrator")
                    
                    if let backgroundImage = nowChronology.background {
                        self.outletImageViewBackgroud.image = UIImage(named: backgroundImage)
                    }
                    
                    if let textConversation = nowChronology.text {
                        let txtConversation = textConversation.replacingOccurrences(of: "(nama)", with: self.playerName)
                        self.outletLabelText.isHidden = false
                        self.typeOn(textView: self.outletLabelText, string: txtConversation)
                    }
                    
                    self.indexChronology = nowChronology.target!
                    self.endChronology(index: nowChronology.target!)
                    break
                    
                case "interaction":
                    self.hiddenAll()
                    if let backgroundImage = nowChronology.background {
                        self.outletImageViewBackgroud.image = UIImage(named: backgroundImage)
                    }
                    
                    if let subject = nowChronology.subject {
                        self.outletLabelSubject.isHidden = false
                        let sbj = subject.replacingOccurrences(of: "(nama)", with: self.playerName)
                        self.outletLabelSubject.text = sbj
                    }
                    
                    if let textConversation = nowChronology.text {
                        let txtConversation = textConversation.replacingOccurrences(of: "(nama)", with: self.playerName)
                        self.outletLabelText.isHidden = false
                        self.typeOn(textView: self.outletLabelText, string: txtConversation)
                    }
                    
                    if let subjectChronology = nowChronology.subjectChronology {
                        
                        if subjectChronology.indices.contains(0) {
                            if let subject = subjectChronology[0].subject,
                                let expression = subjectChronology[0].expression
                            {
                                self.outletImageViewChar2.isHidden = false
                                
                                let animasiKarakter = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                self.animModel.animasi(imageView: self.outletImageViewChar2, images: animasiKarakter)
                            }
                        }
                        
                        if subjectChronology.indices.contains(1) {
                            if let subject = subjectChronology[1].subject,
                                let expression = subjectChronology[1].expression
                            {
                                self.outletImageViewChar1.isHidden = false
                                let animasiKarakter2 = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                self.animModel.animasi(imageView: self.outletImageViewChar1, images: animasiKarakter2)
                            }
                        }
                        
                        if subjectChronology.indices.contains(2) {
                            if let subject = subjectChronology[2].subject,
                                let expression = subjectChronology[2].expression
                            {
                                self.outletImageViewChar3.isHidden = false
                                let animasiKarakter3 = self.animModel.buatImageArray(total: 15, imagePrefix: "\(expression)\(subject)-")
                                self.animModel.animasi(imageView: self.outletImageViewChar3, images: animasiKarakter3)
                            }
                        }
                    }
                    
                    switch nowChronology.subtype {
                    case "face_detection":
                        self.outletIndicator.isHidden = false
                        let shakeIndicator = self.animModel.buatImageArray(total: 2, imagePrefix: "indicatorSmile-")
                        self.animModel.animasiIndicator(imageView: self.outletIndicator, images: shakeIndicator)
                        self.sessionFaceDetect = true
                        self.runFaceDetect()
                        break
                        
                    case "shake":
                        self.outletIndicator.isHidden = false
                        let shakeIndicator = self.animModel.buatImageArray(total: 2, imagePrefix: "indicator-")
                        self.animModel.animasiIndicator(imageView: self.outletIndicator, images: shakeIndicator)
                        self.sessionShake = true
                        break
                        
                    case "maps":
                        self.toMaps()
                        break
                        
                    case "game1":
                        self.backgroundMusic.musicPlayer.stop()
                        self.performSegue(withIdentifier: "toGame1", sender: nil)
                        
                    default:
                        print("do something in interaction")
                        break
                    }
                    break
                    
                default:
                    print("Error : not define type chronology \(nowChronology.type)")
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
                controllerDestination.currentChapter = chronologyModel.idCheckpoint
                print("to Maps OK")
            }
            
        case "toGame1":
            print("to Game1 OK")
            
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
                
            case "unwindToChapter":
                if let ctrl = segue.source as? MapsViewController {
                    chronologyModel.idCheckpoint = ctrl.currentChapter
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
                    
                } else {
                    print("undefine maps controller")
                }
                break
                
            case "unwindToChronologyFromGame1":
                generateChronology(index: indexChronology + 1)
                print(indexChronology + 1)
                print("OK from game")
                
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
    
    func menuMask(button : UIButton){
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
    }
    
    //MASKS
    func masks(){
        // MENU MASKS
        //Menu
        labelMask(label: outletMenuChapter)
        labelMask(label: outletMenuNoon)
        
        //CHOOSE BOX MASKS
        buttonMask(button: outletButtonOption1)
        buttonMask(button: outletButtonOption2)
        buttonMask(button: outletButtonOption3)
        buttonMask(button: outletButtonOption4)
        
        //outlet menu
        menuMask(button: outletMenuPause)
        menuMask(button: outletLog)
        menuMask(button: outletSetting)
        menuMask(button: outletExit)
        outletMenu.layer.cornerRadius = 10
        outletMenu.layer.masksToBounds = true
        
        
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
    
    func animateButtonContinue(img: UIImageView)
    {
        UIView.animate(withDuration: 1.0, animations: {
            img.center.y -= 15
            
        }, completion: {
            (Completed : Bool) -> Void in
            UIView.animate (withDuration: 0.75, delay:0, options: UIViewAnimationOptions.curveLinear, animations: {
                img.center.y += 15
            }, completion: {
                (Completed: Bool) -> Void in
                self.animateButtonContinue(img: img)
            }
            )
        })
    }
    
    var timer = Timer()
    public func typeOn(textView: UITextView ,string: String) {
        if textView.text == nil {
            textView.text = string
        } else {
            let characterArray = string.characterArray
            var characterIndex = 0
            timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { (timer) in
                if characterIndex != characterArray.count{
                    textView.text.append(characterArray[characterIndex])
                    characterIndex += 1
                    self.view.isUserInteractionEnabled = false
                    self.outletContinueButton.isHidden = true
                }
                else if characterIndex == characterArray.count {
                    timer.invalidate()
                    self.view.isUserInteractionEnabled = true
                    self.outletContinueButton.isHidden = false
                }
            }
        }
        // return characterIndex
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
