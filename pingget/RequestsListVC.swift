//
//  RequestsListVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/23/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RequestsListVC: NavBarVC {
    @IBOutlet weak var tableView: UITableView!
    
    var requests = [Request]() {
        didSet {
            tableView?.reloadData()
            checkSimulation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        registerCells()
        setCellHeight()
    }
    
    private func initTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    private func checkSimulation() {
        guard requests[0].shouldSimulate == true else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            let user1 = User.init(imageUrl:"fake_avatar1", name: "Winston Lamb")
            let user2 = User.init(imageUrl:"fake_avatar2", name: "Margaret Gomez")
            let user3 = User.init(imageUrl:"fake_avatar3", name: "Kristopher Myers")
            self.requests[0].simulationResponser = [user1,user2,user3]
            let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! RequestCell
            cell.configureForSumulation()
        }
    }
    
    private func registerCells() {
        tableView?.register(UINib(nibName: RequestCell.id, bundle: nil), forCellReuseIdentifier: RequestCell.id)
        tableView?.register(UINib(nibName: RequestCell.extendedId, bundle: nil), forCellReuseIdentifier: RequestCell.extendedId)
    }
    
    private func setCellHeight() {
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 192
    }
}

extension RequestsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RequestCell.id, for: indexPath) as! RequestCell
        cell.setData(request: requests[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BaseVC.createVC(storyboard: .user, vcId: MyRequestDetailsVC.id) as? MyRequestDetailsVC
        vc?.setData(request: requests[indexPath.row])
        vc?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(vc!, animated: true, completion: nil)
        //showVC(vc: vc)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
