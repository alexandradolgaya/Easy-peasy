//
//  SupplierBusinessProfileVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class SelectServiceVC: NavBarVC {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoView: UIView!
    
    var headers = [HeaderFilledIndicator]() {
        didSet { reloadTableView() }
    }
    var selectedBusinessType: BusinessType? = nil
    var selectedBusinessCategory : BusinessCategory? = nil
    var selectedServices = [Service]()
    var selectedSection: Int = 0
    var selectedTargetUsers = [TargetUser]()
    var provideAtHomeSelected: Bool? = false
    
    
    static let id = "SelectServiceVC"
    static let showAddressSegue = "ShowAddressSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewsForKeyboard()
        registerCell()
        createHeaders()
    }
    
    func createHeaders() {
        headers = [HeaderFilledIndicator]()
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: HeaderFilledIndicatorCell.id, bundle: nil), forCellReuseIdentifier: HeaderFilledIndicatorCell.id)
        tableView.register(UINib(nibName: ImageTitleCell.id, bundle: nil), forCellReuseIdentifier: ImageTitleCell.id)
        tableView.register(UINib(nibName: ProvideAtHomeCell.id, bundle: nil), forCellReuseIdentifier: ProvideAtHomeCell.id)
    }
    
    private func setViewsForKeyboard() {
        scrollViewForKeyboard = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }
    
    func showCategories(for indexPath: IndexPath, tableView: UITableView) {
        switch SelectableSections(rawValue: indexPath.section) {
        case .businessType?:
            let selectionItems = businessTypes.map({ SelectionItem(title: $0.title,
                                                                   imageName: $0.imageName,
                                                                   selected: selectedBusinessType?.title == $0.title ? true : false)})
            MultipleSelectionListPopup.show(multipleSelection: false, fromVC: self, title: "Choose service or product", selectionItems: selectionItems, delegate: self)
            break
        case .businessCategory?:
            let selectionItems = selectedBusinessType!.categories.map({ SelectionItem(title: $0.title,
                                                                                      imageName: $0.imageName,
                                                                                      selected: selectedBusinessCategory?.title == $0.title ? true : false) })
            MultipleSelectionListPopup.show(multipleSelection: false, fromVC: self, title: "Choose Category", selectionItems: selectionItems, delegate: self)
            break
        case .services?:
            let cell = tableView.cellForRow(at: indexPath)
            if cell is ImageTitleCell {
                let selectionItems = self.selectedBusinessCategory!.services.map({ SelectionItem(title: $0.title,
                                                                                                 imageName: $0.imageName,
                                                                                                 selected: selectedServices.contains($0)) })
                MultipleSelectionListPopup.show(fromVC: self, title: "Choose subcategory(s)", selectionItems: selectionItems, delegate: self)
            }
            else {
                self.provideAtHomeSelected = !self.provideAtHomeSelected!
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            break
        case .forWho?:
            let selectionItems = targetUsers.map({ SelectionItem(title: $0.title,
                                                                 imageName: $0.imageName,
                                                                 selected: selectedTargetUsers.contains($0)/*selectedTargetUser?.title == $0.title ? true : false*/) })
            MultipleSelectionListPopup.show(fromVC: self, title: "For whom do you provide services?", selectionItems: selectionItems, delegate: self)
            break
        default: break
        }
        selectedSection = indexPath.section
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension SelectServiceVC: UITableViewDataSource, UITableViewDelegate {
    
    enum SelectableSections: Int {
        case businessType
        case businessCategory
        case services
        case forWho
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SelectableSections(rawValue: section) {
        case .businessType?: return 1
        case .businessCategory?: return 1
        case .services?:
            let selectedServicesCount = selectedServices.count
            return selectedServicesCount > 0  ? selectedServicesCount + 1 : 2
        case .forWho?:
            let selectedUsersCount = selectedTargetUsers.count
            return selectedUsersCount > 0 ? selectedUsersCount : 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: HeaderFilledIndicatorCell.id) as! HeaderFilledIndicatorCell
        headerView.setData(header: headers[section], indexPath: IndexPath.init(row: 0, section: section))
        return headerView.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerViewHeight: CGFloat = 50.0
        return headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var headerViewHeight: CGFloat = 75.0
        switch SelectableSections(rawValue: indexPath.section) {
        case .services?:
            headerViewHeight = 75.0
            if selectedServices.count > 0 && indexPath.row == selectedServices.count {
                headerViewHeight = 44.0
            }
            else if selectedServices.count == 0 && indexPath.row == 1 {
                headerViewHeight = 44.0
            }
            break
        default:
//            let selectedServicesCount = selectedServices.count
//            headerViewHeight = selectedServicesCount > 0 ? CGFloat(selectedServicesCount * 75) : 75.0
            break
        }
        return headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == SelectableSections.services.rawValue) && (selectedServices.count > 0 && indexPath.row == selectedServices.count) || (selectedServices.count == 0 && indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProvideAtHomeCell.id, for: indexPath) as! ProvideAtHomeCell
            let isService = selectedBusinessType?.title == "Service" ? true : false
            cell.setText(service: isService)
            cell.setSelected(selected: provideAtHomeSelected!)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
            cell.clearData()
            switch SelectableSections(rawValue: indexPath.section) {
            case .businessType?: cell.setData(businessType: selectedBusinessType)
            case .businessCategory?: cell.setData(businessCategory: selectedBusinessCategory)
            case .services?:
                if selectedServices.isEmpty { cell.setData(service: nil) }
                else { cell.setData(service: selectedServices[indexPath.row]) }
            case .forWho?:
                if selectedTargetUsers.isEmpty { cell.setData(targetUser: nil) }
                else { cell.setData(targetUser: selectedTargetUsers[indexPath.row]) }
//                cell.setData(targetUser: selectedTargetUser)
            default: break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showCategories(for: indexPath, tableView: tableView)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension SelectServiceVC: SelectionListPopupDelegate {
    func finishedSelection(selectedItemsIndexes: [Int]) {
        infoView.isHidden = true
        switch selectedSection {
        case 0:
            selectedBusinessType = nil
            selectedBusinessCategory = nil
            selectedServices = [Service]()
            createHeaders()
            if selectedItemsIndexes.count > 0 {
                selectedBusinessType = businessTypes[selectedItemsIndexes.first!]
                headers.append(HeaderFilledIndicator(title: "CATEGORY:"))
                let header = headers[0]
                header.filled = true
            }
            break
        case 1:
            selectedBusinessCategory = nil
            selectedServices = [Service]()
            headers.removeLast(headers.count - 2)
            if selectedItemsIndexes.count > 0 {
                selectedBusinessCategory = selectedBusinessType?.categories[selectedItemsIndexes.first!]
                headers.append(HeaderFilledIndicator(title: "SUBCATEGORY:"))
                let header = headers[1]
                header.filled = true
            }
            break
        case 2:
            selectedServices = [Service]()
            headers.removeLast(headers.count - 3)
            let isService = selectedBusinessType?.title == "Service" ? true : false
            if selectedItemsIndexes.count > 0 {
                var i = 0
                selectedServices.removeAll()
                for service in selectedBusinessCategory!.services {
                    if selectedItemsIndexes.contains(i) { selectedServices.append(service) }
                    i += 1
                }
                let isService = selectedBusinessType?.title == "Service" ? true : false
                if isService == true {
                    headers.append(HeaderFilledIndicator(title: "FOR WHO:"))
                }
                else {
                    infoView.isHidden = false
                }
                let header = headers[2]
                header.filled = true
            }
            else {
                if isService == false {
                    infoView.isHidden = false
                }
            }
            break
        case 3:
            selectedTargetUsers = [TargetUser]()//nil
            headers.removeLast(headers.count - 4)
            if selectedItemsIndexes.count > 0 {
//                selectedTargetUser = targetUsers[selectedItemsIndexes.first!]
                var i = 0
                selectedTargetUsers.removeAll()
                for targetUser in targetUsers {
                    if selectedItemsIndexes.contains(i) { selectedTargetUsers.append(targetUser) }
                    i += 1
                }
                let header = headers[3]
                header.filled = true
                infoView.isHidden = false
            }
            else {infoView.isHidden = true}
            break
        default:
            break
        }
        
        reloadTableView()
    }
}

class HeaderFilledIndicator {
    var title: String
    var filled: Bool
    
    init(title: String, filled: Bool = false) {
        self.title = title
        self.filled = filled
    }
}
