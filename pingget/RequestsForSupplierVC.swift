//
//  RequestListVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/23/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RequestsForSupplierVC: RequestsListVC {
    
    @IBOutlet weak var newClientsButton: UIButton!
    @IBOutlet weak var allClientsButton: UIButton!
    @IBOutlet weak var newClientsIndicator: YellowGradientView!
    @IBOutlet weak var allClientsIndicator: YellowGradientView!
    
    var headers = ["LATEST", "YESTERDAY"]
    var sections = [String: [Request]]() {
        didSet { tableView?.reloadData() }
    }
    
    var requestsListType = RequestsListType.newClients {
        didSet { tableView?.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newClientsTapped(newClientsButton)
        loadData()
    }
    
    private func loadData() {
        requests = [Request(services: [Service(title: "Manicure", imageName: "icon_manicure")],
                            status: RequestStatus.Active,
                            location: RequestLocation.atTheSalon(address: "At the salon", distance: 2),
                            date: RequestDate.particular(dateRanges: [DateRange(dateFrom: Date(), dateTo: Date(), timeFrom: Date(), timeTo: Date())]),
                            forWho: [targetUsers.first!]),
                    Request(services: [Service(title: "Haircut and styling", imageName: "icon_haircut")],
                            status: RequestStatus.Active,
                            location: RequestLocation.atTheSalon(address: "At the salon", distance: 2),
                            date: RequestDate.particular(dateRanges: [DateRange(dateFrom: Date(), dateTo: Date(), timeFrom: Date(), timeTo: Date())]),
                            forWho: [targetUsers.last!]),
                    Request(services: [Service(title: "Manicure", imageName: "icon_manicure")],
                            status: RequestStatus.Active,
                            location: RequestLocation.myPlace(address: "91 Western Road", dontShowAddress: false),
                            date: RequestDate.particular(dateRanges: [DateRange(dateFrom: Date(), dateTo: Date(), timeFrom: Date(), timeTo: Date())]),
                            forWho: [targetUsers.first!]),
                    Request(services: [Service(title: "Haircut and styling", imageName: "icon_haircut")],
                            status: RequestStatus.Active,
                            location: RequestLocation.myPlace(address: "91 Western Road", dontShowAddress: true),
                            date: RequestDate.particular(dateRanges: [DateRange(dateFrom: Date(), dateTo: Date(), timeFrom: Date(), timeTo: Date())]),
                            forWho: [targetUsers.last!])]
        if let request = Storage.sharedStorage.request {
//            let request = NSKeyedUnarchiver.unarchiveObject(with: requestData) as! Request
            requests.insert(request, at: 0)
//            UserDefaults.standard.removeObject(forKey: "created_request")
            Storage.sharedStorage.request = nil
        }
        
        sections[self.headers[0]] = [requests[0]]
        sections[self.headers[1]] = [requests[1],
                                   requests[2],
                                   requests[3]]
    }
    
    func getRequest(section: Int, index: Int) -> Request? {
        switch requestsListType {
        case .allClients: return requests[index]
        case .newClients: return sections[headers[section]]?[index]
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return requestsListType == .newClients ? sections.count : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch requestsListType {
        case .allClients: return super.tableView(tableView, numberOfRowsInSection: section)
        case .newClients: return sections[headers[section]]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch requestsListType {
        case .allClients: return super.tableView(tableView, cellForRowAt: indexPath)
        case .newClients:
            guard let request = getRequest(section: indexPath.section, index: indexPath.row) else { break }
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: RequestCell.extendedId, for: indexPath) as! RequestCell
                cell.setData(request: request)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: RequestCell.id, for: indexPath) as! RequestCell
                cell.setData(request: request)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if requestsListType == .newClients {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: TimeHeaderCell.id) as! TimeHeaderCell
            return headerCell.contentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return requestsListType == .newClients ? tableView.sectionHeaderHeight : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        if let requestDetailsVC = segue.destination as? RequestDetailsVC {
            requestDetailsVC.setData(request: getRequest(section: selectedIndexPath.section, index: selectedIndexPath.row))
        }
        tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: RequestDetailsVC.id, sender: nil)
    }
    
    @IBAction func newClientsTapped(_ sender: AnyObject) {
        requestsListType = .newClients
        newClientsButton.setTitleColor(UIColor.white, for: .normal)
        allClientsButton.setTitleColor(UIColor.init(white: 1, alpha: 0.7), for: .normal)
        newClientsIndicator.isHidden = false
        allClientsIndicator.isHidden = true
    }
    
    @IBAction func allClientsTapped(_ sender: AnyObject) {
        requestsListType = .allClients
        newClientsButton.setTitleColor(UIColor.init(white: 1, alpha: 0.7), for: .normal)
        allClientsButton.setTitleColor(UIColor.white, for: .normal)
        newClientsIndicator.isHidden = true
        allClientsIndicator.isHidden = false
    }
}

enum RequestsListType {
    case newClients
    case allClients
}
