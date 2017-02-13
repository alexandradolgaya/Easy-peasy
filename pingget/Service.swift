//
//  Service.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import Foundation

class Service: NSObject, NSCoding {
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

func == (lhs: Service, rhs: Service) -> Bool {
    return lhs.title == rhs.title
}
