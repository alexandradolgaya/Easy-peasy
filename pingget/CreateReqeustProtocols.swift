//
//  RequestDoneButtonDelegate.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/21/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import Foundation

protocol RequestDoneButtonDelegate: class {
    func doneTapped(request: Request)
}

protocol RequestHolder {
    func setRequestData(request: Request?, doneButtonDelegate: RequestDoneButtonDelegate?)
}
