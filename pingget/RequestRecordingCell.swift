//
//  RequestRecordingCell.swift
//  pingget
//
//  Created by Borys Khliebnikov on 1/6/17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import Foundation

protocol RequestRecordingCellDelegate: class {
    func removeRecording()
}

class RequestRecordingCell: UITableViewCell {
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    static let id = "RequestRecordingCell"
    weak var delegate: RequestRecordingCellDelegate?
    var timer: Timer!
    
    override func awakeFromNib() {
        self.roundedView.layer.cornerRadius = self.roundedView.frame.height / 2.0
        self.roundedView.layer.borderColor = UIColor.pinggetBlack().cgColor
        self.roundedView.layer.borderWidth = 1.0
        self.timerLabel.text = "00:00"
        let soundFilePath = Bundle.main.path(forResource: "Voice0013", ofType: "aac")
        let fileURL = URL.init(fileURLWithPath: soundFilePath!)
        do {
            try SharedPlayer.sharedInstance.audioPlayer = AVAudioPlayer.init(contentsOf: fileURL)
        } catch {
            print("ERR MSG: Error in audioPlayer")
        }
//        AVAudioSession.sharedInstance().setC
//        AVAudioSession.sharedInstance().setActive(true, error: nil)
        self.progressView.progress = 0.0
        SharedPlayer.sharedInstance.audioPlayer?.numberOfLoops = 0
        SharedPlayer.sharedInstance.audioPlayer?.delegate = self
        SharedPlayer.sharedInstance.audioPlayer?.prepareToPlay()
    }
    
    func updateTimer() {
        let currentTime = Int((SharedPlayer.sharedInstance.audioPlayer?.currentTime)!)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        self.timerLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        self.progressView.progress = Float((SharedPlayer.sharedInstance.audioPlayer?.currentTime)!)/Float((SharedPlayer.sharedInstance.audioPlayer?.duration)!)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        delegate?.removeRecording()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        if playButton.currentImage == UIImage.init(named: "icn_play_black") {
            playButton.setImage(UIImage.init(named: "icn_pause_black"), for: UIControlState.normal)
        } else {
            playButton.setImage(UIImage.init(named: "icn_play_black"), for: UIControlState.normal)
        }
        if (SharedPlayer.sharedInstance.audioPlayer?.isPlaying)! {
            SharedPlayer.sharedInstance.audioPlayer?.pause()
            timer.invalidate()
        } else {
            SharedPlayer.sharedInstance.audioPlayer?.play()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
}

extension RequestRecordingCell: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        timer.invalidate()
        self.timerLabel.text = "00:00"
        self.progressView.progress = 0.0
        playButton.setImage(UIImage.init(named: "icn_play_black"), for: UIControlState.normal)
    }
}
