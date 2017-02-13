//
//  Request.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/18/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import Foundation

class Request : NSObject, NSCoding {
    var type: BusinessType!
    var category: BusinessCategory!
    var services = [Service]()
    var forWho = [TargetUser]()
    var location: RequestLocation?
    var requestPicture: UIImage?
    var requestRecording: URL?
    var date: RequestDate?
    var productItem: String?
    var productBrand: String?
    var minPrice: Int?
    var maxPrice: Int?
    var comment: String?
    var status: RequestStatus
    var shouldSimulate: Bool!
    var simulationResponser = [User]()
    
    init(services: [Service] = [Service](), status: RequestStatus = RequestStatus.Active, requestPicture: UIImage? = nil, location: RequestLocation? = nil, requestRecording: URL? = nil, date: RequestDate? = nil, comment: String? = nil, shouldSimulate: Bool = false, simulationResponser: [User] = [User](), forWho: [TargetUser] = [TargetUser]()) {
        self.services = services
        self.location = location
        self.date = date
        self.comment = comment
        self.forWho = forWho
        self.status = status
        self.requestPicture = requestPicture
        self.shouldSimulate = shouldSimulate
        self.simulationResponser = simulationResponser
    }
    
    var servicesFormatted: String {
        var servicesTitle = "No services"
        if services.count > 0 { servicesTitle = services[0].title }
        if services.count > 1 {
            for i in 1 ..< services.count {
                servicesTitle += ",\n\(services[i].title)"
            }
        }
        return servicesTitle
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(services, forKey: "services")
        aCoder.encode(self.forWho, forKey: "forWho")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(comment, forKey: "comment")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(requestPicture, forKey: "requestPicture")
        aCoder.encode(requestRecording, forKey: "requestRecording")
        aCoder.encode(shouldSimulate, forKey: "shouldSimulate")
        aCoder.encode(simulationResponser, forKey: "simulationResponser")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeObject(forKey: "type") as! BusinessType
        self.category = aDecoder.decodeObject(forKey: "category") as! BusinessCategory
        self.services = aDecoder.decodeObject(forKey: "services") as! [Service]
        self.forWho = aDecoder.decodeObject(forKey: "forWho") as! [TargetUser]
        self.location = aDecoder.decodeObject(forKey: "location") as? RequestLocation
        self.date = aDecoder.decodeObject(forKey: "date") as? RequestDate
        self.comment = aDecoder.decodeObject(forKey: "comment") as? String
        self.status = aDecoder.decodeObject(forKey: "status") as! RequestStatus
        self.requestPicture = aDecoder.decodeObject(forKey: "requestPicture") as? UIImage
        self.requestRecording = aDecoder.decodeObject(forKey: "requestRecording") as? URL
        self.shouldSimulate = aDecoder.decodeObject(forKey: "shouldSimulate") as! Bool
        self.simulationResponser = aDecoder.decodeObject(forKey: "simulationResponser") as! [User]
    }
}

enum RequestStatus {
    case Active
    case Booked
    case Completed
}

enum RequestLocation {
    case myPlace(address: String?, dontShowAddress: Bool)
    case atTheSalon(address: String?, distance: Float)
    
    var iconName: String {
        switch self {
        case .myPlace: return "icon_at_place"
        case .atTheSalon: return "icon_at_salon"
        }
    }
    
    var description: String {
        switch self {
        case .myPlace(let args): return "At my place"
        case .atTheSalon(let args): return "At the salon"
        }
    }
    
    var address: String {
        switch self {
        case .myPlace(let args): return args.address!
        case .atTheSalon(let args): return args.address!
        }
    }
    
    var descriptionForUser: String {
        switch self {
        case .myPlace(let args): return args.address ?? ""
        case .atTheSalon(let args): return args.address ?? ""
        }
    }
}

enum RequestDate {
    case flexible
    case particular(dateRanges: [DateRange])
    
    static let unknownDate = "Unknown date"
    
    var count: Int {
        switch self {
        case .flexible: return 1
        case .particular(let dateRanges): return dateRanges.count
        }
    }
    
    var iconName: String {
        switch self {
        case .flexible: return "icon_flexible"
        case .particular: return "icon_particular"
        }
    }
    
    func getDescription(index: Int? = nil, short: Bool = false) -> String {
        switch self {
        case .flexible: return "Flexible"
        case .particular(let dateRanges):
            guard let index = index else { break }
            let dateRange = dateRanges[index]
            if short {
                return "\(dateRange.dateToWithDayOfWeekFormatted)"
            } else {
                return "\(dateRange.dateFromWithDayOfWeekFormatted) - \(dateRange.dateToWithDayOfWeekFormatted)"               
            }
        }
        return RequestDate.unknownDate
        
    }
    
    var startDateFormatted: String {
        switch self {
        case .flexible: return getDescription()
        case .particular(let dateRanges):
            if let firstDateRange = dateRanges.first { return firstDateRange.dateFromForRequestDetailsFormatted }
        }
        return RequestDate.unknownDate
    }
    
    var timeRange: String {
        switch self {
        case .flexible: return getDescription()
        case .particular(let dateRanges):
            if let firstDateRange = dateRanges.last { return "\(firstDateRange.timeFromFormatted) - \(firstDateRange.timeToFormatted)"}
        }
        return RequestDate.unknownDate
    }
    
    var endDateFormatted: String {
        switch self {
        case .flexible: return getDescription()
        case .particular(let dateRanges):
            if let firstDateRange = dateRanges.last { return firstDateRange.dateToForRequestDetailsFormatted }
        }
        return RequestDate.unknownDate
    }
    
    var startDateAndTimeFormatted: String {
        switch self {
        case .flexible: return getDescription()
        case .particular(let dateRanges):
            if let firstDateRange = dateRanges.first { return firstDateRange.dateFromWithDayOfWeekFormatted }
        }
        return RequestDate.unknownDate
    }
    
    var endDateAndTimeFormatted: String {
        switch self {
        case .flexible: return getDescription()
        case .particular(let dateRanges):
            if let endDateRange = dateRanges.last { return endDateRange.dateToWithDayOfWeekFormatted }
        }
        return RequestDate.unknownDate
    }
}
