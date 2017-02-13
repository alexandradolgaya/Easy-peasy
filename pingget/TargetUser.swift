//
//  TargetUser.swift
//  pingget
//
//  Created by Victor on 22.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import Foundation

let targetUsers = [TargetUser(title: "Male",
                              imageName:"icon_male"),
                   TargetUser(title: "Female",
                              imageName:"icon_female")]

class TargetUser: NSObject, NSCoding {
    var title: String
    var imageName: String
    
    init(title: String, imageName: String) {
        //        super.init()
        self.title = title
        self.imageName = imageName
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(imageName, forKey: "imageName")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.imageName = aDecoder.decodeObject(forKey: "imageName") as! String
    }
}

func == (lhs: TargetUser, rhs: TargetUser) -> Bool {
    return lhs.title == rhs.title
}
