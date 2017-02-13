//
//  BusinessCategory.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import Foundation

let serviceCategories = [BusinessCategory(title: "Beauty",
                                          imageName:"icon_beauty",
                                          services: [Service(title: "Manicure", imageName: "icon_manicure"),
                                                     Service(title: "Pedicure", imageName: "icon_pedicure"),
                                                     Service(title: "Haircut and styling", imageName: "icon_haircut"),
                                                     Service(title: "Hair coloring", imageName: "icon_coloring"),
                                                     Service(title: "Waxing", imageName: "icon_waxing"),
                                                     Service(title: "MakeUp", imageName: "icon_makeup"),
                                                     Service(title: "Massage", imageName: "icon_massage"),
                                                     Service(title: "Skin care", imageName: "icon_skincare"),
                                                     Service(title: "Eyebrows", imageName: "icon_eyebrows"),
                                                     Service(title: "Solarium", imageName: "icon_solarium")]),
                         BusinessCategory(title: "Home",
                                          imageName:"icn_category_home_services",
                                          services: [Service]())]


let productCategories = [BusinessCategory(title: "Beauty",
                                          imageName:"icn_beauty_products",
                                          services: [Service(title: "MakeUp", imageName: "icon_makeup"),
                                                     Service(title: "Face Care", imageName: "icon_skincare"),
                                                     Service(title: "Body Care", imageName: "icn_body_care"),
                                                     Service(title: "Hair Care", imageName: "icon_haircut"),
                                                     Service(title: "Anti-aging", imageName: "icn_anti_aging")]),
                         BusinessCategory(title: "Home",
                                          imageName:"icon_home",
                                          services: [Service]())]

class BusinessCategory: NSObject, NSCoding {
    var title: String
    var imageName: String
    var services: [Service]
    
    init(title: String, imageName: String, services: [Service]) {
//        super.init()
        self.title = title
        self.imageName = imageName
        self.services = services
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(services, forKey: "services")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.imageName = aDecoder.decodeObject(forKey: "imageName") as! String
        self.services = aDecoder.decodeObject(forKey: "services") as! [Service]
    }
}

func == (lhs: BusinessCategory, rhs: BusinessCategory) -> Bool {
    return lhs.title == rhs.title
}
