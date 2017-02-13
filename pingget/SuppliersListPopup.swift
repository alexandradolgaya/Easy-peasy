//
//  SuppliersListPopup.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/28/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

protocol SuppliersListPopupDelegate: class {
    func supplierSelected(supplier: User, type: SupplierPopupType)
}

enum SupplierPopupType: Int {
    case Booked = 1
    case Completed
}

class SuppliersListPopup: BasePopupVC {
    
    @IBOutlet weak var popupView: ViewShadow!
    @IBOutlet weak var popupHeaderLabel: UILabel!
    
    static let id = "SuppliersListPopup"
    var request: Request?
    weak var delegate: SuppliersListPopupDelegate?
    var headerTitle: String?
    var type: SupplierPopupType!
//    var suppliers = [User(imageUrl: "", name: "Salvador Colon"),
//                     User(imageUrl: "", name: "Nathan Palmer"),
//                     User(imageUrl: "", name: "Fred Carson"),
//                     User(imageUrl: "", name: "Ann Arnold"),
//                     User(imageUrl: "", name: "Winston Lamb"),
//                     User(imageUrl: "", name: "Nobody")];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 4.0
        guard let header = headerTitle else {
            return
        }
        popupHeaderLabel.text = header
    }
    
    static func show(fromVC: UIViewController, request: Request?, type: SupplierPopupType, delegate: SuppliersListPopupDelegate?) {
        let popup = create(popupId: id) as! SuppliersListPopup
        popup.setData(request: request, delegate: delegate)
        popup.type = type
        popup.updateUI(forType: type)
        popup.show(fromVC: fromVC)
    }
    
    private func setData(request: Request?, delegate: SuppliersListPopupDelegate?) {
        self.request = request
        self.delegate = delegate
    }
    
    private func updateUI(forType: SupplierPopupType) {
        switch forType {
        case .Booked:
            headerTitle = "Please, choose the business with \rwhom you agreed"
        case .Completed:
            headerTitle = "Please choose the business, who \rcompleted your request:"
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.close()
    }
}

extension SuppliersListPopup: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rq = self.request {
            return rq.simulationResponser.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleDashedCell.id, for: indexPath) as! ImageTitleDashedCell
        cell.setData(imageUrl: (request?.simulationResponser[indexPath.row].imageUrl)!, title: (request?.simulationResponser[indexPath.row].name)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        close { 
            self.delegate?.supplierSelected(supplier: (self.request?.simulationResponser[indexPath.row])!, type: self.type)
        }
    }
}
