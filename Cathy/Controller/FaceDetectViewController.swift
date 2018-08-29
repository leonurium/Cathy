//
//  FaceDetectViewController.swift
//  Cathy
//
//  Created by Rangga Leo on 28/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import AVFoundation
import UIKit
import ARKit
import CoreImage

class FaceDetectViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var permissionGranted = false
    var preview: CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else {return}
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        preview = previewLayer
//        view.layer.addSublayer(previewLayer)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQ"))
        captureSession.addOutput(dataOutput)
        
        // Do any additional setup after loading the view.
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let context = CIContext()
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        let images = UIImage(cgImage: cgImage)
//        outletImageViewPreviewCamera.image = images
        
        print(detect(image: images))
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            permissionGranted = true
            break
        case .denied:
            permissionGranted = false
            break
        case .restricted:
            permissionGranted = false
            break
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
            (granted) in
            self.permissionGranted = granted
        })
    }
    
    
    func detect(image: UIImage) {
        let images = CIImage(image: image)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        
        if let faces = faceDetector?.features(in: images!, options: [CIDetectorSmile: true]) {
            
            for face in faces as! [CIFaceFeature] {
                
                print(face.hasSmile)
                print(face.hasSmile.hashValue)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
