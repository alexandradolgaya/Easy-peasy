//
//  MyRequestsVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/22/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class MyRequestsVC: RequestsListVC {
    
    static let id = "MyRequestsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        let user1 = User.init(imageUrl:"fake_avatar4", name: "Andy Pereira")
        let user2 = User.init(imageUrl:"fake_avatar5", name: "John Galt")
        let user3 = User.init(imageUrl:"fake_avatar6", name: "Gary Loomis")
        requests = [Request(services: [Service(title: "Manicure", imageName: "icon_manicure")],
                            status: RequestStatus.Active,
                            location: RequestLocation.atTheSalon(address: "91 Western Road", distance: 2),
                            date: RequestDate.particular(dateRanges: [DateRange(dateFrom: Date(), dateTo: Date(), timeFrom: Date(), timeTo: Date())]),
                            forWho: [targetUsers.first!]),
                    Request(services: [Service(title: "Haircut and styling", imageName: "icon_haircut")],
                            status: RequestStatus.Active,
                            location: RequestLocation.atTheSalon(address: "91 Western Road", distance: 2),
                            date: RequestDate.particular(dateRanges: [DateRange(dateFrom: Date(), dateTo: Date(), timeFrom: Date(), timeTo: Date())]),
                            simulationResponser: [user1, user2, user3],
                            forWho: [targetUsers.last!]),
                    Request(services: [Service(title: "Manicure", imageName: "icon_manicure")],
                            status: RequestStatus.Active,
                            location: RequestLocation.atTheSalon(address: "91 Western Road", distance: 2),
                            date: RequestDate.particular(dateRanges: [DateRange(dateFrom: Date(), dateTo: Date(), timeFrom: Date(), timeTo: Date())]),
                            forWho: [targetUsers.first!]),
                    Request(services: [Service(title: "Haircut and styling", imageName: "icon_haircut")],
                            status: RequestStatus.Active,
                            location: RequestLocation.atTheSalon(address: "91 Western Road", distance: 2),
                            date: RequestDate.particular(dateRanges: [DateRange(dateFrom: Date(), dateTo: Date(), timeFrom: Date(), timeTo: Date())]),
                            forWho: [targetUsers.last!])]
        if let request = Storage.sharedStorage.request {
//            let request = NSKeyedUnarchiver.unarchiveObject(with: requestData) as! Request
            request.shouldSimulate = true
            requests.insert(request, at: 0)
//            UserDefaults.standard.removeObject(forKey: "created_request")
            Storage.sharedStorage.request = nil
        }
    }
}

extension MyRequestsVC: TabBarChildVC {
    static func create() -> UIViewController? {
        return BaseVC.createVC(storyboard: .user, vcId: MyRequestsVC.id)
    }

//    func create() -> UIViewController? {
//        
//    }
}
