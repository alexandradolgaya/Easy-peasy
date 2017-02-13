//
//  Storage.swift
//  pingget
//
//  Created by Victor on 29.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import Foundation

class Storage {
    
    public var request : Request?
    
    static let sharedStorage : Storage = {
        let instance = Storage()
        return instance
    }()
    
}
