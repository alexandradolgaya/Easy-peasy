//
//  Extensions.swift
//  MathWithYourFriends
//
//  Created by Igor Prysyazhnyuk on 9/20/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(redInt: Int, greenInt: Int, blueInt: Int, alpha: CGFloat = 1) {
        let maxColorValue: CGFloat = 255
        self.init(red: CGFloat(redInt) / maxColorValue , green: CGFloat(greenInt) / maxColorValue, blue: CGFloat(blueInt) / maxColorValue, alpha: alpha)
    }
    
    convenience init(hex: String) {
        var colorString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (colorString.hasPrefix("#")) {
            colorString.remove(at: colorString.startIndex)
        }
        
        if ((colorString.characters.count) != 6) {
            self.init()
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)
        
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }
    
    /// General orange color across the app
    class func pinggetOrange() -> UIColor {
        return UIColor(red:0.98, green:0.63, blue:0.18, alpha:1.00)
    }
    
    /// Color for not selected tab titles
    class func pinggetBlack() -> UIColor {
        return UIColor(red:59/255, green:59/255, blue:59/255, alpha:1.00)
    }
    
    /// Gray color for "completed" status view
    class func pinggetGray() -> UIColor {
        return UIColor(red:0.72, green:0.79, blue:0.83, alpha:1.00)
    }
}


extension String {
    func getMatches(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func matches(regex: String) -> Bool {
        return getMatches(regex: regex).count > 0
    }
    
    func validateEmail() -> Bool {
        return matches(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }
    
    var withoutWhitespaces: String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    var isEmptyWithoutWhitespaces: Bool {
        return withoutWhitespaces.isEmpty
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func toDictionary() -> [String:AnyObject]? {
        if let data = data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

let authTokenKey = "authToken"
let deviceTokenKey = "deviceToken"

extension UserDefaults {
    
    static var standardDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    static func writeAuthToken(token: String?) {
        guard let token = token else { return }
        standardDefaults.set(token, forKey: authTokenKey)
        standardDefaults.synchronize()
    }
    
    static func getAuthToken() -> String? {
        return standardDefaults.string(forKey: authTokenKey)
    }
    
    static func deleteAuthToken() {
        standardDefaults.removeObject(forKey: authTokenKey)
        standardDefaults.synchronize()
    }
    
    static func writeDeviceToken(deviceToken: String) {
        standardDefaults.set(deviceToken, forKey: deviceTokenKey)
    }
    
    static func getDeviceToken() -> String? {
        return standardDefaults.string(forKey: deviceTokenKey)
    }
    
    static func deleteDeviceToken() {
        standardDefaults.removeObject(forKey: deviceTokenKey)
    }
}

let activityIndicatorSize = CGFloat(50), loadingViewSize = CGFloat(90)
extension UIView {
    
    func showActivityIndicator() -> UIView {
        let uiView = self
        let loadingView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: loadingViewSize, height: loadingViewSize)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.97)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: activityIndicatorSize, height: activityIndicatorSize)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        activityIndicator.startAnimating()
        loadingView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.75)
        loadingView.addSubview(activityIndicator)
        
        uiView.addSubview(loadingView)
        
        // Make constraints
        let horizontalConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: uiView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        uiView.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: uiView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        uiView.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: loadingViewSize)
        uiView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: loadingViewSize)
        uiView.addConstraint(heightConstraint)
        
        return loadingView
    }
    
    static func hideActivityIndicator(activityIndicator: UIView?) {
        activityIndicator?.removeFromSuperview()
    }
    
    static func drawBottomLine(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let bottomLineHeight: CGFloat = 1
        let color = UIColor(redInt: 205, greenInt: 205, blueInt: 205)
        let drect = CGRect(x: 0, y: height - bottomLineHeight, width: width, height: bottomLineHeight)
        let path = UIBezierPath(rect: drect)
        
        color.set()
        path.fill()
    }
}

extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Date {
    
    @nonobjc static let defaultDateFormat = "MMM dd, h:mm a"
    
    func toString(dateFormat: String? = defaultDateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func dateComponents(date: Date, component: Calendar.Component) -> DateComponents {
        return Calendar.current.dateComponents([component], from: self, to: date)
    }
    
    func yearsFrom(date: Date) -> Int {
        return dateComponents(date: date, component: .year).year ?? 0
    }
    
    func monthsFrom(date: Date) -> Int {
        return dateComponents(date: date, component: .month).month ?? 0
    }
    
    func weeksFrom(date: Date) -> Int {
        return dateComponents(date: date, component: .weekOfYear).weekOfYear ?? 0
    }
    
    func daysFrom(date: Date) -> Int {
        return dateComponents(date: date, component: .day).day ?? 0
    }
    
    func hoursFrom(date: Date) -> Int {
        return dateComponents(date: date, component: .hour).hour ?? 0
    }
    
    func minutesFrom(date: Date) -> Int {
        return dateComponents(date: date, component: .minute).minute ?? 0
    }
    
    func secondsFrom(date: Date) -> Int {
        return dateComponents(date: date, component: .second).second ?? 0
    }
    
    func millisecondsFrom(date: Date) -> Int {
        return Int(self.timeIntervalSinceReferenceDate * 1000 - date.timeIntervalSinceReferenceDate * 1000)
    }
    
    var timeframe: String {
        var timeframe = "just now"
        let date = Date()
        let years = yearsFrom(date: date), months = monthsFrom(date: date), weeks = weeksFrom(date: date), days = daysFrom(date: date), hours = hoursFrom(date: date), minutes = minutesFrom(date: date)
        if years > 0 { timeframe = "\(years) \(years > 1 ? "years" : "year") ago" }
        else if months > 0 { timeframe = "\(months) \(months > 1 ? "months" : "month") ago" }
        else if weeks > 0 { timeframe = "\(weeks) \(weeks > 1 ? "weeks" : "week") ago" }
        else if days > 0 { timeframe = "\(days) \(days > 1 ? "days" : "day") ago" }
        else if hours > 0 { timeframe = "\(hours) \(hours > 1 ? "hours" : "hour") ago" }
        else if minutes > 0 {
            if minutes == 1 { timeframe = "a minute ago" }
            else if minutes == 2 { timeframe = "two minutes ago" }
            else if minutes == 3 { timeframe = "three minutes ago" }
            else { timeframe = "\(minutes) \(minutes > 1 ? "minutes" : "minute") ago" }
        }
        return timeframe
    }
}
