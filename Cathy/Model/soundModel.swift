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
    
    struct audioPlayer {
        static var musicPlayer = AVAudioPlayer()
    }
    
    func playSound() {
        do {
            audioPlayer.musicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic1", ofType: "mp3")!))
            audioPlayer.musicPlayer.play()
        } catch {
            print("error")
        }
        audioPlayer.musicPlayer.numberOfLoops = -1
    }
    
}
