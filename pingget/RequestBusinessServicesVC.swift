//
//  RequestBusinessServices.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/21/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RequestBusinessServicesVC: NavBarVC {
    
    @IBOutlet weak var backView: ViewShadow!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var selectBusinessTypeTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var doneButtonDelegate: RequestDoneButtonDelegate?
    var request: Request! = Request.init()
    
    var headers = [HeaderFilledIndicator]() {
        didSet { reloadTableView() }
    }
    var selectableBusinessTypes = [SelectionItem]()
    var selectedBusinessType: BusinessType? = nil
    var selectedBusinessCategory : BusinessCategory? = nil
    var selectedServices = [Service]()
    var selectedSection: Int = 0
    var selectedTargetUsers = [TargetUser]()
    var provideAtHomeSelected: Bool? = false
    
    var selectedIndexPath : IndexPath? = nil
    
    var pressedSection: Int?
    
    static let id = "SelectServiceVC"
    static let showAddressSegue = "ShowAddressSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4
        setViewsForKeyboard()
        registerCell()
        createHeaders()
        convertBusinessTypes()
        setTitle()
        updateCategories()
    }
    
    private func convertBusinessTypes() {
        selectableBusinessTypes = businessTypes.map({ SelectionItem(title: $0.title,
                                                                    imageName: $0.imageName,
                                                                    selected: selectedBusinessType?.title == $0.title ? true : false)})
    }
    
    func updateCategories() {
        if request.services.count > 0 {
            selectedBusinessType = request.type
            selectBusinessTypeTableView.isHidden = true
            setTitle()
            selectedBusinessCategory = request.category
            selectedServices = request.services
            createHeaders()
            headers.append(HeaderFilledIndicator(title: "CATEGORY:"))
            headers.append(HeaderFilledIndicator(title: "SUBCATEGORY:"))
//            let header = headers[0]
//            header.filled = true
            let isService = selectedBusinessType?.title == "Service" ? true : false
            if isService == true {
                headers.append(HeaderFilledIndicator(title: "FOR WHO:"))
            }
//            let header = headers[1]
//            header.filled = true
            selectedTargetUsers = request.forWho
//            headers.removeLast(headers.count - 3)
//                for targetUser in targetUsers {
//                    if selectedItemsIndexes.contains(i) { selectedTargetUsers.append(targetUser) }
//                    i += 1
//                }
//                let header = headers[2]
//                header.filled = true
//            }

            reloadTableView()
        }
    }
    
    private func setTitle() {
        if selectedBusinessType == nil {
            titleLabel.text = "Choose service or product"
        }
        else {
            titleLabel.text = "Choose category and subcategory"
        }
    }
    
    func createHeaders() {
        headers = [HeaderFilledIndicator]()
    }
    
    private func registerCell() {
        mainTableView.register(UINib(nibName: HeaderFilledIndicatorCell.id, bundle: nil), forCellReuseIdentifier: HeaderFilledIndicatorCell.id)
        mainTableView.register(UINib(nibName: ImageTitleCell.id, bundle: nil), forCellReuseIdentifier: ImageTitleCell.id)
        mainTableView.register(UINib(nibName: ProvideAtHomeCell.id, bundle: nil), forCellReuseIdentifier: ProvideAtHomeCell.id)
    }
    
    private func setViewsForKeyboard() {
        scrollViewForKeyboard = mainTableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }
    
    @IBAction func nextTapped(_ sender: AnyObject) {
        if selectBusinessTypeTableView.isHidden == false {
            if selectedIndexPath != nil {
                selectedBusinessType = businessTypes[selectedIndexPath!.row]
                selectBusinessTypeTableView.isHidden = true
                setTitle()
                selectedBusinessCategory = nil
                selectedServices = [Service]()
                createHeaders()
                headers.append(HeaderFilledIndicator(title: "CATEGORY:"))
//                header.filled = true
                reloadTableView()

            }
        }
        else {
            updateRequestInfo()
//            if let doneButtonDelegate = doneButtonDelegate { doneButtonDelegate.doneTapped(request: request) }
//            else {
            if dataFilled() == true {
                if selectedBusinessType?.title == "Service" {
                    performSegue(withIdentifier: RequestLocationVC.id, sender: nil)
                }
                else {
                    performSegue(withIdentifier: "ShowProductDetailsSegue", sender: nil)
                }
            }
//            }
        }
    }
    
    private func updateRequestInfo() {
        request.type = selectedBusinessType
        request.category = selectedBusinessCategory
        request.services = selectedServices
        let isService = selectedBusinessType?.title == "Service" ? true : false
        if isService == true {
            request.forWho = selectedTargetUsers
        }
    }
    
    private func dataFilled() -> Bool {
        var isFilled = true
        if request.type == nil || request.category == nil {
            isFilled = false
        }
        if request.services.count == 0 {
            isFilled = false
        }
        let isService = selectedBusinessType?.title == "Service" ? true : false
        if isService == true && request.forWho.count == 0 {
            isFilled = false
        }
        return isFilled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let requestHolder = segue.destination as? RequestHolder else { return }
        requestHolder.setRequestData(request: request, doneButtonDelegate: nil)
    }
    
    /// Show categories for pressed indexPath. Used for default on press on section.
    func showCategories(for indexPath: IndexPath, tableView: UITableView) {
        switch SectionsForSelection(rawValue: indexPath.section) {
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
            
            MultipleSelectionListPopup.show(
                multipleSelection: (UserDefaults.standard.object(forKey: "user_type") as! String == "supplier"),
                                            fromVC: self,
                                            title: "For whom is the service needed?",
                                            selectionItems: selectionItems,
                                            delegate: self)
            break
        default: break
        }
        selectedSection = indexPath.section
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension RequestBusinessServicesVC: UITableViewDataSource, UITableViewDelegate, HeaderFilledIndicatorCellDelegate {
    
    enum SectionsForSelection: Int {
        case businessCategory
        case services
        case forWho
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == selectBusinessTypeTableView {
            return 1
        }
        else {return headers.count}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectBusinessTypeTableView {
            return 2
        }
        else {
            switch SectionsForSelection(rawValue: section) {
            case .businessCategory?: return 1
            case .services?:
                let selectedServicesCount = selectedServices.count
                return selectedServicesCount > 0 ? selectedServicesCount : 1
            case .forWho?:
                let selectedUsersCount = selectedTargetUsers.count
                return selectedUsersCount > 0 ? selectedUsersCount : 1
            default: return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView != selectBusinessTypeTableView {
            let headerView = tableView.dequeueReusableCell(withIdentifier: HeaderFilledIndicatorCell.id) as! HeaderFilledIndicatorCell
            headerView.setData(header: headers[section], indexPath: nil)
            /* Added delegation > press on header functional */
            if tableView != selectBusinessTypeTableView {
                headerView.section = section
                headerView.delegate = self
            }
            return headerView
        }
        else {return UIView.init(frame: CGRect.zero)}
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != selectBusinessTypeTableView {
            let headerViewHeight: CGFloat = 50.0
            return headerViewHeight
        }
        else {return CGFloat.leastNormalMagnitude}
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == selectBusinessTypeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectionItemCell.id, for: indexPath) as! SelectionItemCell
            cell.setData(selectionItem: selectableBusinessTypes[indexPath.row])
            return cell
        }
        else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleCell.id, for: indexPath) as! ImageTitleCell
                cell.clearData()
                switch SectionsForSelection(rawValue: indexPath.section) {
                case .businessCategory?: cell.setData(businessCategory: selectedBusinessCategory)
                case .services?:
                    if selectedServices.isEmpty { cell.setData(service: nil) }
                    else { cell.setData(service: selectedServices[indexPath.row]) }
                case .forWho?:
                    if selectedTargetUsers.isEmpty { cell.setData(targetUser: nil) }
                    else { cell.setData(targetUser: selectedTargetUsers[indexPath.row]) }
                default: break
                }
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectBusinessTypeTableView {
            if let _ = selectedIndexPath {
                let selectionItem = selectableBusinessTypes[indexPath.row]
                selectionItem.selected = !selectionItem.selected
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                if selectedIndexPath != indexPath {
                    let previousSelectionItem = selectableBusinessTypes[selectedIndexPath!.row]
                    previousSelectionItem.selected = false
                    tableView.reloadRows(at: [selectedIndexPath!], with: UITableViewRowAnimation.fade)
                    selectedIndexPath = indexPath
                }
            }
            else {
                let selectionItem = selectableBusinessTypes[indexPath.row]
                selectionItem.selected = !selectionItem.selected
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                selectedIndexPath = indexPath
            }
        }
        else {            
            self.showCategories(for: indexPath, tableView: tableView)
        }
    }
    
    func reloadTableView() {
        mainTableView.reloadData()
    }
    
    // MARK: HeaderFilledIndicatorCellDelegate
    
    func sectionPressed(section: Int) {
        self.showCategories(for: IndexPath.init(row: 0, section: section), tableView: mainTableView)
    }
}

extension RequestBusinessServicesVC: SelectionListPopupDelegate {
    func finishedSelection(selectedItemsIndexes: [Int]) {
        switch selectedSection {
        case 0:
            selectedBusinessCategory = nil
            selectedServices = [Service]()
            headers.removeLast(headers.count - 1)
            if selectedItemsIndexes.count > 0 {
                selectedBusinessCategory = selectedBusinessType?.categories[selectedItemsIndexes.first!]
                headers.append(HeaderFilledIndicator(title: "SUBCATEGORY:"))
                let header = headers[0]
                header.filled = true
            }
            break
        case 1:
            selectedServices = [Service]()
            headers.removeLast(headers.count - 2)
            let isService = selectedBusinessType?.title == "Service" ? true : false
            if selectedItemsIndexes.count > 0 {
                selectedServices.removeAll()
                //Commented to make only Beauty selectable
//                var i = 0
//                for service in selectedBusinessCategory!.services {
//                    if selectedItemsIndexes.contains(i) { selectedServices.append(service) }
//                    i += 1
//                }
                selectedServices.append(selectedBusinessCategory!.services.first!) //Remove then
                if isService == true {
                    headers.append(HeaderFilledIndicator(title: "FOR WHO:"))
                }
                let header = headers[1]
                header.filled = true
            }
            break
        case 2:
            selectedTargetUsers = [TargetUser]()//nil
            headers.removeLast(headers.count - 3)
            if selectedItemsIndexes.count > 0 {
                var i = 0
                selectedTargetUsers.removeAll()
                for targetUser in targetUsers {
                    if selectedItemsIndexes.contains(i) { selectedTargetUsers.append(targetUser) }
                    i += 1
                }
                let header = headers[2]
                header.filled = true
            }
            break
        default:
            break
        }
        
        reloadTableView()
    }
}

extension RequestBusinessServicesVC: RequestHolder {
    
    func setRequestData(request: Request?, doneButtonDelegate: RequestDoneButtonDelegate?) {
        self.doneButtonDelegate = doneButtonDelegate
        guard let request = request else { return }
        self.request = request
        //selectedBusinessType = request.type
        selectedServices = request.services
    }
}
