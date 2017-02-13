//
//  SharedPlayer.swift
//  pingget
//
//  Created by Borys Khliebnikov on 1/6/17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import Foundation

class SharedPlayer {
    
    static let sharedInstance : SharedPlayer = {
        let instance = SharedPlayer()
        return instance
    }()
    
    var audioPlayer: AVAudioPlayer?
    
}
