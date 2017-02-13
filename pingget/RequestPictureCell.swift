//
//  RequestPictureCell.swift
//  pingget
//
//  Created by Borys Khliebnikov on 1/6/17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import Foundation

protocol RequestPictureCellDelegate: class {
    func removePicture()
}

class RequestPictureCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    static let id = "RequestPictureCell"
    weak var delegate: RequestPictureCellDelegate?
    
    func setPicture(picture: UIImage) {
        self.pictureImageView.image = picture
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.removePicture()
    }
}
