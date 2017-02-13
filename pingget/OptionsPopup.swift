//
//  OptionsPopup.swift
//  pingget
//
//  Created by Borys Khliebnikov on 1/13/17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import Foundation
import UIKit

protocol OptionsPopupDelegate: class {
    func optionSelected(option: OptionsPopupType.RawValue, cell: Int)
}

enum OptionsPopupType: Int {
    case chat
    case myRequestDetails
}

enum SelectedPopup {
    enum Chat: Int {
        case deleteChat = 0
        case reportAbuse
        static var count: Int { return SelectedPopup.Chat.reportAbuse.rawValue + 1}
    }
    enum MyRequestDetails: Int {
        case editRequest = 0
        case markBooked
        case markCompleted
        case deleteRequest
        static var count: Int { return SelectedPopup.MyRequestDetails.deleteRequest.rawValue + 1}
    }
}



class OptionsPopup: BasePopupVC {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popupHeight: NSLayoutConstraint!
    
    static let id = "OptionsPopup"
    var request: Request?
    weak var delegate: OptionsPopupDelegate?
    var type: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case OptionsPopupType.chat.rawValue:
            popupHeight.constant = CGFloat(44 * SelectedPopup.Chat.count + 10)
        case OptionsPopupType.myRequestDetails.rawValue:
            popupHeight.constant = CGFloat(44 * SelectedPopup.MyRequestDetails.count + 10)
        default:
            break
        }
    }
    
    static func show(fromVC: UIViewController, request: Request?, type: OptionsPopupType, delegate: OptionsPopupDelegate?) {
        let popup = create(popupId: id) as! OptionsPopup
        popup.setData(request: request, delegate: delegate)
        popup.type = type.rawValue
        //popup.tableView.reloadData()
        popup.show(fromVC: fromVC)
    }
    
    func setData(request: Request?, delegate: OptionsPopupDelegate?) {
        self.request = request
        self.delegate = delegate
    }
}

extension OptionsPopup: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case OptionsPopupType.chat.rawValue:
            return SelectedPopup.Chat.count
        case OptionsPopupType.myRequestDetails.rawValue:
            return SelectedPopup.MyRequestDetails.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsPopupCell.id, for: indexPath) as! OptionsPopupCell
        cell.configureCellForIndexPath(indexPath: indexPath, type: type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        close {
            self.delegate?.optionSelected(option: self.type, cell: indexPath.row)
        }
    }
}
