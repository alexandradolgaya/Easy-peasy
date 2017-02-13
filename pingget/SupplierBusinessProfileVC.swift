//
//  SupplierBusinessProfileVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class SupplierBusinessProfileVC: SelectServiceVC {
    
    @IBOutlet weak var backView: ViewShadow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4
    }
    
    override func createHeaders() {
        headers = [HeaderFilledIndicator(title: "CHOOSE SERVICE OR PRODUCT:")]
    }
    
    @IBAction func sectionButtoPressed(_ sender: SectionButton) {
        super.showCategories(for: sender.parentCellIndexPath!, tableView: super.tableView)
    }
    
    
    @IBAction func buttonNextTapped(_ sender: AnyObject) {
        let isService = selectedBusinessType?.title == "Service" ? true : false
        if selectedBusinessType != nil && selectedBusinessCategory != nil && selectedServices.count > 0 {
            if isService == true && selectedTargetUsers.count > 0 {
                performSegue(withIdentifier: SelectServiceVC.showAddressSegue, sender: sender)
            }
            else if isService == false {
                performSegue(withIdentifier: SelectServiceVC.showAddressSegue, sender: sender)
            }
        }
    }
}
