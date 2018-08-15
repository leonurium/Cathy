//
//  FaceDetectionClass.swift
//  Cathy
//
//  Created by Rangga Leo on 15/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import ARKit
import CoreImage

class FaceDetectionClass {
    
    func detect(image: UIImage) {
        let images = CIImage(image: image)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        
        if let faces = faceDetector?.features(in: images!, options: [CIDetectorSmile: true]) {
            
            for face in faces as! [CIFaceFeature] {
                
                print(face.hasSmile)
            }
        }
    }
    
}
