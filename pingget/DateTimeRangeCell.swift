//
//  dateTimeRange.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/17/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

protocol DateTimeRangeDelegate: class {
    func dateFromTapped(index: Int)
    func dateToTapped(index: Int)
    func timeFromTapped(index: Int)
    func timeToTapped(index: Int)
    func dateTapped(index: Int)
    func timeTapped(index: Int)
}

class DateTimeRangeCell: UITableViewCell {
    @IBOutlet weak var dateFromButton: UIButton!
    @IBOutlet weak var dateToButton: UIButton!
    @IBOutlet weak var timeFromButton: UIButton!
    @IBOutlet weak var timeToButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    static let id = "DateTimeRangeCell"
    private var index = 0
    private weak var delegate: DateTimeRangeDelegate?
    
    func setData(dateRange: DateRange, index: Int, delegate: DateTimeRangeDelegate?) {
        self.index = index
        self.delegate = delegate
        dateFromButton.setTitle(dateRange.dateFromFormatted, for: .normal)
        dateToButton.setTitle(dateRange.dateToFormatted, for: .normal)
        timeFromButton.setTitle(dateRange.timeFromFormatted, for: .normal)
        timeToButton.setTitle(dateRange.timeToFormatted, for: .normal)
    }
    
    func setProductData(dateRange: DateRange, index: Int, delegate: DateTimeRangeDelegate?) {
        self.index = index
        self.delegate = delegate
        dateButton.setTitle(dateRange.dateToFormatted, for: .normal)
        timeButton.setTitle(dateRange.timeToFormatted, for: .normal)
    }
    
    @IBAction func dateFromTapped(_ sender: AnyObject) {
        delegate?.dateFromTapped(index: index)
    }
    
    @IBAction func dateToTapped(_ sender: AnyObject) {
        delegate?.dateToTapped(index: index)
    }
    
    @IBAction func timeFromTapped(_ sender: AnyObject) {
        delegate?.timeFromTapped(index: index)
    }
    
    @IBAction func timeToTapped(_ sender: AnyObject) {
        delegate?.timeToTapped(index: index)
    }
    
    @IBAction func timeTapped(_ sender: AnyObject) {
        delegate?.timeTapped(index: index)
    }
    
    @IBAction func dateTapped(_ sender: AnyObject) {
        delegate?.dateTapped(index: index)
    }
}
