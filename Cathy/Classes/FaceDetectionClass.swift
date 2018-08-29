//
//  FaceDetectionClass.swift
//  Cathy
//
//  Created by Rangga Leo on 15/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import AVFoundation
import Foundation
import ARKit
import CoreImage

class FaceDetectionClass: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession = AVCaptureSession()
    var preview: CALayer!
    var permissionGranted = false
    var result = false
    
    func beginSession() {
        checkPermission()
        do {
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {return}
            
            let captureDeviceIput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceIput)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.preview = previewLayer
            
            captureSession.startRunning()
            let dataOutput = AVCaptureVideoDataOutput()
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "faceDetect"))
            
            print("OK")
            
            
        } catch let e {
            print("Error", e)
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
        
        detect(image: images)
        
        if result {
            stopCaptureSession()
            print("OK")
        }
    }
    
    func prepareCamere() {
        captureSession.sessionPreset = .photo
     
        beginSession()
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
                result = face.hasSmile
            }
        }
    }
}
