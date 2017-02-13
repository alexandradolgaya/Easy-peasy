//
//  BusinessType.swift
//  pingget
//
//  Created by Victor on 21.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import Foundation

let businessTypes = [BusinessType(title: "Service",
                                           imageName:"icon_service",
                                           categories: serviceCategories),
                     BusinessType(title: "Product",
                                  imageName:"icon_product",
                                  categories: productCategories)]

class BusinessType : NSObject, NSCoding {
    var title: String
    var imageName: String
    var categories: [BusinessCategory]
    
    init(title: String, imageName: String, categories: [BusinessCategory]) {
//        super.init()
        self.title = title
        self.imageName = imageName
        self.categories = categories
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(categories, forKey: "categories")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.imageName = aDecoder.decodeObject(forKey: "imageName") as! String
        self.categories = aDecoder.decodeObject(forKey: "categories") as! [BusinessCategory]
    }
}

func == (lhs: BusinessType, rhs: BusinessType) -> Bool {
    return lhs.title == rhs.title
}
