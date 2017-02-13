//
//  MyRequestDetailsVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/22/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class MyRequestDetailsVC: NavBarVC {
    
    @IBOutlet weak var requestStatusColorView: UIView!
    @IBOutlet weak var requestServiceIconImageView: UIImageView!
    @IBOutlet weak var requestServicesTitleLabel: UILabel!
    @IBOutlet weak var requestDateLabel: UILabel!
    @IBOutlet weak var requestLocationLabel: UILabel!
    @IBOutlet weak var requestStatusLabel: UILabel!
    @IBOutlet weak var requestStatusRoundedView: RoundedView!
    @IBOutlet weak var targetUserImageView: UIImageView!
    @IBOutlet weak var shadowViewHeightConstraint: NSLayoutConstraint!
    /*Recording + picture*/
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordingTimeLabel: UILabel!
    @IBOutlet weak var recordingProgressView: UIProgressView!
    var timer: Timer!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var bottomPictureConstraint: NSLayoutConstraint!
    
    static let id = "MyRequestDetailsVC"
    
    var request: Request?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissVC), name: notificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    func setData(request: Request?) {
        self.request = request
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateUI() {
        if (request?.requestRecording) != nil {
            recordingView.isHidden = false
            let soundFilePath = Bundle.main.path(forResource: "Voice0013", ofType: "aac")
            let fileURL = URL.init(fileURLWithPath: soundFilePath!)
            do {
                try SharedPlayer.sharedInstance.audioPlayer = AVAudioPlayer.init(contentsOf: fileURL)
            } catch {
                print("ERR MSG: Error in audioPlayer")
            }
            //        AVAudioSession.sharedInstance().setC
            //        AVAudioSession.sharedInstance().setActive(true, error: nil)
            self.recordingProgressView.progress = 0.0
            SharedPlayer.sharedInstance.audioPlayer?.numberOfLoops = 0
            SharedPlayer.sharedInstance.audioPlayer?.delegate = self
            SharedPlayer.sharedInstance.audioPlayer?.prepareToPlay()
        }
        if request?.requestPicture != nil {
            pictureImageView.image = request?.requestPicture
            pictureImageView.isHidden = false
        }
        if request?.requestPicture != nil && request?.requestRecording != nil {
            shadowViewHeightConstraint.constant = 300
        } else if request?.requestPicture != nil {
            bottomPictureConstraint.constant = 10
            shadowViewHeightConstraint.constant = 272
            recordingView.isHidden = true
        } else  if request?.requestRecording != nil {
            shadowViewHeightConstraint.constant = 220
            pictureImageView.isHidden = true
        } else {
            pictureImageView.removeFromSuperview()
            recordingView.removeFromSuperview()
            shadowViewHeightConstraint.constant = 192
            self.view.layoutIfNeeded()
        }
        requestServicesTitleLabel.text = request?.servicesFormatted
        requestDateLabel.text = request?.date?.startDateAndTimeFormatted
        requestLocationLabel.text = request?.location?.descriptionForUser
        if (request?.forWho.count)! > 0 {
            targetUserImageView.image = UIImage.init(named: (request?.forWho.first?.imageName)! + "_white")
        }
        requestServiceIconImageView.image = UIImage.init(named: (request?.services.first?.imageName)! + "_white")
    }
    
    func updateTimer() {
        let currentTime = Int((SharedPlayer.sharedInstance.audioPlayer?.currentTime)!)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        self.recordingTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        self.recordingProgressView.progress = Float((SharedPlayer.sharedInstance.audioPlayer?.currentTime)!)/Float((SharedPlayer.sharedInstance.audioPlayer?.duration)!)
    }
    
    @IBAction func showOptionsPressed(_ sender: Any) {
        OptionsPopup.show(fromVC: self, request: request, type: OptionsPopupType.myRequestDetails, delegate: self)
    }
    
    @IBAction func viewDetailsTapped(_ sender: AnyObject) {
        DetailedRequestInfoPopup.show(fromVC: self, request: request, delegate: self)
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

extension MyRequestDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rq = request {
            return rq.simulationResponser.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RequestResponseCell.id, for: indexPath) as! RequestResponseCell
        if let rq = request {
            switch indexPath.row {
            case 0:
                cell.configureWithUser(user: (self.request?.simulationResponser[indexPath.row])!,
                                       comment: "Are you located in a congestion zone within the city")
                return cell
            case 1:
                cell.configureWithUser(user: (self.request?.simulationResponser[indexPath.row])!,
                                       comment: "Hi Amanda! I'm experienced Hair & Skin beautician with around 7 years of experience.")
                return cell
            case 2:
                cell.configureWithUser(user: (self.request?.simulationResponser[indexPath.row])!,
                                       comment: "I need a manicured nails and lazer hair removal on fingers.")
                return cell
            default:
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatView = ChatViewController()
        chatView.messages = makeNormalConversation()
        let chatNavigationController = UINavigationController(rootViewController: chatView)
        if let nc = self.navigationController {
            self.navigationController?.pushViewController(chatView, animated: false)
        } else {
            chatNavigationController.isNavigationBarHidden = true
            self.present(chatNavigationController, animated: false, completion: nil)
        }
        
    }
}

extension MyRequestDetailsVC: DetailedRequestInfoPopupDelegate {
    func markCompletedTapped(popup: BasePopupVC, type: SupplierPopupType) {
        popup.close {
            if (self.request?.simulationResponser.count)! > 0 {
                SuppliersListPopup.show(fromVC: self, request: self.request, type: SupplierPopupType(rawValue: type.rawValue)!, delegate: self)
            } else {
                self.requestStatusLabel.text = "Completed"
                self.requestStatusRoundedView.backgroundColor = UIColor.pinggetGray()
                self.request?.status = RequestStatus.Completed
            }
        }
    }
}

extension MyRequestDetailsVC: SuppliersListPopupDelegate {
    func supplierSelected(supplier: User, type: SupplierPopupType) {
        switch type {
        case .Booked:
            requestStatusLabel.text = "Booked"
            requestStatusRoundedView.backgroundColor = UIColor.pinggetOrange()
            request?.status = RequestStatus.Booked
        case .Completed:
            requestStatusLabel.text = "Completed"
            requestStatusRoundedView.backgroundColor = UIColor.pinggetGray()
            request?.status = RequestStatus.Completed
            RateSupplierPopup.show(fromVC: self, delegate: self)
        }
    }
}

extension MyRequestDetailsVC: RateSupplierPopupDelegate {
    func rateSupplierTapped(rating: Int, comment: String?) {
        
    }
}

extension MyRequestDetailsVC: OptionsPopupDelegate {
    func optionSelected(option: Int, cell: Int) {
        
    }
}

extension MyRequestDetailsVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        timer.invalidate()
        self.recordingTimeLabel.text = "00:00"
        self.recordingProgressView.progress = 0.0
        playButton.setImage(UIImage.init(named: "icn_play_black"), for: UIControlState.normal)
    }
}
