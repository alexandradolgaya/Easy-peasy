//
//  RequestDetailsVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/18/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import MessageUI

class CreateRequestDetailsVC: NavBarVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: TableViewShadow!
    @IBOutlet weak var backView: ViewShadow!
    
    static let id = "CreateRequestDetailsVC"
    static let productId = "CreateProductRequestDetailsVC"
    let imagePicker = UIImagePickerController()
    
    var headers: [RequestDetailsHeader] = [.services, .location, .time, .addComment]
    var productHeaders: [RequestProductDetailsHeader] = [.products, .details, .location, .time, .addComment]
    var request: Request?
    var isService: Bool?
    var shouldShowPicture = false
    var shouldShowRecording = false
    
    func setData(request: Request?) {
        self.request = request
        isService = self.request?.type.title == "Service" ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4.0
        registerCell()
        setViewsForKeyboard()
        imagePicker.delegate      = self
        imagePicker.allowsEditing = true
    }
    
    private func setViewsForKeyboard() {
        scrollViewForKeyboard = tableView
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: HeaderFilledIndicatorCell.id, bundle: nil), forCellReuseIdentifier: HeaderFilledIndicatorCell.id)
        tableView.register(UINib(nibName: ImageTitleCell.id, bundle: nil), forCellReuseIdentifier: ImageTitleCell.id)
        tableView.register(UINib(nibName: RequestPictureCell.id, bundle: nil), forCellReuseIdentifier: RequestPictureCell.id)
        tableView.register(UINib(nibName: RequestRecordingCell.id, bundle: nil), forCellReuseIdentifier: RequestRecordingCell.id)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] {
            self.request?.requestPicture = chosenImage as! UIImage
        }
        picker.dismiss(animated: true) { 
            self.shouldShowPicture = true
            self.tableView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { 
            
        }
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    /*Camera*/
    
    func requestCamera() {
        let cameraController = UIAlertController.init(title: "Camera access denied",
                                                      message: "Please change privacy settings",
                                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let sendAction = UIAlertAction.init(title: "Change Settings", style: UIAlertActionStyle.default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        cameraController.addAction(sendAction)
        cameraController.addAction(cancelAction)
        self.present(cameraController, animated: true, completion: nil)
    }
    
    func presentImagePicker() {
        
        let alertController = UIAlertController.init(title: "Please choose an option",
                                                     message: nil,
                                                     preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let chooseLibrary = UIAlertAction.init(title: "Photo Libriary",
                                               style: UIAlertActionStyle.default) { (action) in
                                                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                                                self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let chooseCamera = UIAlertAction.init(title: "Use Camera", style: UIAlertActionStyle.default) { (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            
            switch authStatus {
            case .authorized:
                self.present(self.imagePicker, animated: true, completion: nil)
            case .notDetermined:
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                    if granted {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                })
            case .denied, .restricted:
                self.requestCamera()
            }
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            alertController.addAction(chooseCamera)
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            alertController.addAction(chooseLibrary)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        presentImagePicker()
    }
    
    @IBAction func recordingButtonPressed(_ sender: Any) {
        shouldShowRecording = true
        tableView.reloadData()
        let soundFilePath = Bundle.main.path(forResource: "Voice0013", ofType: "aac")
        
        let fileURL = URL.init(fileURLWithPath: soundFilePath!)
        request?.requestRecording = fileURL
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        //        let requestData = NSKeyedArchiver.archivedData(withRootObject: request)
//        if UserDefaults.standard.bool(forKey: "Authorized") == true {
            //            UserDefaults.standard.set(request, forKey: "created_request")
            
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
//            } else {
//                // FIXME: Change before
//                Storage.sharedStorage.request = request
//                if UserDefaults.standard.object(forKey: "user_type") as? String == "user" {
//                    performSegue(withIdentifier: "ShowUserSegue", sender: nil)
//                }
//                else {
//                    performSegue(withIdentifier: "ShowSupplierSegue", sender: nil)
//                }
//                //self.showSendMailErrorAlert()
//            }
        }
        else {
            //            UserDefaults.standard.set(request, forKey: "created_request")
            Storage.sharedStorage.request = request
            performSegue(withIdentifier: "ShowLoginSegue", sender: nil)
        }
    }
}

enum RequestDetailsHeader: Int {
    case services
    case location
    case time
    case addComment
    
    var title: String {
        switch self {
        case .services: return "SERVICES"
        case .location: return "LOCATION"
        case .time: return "TIME"
        case .addComment: return "ADD COMMENT"
        }
    }
}

enum RequestDetailsCommentsSectionCell: Int {
    case comment = 0
    case recording
    case picture
}

enum RequestProductDetailsHeader: Int {
    case products
    case details
    case location
    case time
    case addComment
    
    var title: String {
        switch self {
        case .products: return "PRODUCTS"
        case .details: return "DETAILS"
        case .location: return "LOCATION"
        case .time: return "TIME"
        case .addComment: return "ADD COMMENT"
        }
    }
}

extension CreateRequestDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = isService == true ? headers.count : productHeaders.count
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount = 0
        if isService == true {
            guard let requestDetailsHeader = RequestDetailsHeader(rawValue: section) else { return rowsCount }
            switch requestDetailsHeader {
            case .services: rowsCount = request?.services.count ?? 0
            case .location: rowsCount = 1
            case .time: rowsCount = request?.date?.count ?? 0
            case .addComment:
                if shouldShowPicture == true && shouldShowRecording == true {
                    rowsCount = 3
                } else if shouldShowPicture == true || shouldShowRecording == true {
                    rowsCount = 2
                } else {
                    rowsCount = 1
                }
            }
        }
        else {
            guard let requestProductDetailsHeader = RequestProductDetailsHeader(rawValue: section) else { return rowsCount }
            switch requestProductDetailsHeader {
            case .products: rowsCount = request?.services.count ?? 0
            case .details: rowsCount = 1
            case .location: rowsCount = 1
            case .time: rowsCount = request?.date?.count ?? 0
            case .addComment:
                if shouldShowPicture == true && shouldShowRecording == true {
                    rowsCount = 3
                } else if shouldShowPicture == true || shouldShowRecording == true {
                    rowsCount = 2
                } else {
                    rowsCount = 1
                }
            }
        }
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: HeaderFilledIndicatorCell.id) as! HeaderFilledIndicatorCell
        if isService == true {
            guard let requestDetailsHeader = RequestDetailsHeader(rawValue: section) else { return UITableViewCell() }
            switch requestDetailsHeader {
            case .services:
                headerView.setData(title: headers[section].title, filled: (request?.services.count)! > 0 ? true : false)
            case .location:
                headerView.setData(title: headers[section].title, filled: request?.location != nil ? true : false)
            case .time:
                headerView.setData(title: headers[section].title, filled: request?.date != nil ? true : false)
            case .addComment:
                headerView.setData(title: headers[section].title, filled: nil)
            }
        }
        else {
            guard let requestProductDetailsHeader = RequestProductDetailsHeader(rawValue: section) else { return UITableViewCell() }
            switch requestProductDetailsHeader {
            case .products:
                headerView.setData(title: productHeaders[section].title, filled: (request?.services.count)! > 0 ? true : false)
            case .details:
                headerView.setData(title: productHeaders[section].title, filled: request?.productItem != nil ? true : false)
            case .location:
                headerView.setData(title: productHeaders[section].title, filled: request?.location != nil ? true : false)
            case .time:
                headerView.setData(title: productHeaders[section].title, filled: request?.date != nil ? true : false)
            case .addComment:
                headerView.setData(title: productHeaders[section].title, filled: nil)
            }
        }
        return headerView.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isService == true {
            switch indexPath.section {
            case 3:
                switch indexPath.row {
                case RequestDetailsCommentsSectionCell.recording.rawValue:
                    if shouldShowRecording == false {
                        return 150
                    } else {
                        return 50
                    }
                case RequestDetailsCommentsSectionCell.picture.rawValue:
                    return 150
                default:
                    return 50
                }
            default:
                return 75
            }
        } else {
            switch indexPath.section {
            case 3:
                return 50
            case 4:
                switch indexPath.row {
                case RequestDetailsCommentsSectionCell.recording.rawValue:
                    if shouldShowRecording == false {
                        return 150
                    } else {
                        return 50
                    }
                case RequestDetailsCommentsSectionCell.picture.rawValue:
                    return 150
                default:
                    return 75
                }
            default:
                return 75
            }

        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerViewHeight: CGFloat = 40
        return headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isService == true {
            guard let requestDetailsHeader = RequestDetailsHeader(rawValue: indexPath.section) else { return UITableViewCell() }
            switch requestDetailsHeader {
            case .services:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
                guard let service = request?.services[indexPath.row] else { break }
                cell.setServiceInfo(service: service, targetUser: request?.forWho.first)
                return cell
            case .location:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
                guard let requestLocation = request?.location else { break }
                
                cell.setLocationInfo(location: requestLocation)
                //            cell.setData(imageName: requestLocation.iconName, title: requestLocation.description)
                return cell
            case .time:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
                guard let requestDate = request?.date else { break }
                cell.setData(imageName: requestDate.iconName, title: requestDate.getDescription(index: indexPath.row, short: request?.type.title == "Product") )
                return cell
            case .addComment:
                switch indexPath.row {
                case RequestDetailsCommentsSectionCell.comment.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCommentCell", for: indexPath)
                    
                    return cell
                case RequestDetailsCommentsSectionCell.recording.rawValue:
                    if shouldShowRecording == true {
                        let cell = tableView.dequeueReusableCell(withIdentifier: RequestRecordingCell.id, for: indexPath) as! RequestRecordingCell
                        cell.delegate = self
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: RequestPictureCell.id, for: indexPath) as! RequestPictureCell
                        cell.setPicture(picture: (self.request?.requestPicture)!)
                        cell.delegate = self
                        return cell
                    }
                case RequestDetailsCommentsSectionCell.picture.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RequestPictureCell.id, for: indexPath) as! RequestPictureCell
                    cell.setPicture(picture: (self.request?.requestPicture)!)
                    cell.delegate = self
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCommentCell", for: indexPath)
                    return cell
                }
                
            }
        }
        else {
            guard let requestProductDetailsHeader = RequestProductDetailsHeader(rawValue: indexPath.section) else { return UITableViewCell() }
            switch requestProductDetailsHeader {
            case .products:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
                guard let service = request?.services[indexPath.row] else { break }
                cell.setProductsInfo(service: service, category: (request!.category)!)
                return cell
            case .details:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
                cell.setDetailsInfo(request: request!)
                return cell
            case .location:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
                guard let requestLocation = request?.location else { break }
                cell.setLocationInfo(location: requestLocation)
                //            cell.setData(imageName: requestLocation.iconName, title: requestLocation.description)
                return cell
            case .time:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
                guard let requestDate = request?.date else { break }
                cell.setData(imageName: requestDate.iconName, title: requestDate.getDescription(index: indexPath.row, short: request?.type.title == "Product") )
                return cell
            case .addComment:
                switch indexPath.row {
                case RequestDetailsCommentsSectionCell.comment.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCommentCell", for: indexPath)
                    
                    return cell
                case RequestDetailsCommentsSectionCell.recording.rawValue:
                    if shouldShowRecording == true {
                        let cell = tableView.dequeueReusableCell(withIdentifier: RequestRecordingCell.id, for: indexPath) as! RequestRecordingCell
                        cell.delegate = self
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: RequestPictureCell.id, for: indexPath) as! RequestPictureCell
                        cell.delegate = self
                        cell.setPicture(picture: (self.request?.requestPicture)!)
                        return cell
                    }
                case RequestDetailsCommentsSectionCell.picture.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RequestPictureCell.id, for: indexPath) as! RequestPictureCell
                    cell.setPicture(picture: (self.request?.requestPicture)!)
                    cell.delegate = self
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCommentCell", for: indexPath)
                    return cell
                }            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var segueId: String?
        if isService == true{
            guard let requestDetailsHeader = RequestDetailsHeader(rawValue: indexPath.section) else { return }
            switch requestDetailsHeader {
            case .services: segueId = SelectServiceVC.id
            case .location: segueId = RequestLocationVC.id
            case .time: segueId = RequestDateVC.id
            default: break
            }
        } else {
            guard let requestProductDetailsHeader = RequestProductDetailsHeader(rawValue: indexPath.section) else { return }
            switch requestProductDetailsHeader {
            case .products: segueId = SelectServiceVC.id
            case .details: segueId = RequestProductDetailsVC.id
            case .location: segueId = RequestFromWhereVC.id
            case .time: segueId = RequestProductDateVC.id
            default: break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        if let segueId = segueId { performSegue(withIdentifier: segueId, sender: nil) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let requestHolder = segue.destination as? RequestHolder, let request = request else { return }
        requestHolder.setRequestData(request: request, doneButtonDelegate: self)
    }
}

extension CreateRequestDetailsVC: RequestDoneButtonDelegate {
    func doneTapped(request: Request) {
        let _ = navigationController?.popViewController(animated: true)
        self.request = request
        tableView.reloadData()
    }
}

extension CreateRequestDetailsVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView is TextViewBottomLine else {
            return
        }
        request?.comment = textView.text
        (textView as! TextViewBottomLine).showPlaceholderIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView is TextViewBottomLine else {
            return
        }
        (textView as! TextViewBottomLine).placeholderLabel.isHidden = true
    }
    
}

extension CreateRequestDetailsVC: RequestPictureCellDelegate {
    
    func removePicture() {
        shouldShowPicture = false
        request?.requestPicture = nil
        tableView.reloadData()
    }
}

extension CreateRequestDetailsVC: RequestRecordingCellDelegate {
    
    func removeRecording() {
        shouldShowRecording = false
        request?.requestRecording = nil
        SharedPlayer.sharedInstance.audioPlayer?.stop()
        tableView.reloadData()
    }
}

extension CreateRequestDetailsVC: MFMailComposeViewControllerDelegate {
    
    /*Email*/
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        if let email = UserDefaults.standard.string(forKey: "user_email") {
            mailComposerVC.setToRecipients(["\(email)","alexandra.dolgaya@gmail.com"])
        } else {
            mailComposerVC.setToRecipients(["alexandra.dolgaya@gmail.com"])
        }
        mailComposerVC.setSubject("Information from Request > PingGet")
        mailComposerVC.setMessageBody(createMessageBody(), isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlertController = UIAlertController.init(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        sendMailErrorAlertController.addAction(action)
        present(sendMailErrorAlertController, animated: true, completion: nil)
    }
    
    func createMessageBody() -> String {
        if let rq = request {
            let type        = "Request Type: \(rq.type.title)\n"
            let category    = "Request Category: \(rq.category.title)\n"
            var services    = "Request Services: "
            rq.services.forEach({ (service) in
                services = services+"\(service.title)\n "
            })
            var forWho: String!
            var location: String!
            if let lc = rq.location {
                location    = "Request Location: \(lc.address)\n"
            } else {
                location    = "Request Location: \n"
            }
            var date: String!
            if request?.type.title == "Product" {
                date = "Request Date: \(rq.date!.getDescription(index: 0,short: true))\n"
            } else {
                date = "\(rq.date!.startDateFormatted) - \(rq.date!.endDateFormatted), \(rq.date!.timeRange)\n"
            }
            var comment: String!
            if let cm = rq.comment {
                comment = "Request Comment: \(cm)\n"
            } else {
                comment = "Request Comment: \n"
            }
            let status      = "Request Status: \(rq.status)\n"
            var finalMessage = type+category+services+location+comment+status+date
            if isService == false {
                let productItem     = "\(rq.productItem)\n"
                let productBrand    = "\(rq.productBrand)\n"
                let productPrice    = "\(rq.minPrice) - \(rq.maxPrice)\n"
                finalMessage = finalMessage+productBrand+productItem+productPrice
            } else {
                if (rq.forWho.count) > 1 {
                    forWho      = "Request Target: \(rq.forWho[0].title), \(rq.forWho[1].title)\n"
                } else {
                    forWho      = "Request Target: \(rq.forWho[0].title)\n"
                }
                finalMessage = finalMessage+forWho
            }
            return finalMessage
        } else {
            return "No request"
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
//        guard result == .sent else {
//            controller.dismiss(animated: true, completion: nil)
//            return
//        }
        Storage.sharedStorage.request = request
        controller.dismiss(animated: true, completion: nil)
        if UserDefaults.standard.object(forKey: "user_type") as? String == "user" {
            performSegue(withIdentifier: "ShowUserSegue", sender: nil)
        }
        else {
            performSegue(withIdentifier: "ShowSupplierSegue", sender: nil)
        }
    }
    
}
