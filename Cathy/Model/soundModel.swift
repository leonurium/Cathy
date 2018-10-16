//
//  soundModel.swift
//  Cathy
//
//  Created by Terretino on 29/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import AVFoundation

public class backgroundSound {
    
    var musicPlayer = AVAudioPlayer()
    
    func playSound(namaMusic: String) {
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: namaMusic, ofType: "wav")!))
            musicPlayer.play()
        } catch {
            print("error")
        }
      musicPlayer.numberOfLoops = -1
    }
    
}
