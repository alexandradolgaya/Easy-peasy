//
//  OptionsPopupCell.swift
//  pingget
//
//  Created by Borys Khliebnikov on 1/13/17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import Foundation

class OptionsPopupCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    static let id = "OptionsPopupCell"
    let chatTitles      = ["Delete Chat", "Report Abuse"]
    let detailTitles    = ["Edit Request", "Mark Booked", "Mark Completed", "Delete Request"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCellForIndexPath(indexPath: IndexPath, type: OptionsPopupType.RawValue) {
        switch type {
        case OptionsPopupType.chat.rawValue:
            self.titleLabel?.text = chatTitles[indexPath.row]
            break
        case OptionsPopupType.myRequestDetails.rawValue:
            self.titleLabel?.text = detailTitles[indexPath.row]
            break
        default:
            break
        }
    }
    
}
