//
//  shakeGestureModel.swift
//  Cathy
//
//  Created by Terretino on 28/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class shakeGesture {
    
    func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) -> Bool {
        var shake: Bool
        if event?.subtype == UIEventSubtype.motionShake {
            shake = true
            return shake
        } else {
            shake = false
            return shake
        }
    }
}
