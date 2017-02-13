//
//  DateRange.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/18/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class DateRange {
    var dateFrom: Date
    var dateTo: Date
    var timeFrom: Date
    var timeTo: Date
    
    let dateFormat = "dd MMM YYYY"
    let dateFormatDayOfWeek = "EEE, dd MMM"
    let timeFormat = "HH:mm"
    
    var dateFromFormatted: String {
        return dateFrom.toString(dateFormat: dateFormat)
    }
    var dateFromForRequestDetailsFormatted: String {
        return dateFrom.toString(dateFormat: dateFormatDayOfWeek)
    }
    var dateToForRequestDetailsFormatted: String {
        return dateTo.toString(dateFormat: dateFormatDayOfWeek)
    }
    var dateFromWithDayOfWeekFormatted: String {
        let date = dateFrom.toString(dateFormat: dateFormatDayOfWeek) + ", "
        let time = timeFrom.toString(dateFormat: timeFormat)
        return date + time
    }
    var dateToWithDayOfWeekFormatted: String {
        let date = dateTo.toString(dateFormat: dateFormatDayOfWeek) + ", "
        let time = timeTo.toString(dateFormat: timeFormat)
        return date + time
    }
    var dateToFormatted: String {
        return dateTo.toString(dateFormat: dateFormat)
    }
    var timeFromFormatted: String {
        return timeFrom.toString(dateFormat: timeFormat)
    }
    var timeToFormatted: String {
        return timeTo.toString(dateFormat: timeFormat)
    }
    
    init (dateFrom: Date, dateTo: Date, timeFrom: Date, timeTo: Date) {
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.timeFrom = timeFrom
        self.timeTo = timeTo
    }
    
    static var defaultRange: DateRange {
        let currentDate = Date()
        return DateRange(dateFrom: currentDate, dateTo: currentDate, timeFrom: currentDate, timeTo: currentDate)
    }
}
