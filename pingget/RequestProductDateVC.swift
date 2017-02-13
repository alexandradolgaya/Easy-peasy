//
//  RequestProductDateVC.swift
//  pingget
//
//  Created by Victor on 03.01.17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import UIKit

class RequestProductDateVC: NavBarVC {

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var backView: ViewShadow!

//    @IBOutlet weak var particularDateDetailsView: UIView!
//    @IBOutlet weak var particularViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var nextButtonViewHeightConstraint: NSLayoutConstraint! {
//        didSet {
//            nextButtonViewHeight = nextButtonViewHeightConstraint.constant
//        }
//    }
    @IBOutlet weak var flexibleTimeCheckbox: UIImageView!
    @IBOutlet weak var particularTimeCheckbox: UIImageView!
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!
    
    static let id = "RequestProductDateVC"
    
    var request: Request?
    var doneButtonDelegate: RequestDoneButtonDelegate?
    
    var footerFullHeight: CGFloat = 0
    var nextButtonViewHeight: CGFloat = 0
    var hintViewHeight: CGFloat = 91
    
    var dateRangeFromPicking: Bool?
    
    var dateRanges = [DateRange.defaultRange] {
        didSet { reloadListData() }
    }
    var pickerViewHeight: CGFloat { return pickerView.frame.height }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4.0
        flexibleDateTapped(self)
    }
    
    func showPickerView(mode: UIDatePickerMode, dateRangeIndex: Int, initialDate: Date, dateRangeFromPicking: Bool) {
        self.dateRangeFromPicking = dateRangeFromPicking
        datePickerView.datePickerMode = mode
        datePickerView.tag = dateRangeIndex
        datePickerView.date = initialDate
        animatePickerAppearingIfNeeded()
    }
    
    private func animatePickerAppearingIfNeeded() {
        guard pickerView.isHidden else { return }
        pickerViewBottomConstraint.constant = -pickerViewHeight
        layoutView()
        UIView.animate(withDuration: animationDuration) {
            self.pickerViewBottomConstraint.constant = 0
            self.tableView?.contentSize.height += self.pickerViewHeight
            self.layoutView()
        }
        pickerView.isHidden = false
    }
    
    func hidePickerView() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.pickerViewBottomConstraint.constant = -self.pickerView.frame.height
            self.tableView?.contentSize.height -= self.pickerViewHeight
            self.layoutView()
        }) { (completed) in
            self.pickerView.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        updateTableViewHeaderAndFooter()
    }
    
    private func updateTableViewHeaderAndFooter() {
        guard let requestDateType = request?.date else {
            hideParticularDateDetailsView()
            return
        }
        switch requestDateType {
        case .flexible: hideParticularDateDetailsView()
        case .particular: showParticularDateDetailsView()
        }
    }
    
    private func updateTableView() {
        updateTableViewHeaderAndFooter()
        reloadListData()
    }
    
    private func reloadListData() {
        tableView?.reloadData()
    }
    
    private func showParticularDateDetailsView() {
//        particularDateDetailsView.isHidden = false
        particularTimeCheckbox.image = UIImage.init(named: "icon_selected")
        flexibleTimeCheckbox.image = UIImage.init(named: "icon_not_selected")
    }
    
    private func hideParticularDateDetailsView() {
//        particularDateDetailsView.isHidden = true
        flexibleTimeCheckbox.image = UIImage.init(named: "icon_selected")
        particularTimeCheckbox.image = UIImage.init(named: "icon_not_selected")
    }
    
    private func setRequestDate(date: RequestDate) {
        request?.date = date
        updateTableView()
    }
    
    private func updateRequestDate() {
        guard let requestDate = request?.date else { return }
        switch requestDate {
        case .flexible: request?.date = requestDate
        case .particular: request?.date = .particular(dateRanges: dateRanges)
        }
    }
    
    @IBAction func flexibleDateTapped(_ sender: AnyObject) {
        setRequestDate(date: .flexible)
    }
    
    @IBAction func particularDateTapped(_ sender: AnyObject) {
        setRequestDate(date: .particular(dateRanges: dateRanges))
    }
    
    @IBAction func pickerCancelTapped(_ sender: AnyObject) {
        hidePickerView()
    }
    
    @IBAction func pickerDoneTapped(_ sender: AnyObject) {
        hidePickerView()
        guard let dateRangeFromPicking = dateRangeFromPicking else { return }
        let itemIndex = datePickerView.tag
        let dateRange = dateRanges[itemIndex]
        let pickerDate = datePickerView.date
        switch datePickerView.datePickerMode {
        case .date:
            if dateRangeFromPicking { dateRange.dateFrom = pickerDate }
            else { dateRange.dateTo = pickerDate }
        case .time:
            if dateRangeFromPicking { dateRange.timeFrom = pickerDate }
            else { dateRange.timeTo = pickerDate }
        default: break
        }
        tableView?.reloadRows(at: [IndexPath(row: itemIndex, section: 0)], with: .none)
    }
    
    @IBAction func nextTapped(_ sender: AnyObject) {
        updateRequestDate()
        if let doneButtonDelegate = doneButtonDelegate, let request = request { doneButtonDelegate.doneTapped(request: request) }
        else { performSegue(withIdentifier: CreateRequestDetailsVC.productId, sender: nil) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let requestDetailsVC = segue.destination as? CreateRequestDetailsVC else { return }
        requestDetailsVC.setData(request: request)
    }
}

extension RequestProductDateVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let requestDate = request?.date else { return 0 }
        switch requestDate {
        case .particular: return dateRanges.count
        case .flexible: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DateTimeRangeCell.id, for: indexPath) as! DateTimeRangeCell
        let itemIndex = indexPath.row
        cell.setProductData(dateRange: dateRanges[itemIndex], index: itemIndex, delegate: self)
        return cell
    }
}

extension RequestProductDateVC: DateTimeRangeDelegate {
    func dateFromTapped(index: Int) {
        showPickerView(mode: .date, dateRangeIndex: index, initialDate: dateRanges[index].dateFrom, dateRangeFromPicking: true)
    }
    
    func dateToTapped(index: Int) {
        showPickerView(mode: .date, dateRangeIndex: index, initialDate: dateRanges[index].dateTo, dateRangeFromPicking: false)
    }
    
    func timeFromTapped(index: Int) {
        showPickerView(mode: .time, dateRangeIndex: index, initialDate: dateRanges[index].timeFrom, dateRangeFromPicking: true)
    }
    
    func timeToTapped(index: Int) {
        showPickerView(mode: .time, dateRangeIndex: index, initialDate: dateRanges[index].timeTo, dateRangeFromPicking: false)
    }
    
    func timeTapped(index: Int) {
        showPickerView(mode: .time, dateRangeIndex: index, initialDate: dateRanges[index].timeTo, dateRangeFromPicking: false)
    }
    
    func dateTapped(index: Int) {
        showPickerView(mode: .date, dateRangeIndex: index, initialDate: dateRanges[index].dateTo, dateRangeFromPicking: false)
    }
}

extension RequestProductDateVC: RequestHolder {
    func setRequestData(request: Request?, doneButtonDelegate: RequestDoneButtonDelegate?) {
        self.request = request
        self.doneButtonDelegate = doneButtonDelegate
        guard let requestDate = request?.date else { return }
        switch requestDate {
        case .particular(let dateRanges): self.dateRanges = dateRanges
        default: break
        }
    }
}

