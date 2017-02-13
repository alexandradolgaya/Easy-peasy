//
//  MultipleSelectionListPopup.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class SelectionItem {
    var title: String
    var imageName: String
    var selected = false
    
    init(title: String, imageName: String, selected: Bool = false) {
        self.title = title
        self.imageName = imageName
        self.selected = selected
    }
}

protocol SelectionListPopupDelegate: class {
    func finishedSelection(selectedItemsIndexes: [Int])
}

class MultipleSelectionListPopup: BasePopupVC {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupView: ViewShadow!
    @IBOutlet weak var titleLabel: UILabel!
    
    var selectionItems = [SelectionItem]()
    var isMultipleSelection : Bool = true
    var selectedIndexPath : IndexPath? = nil
    private static let id = "MultipleSelectionListPopup"
    private weak var delegate: SelectionListPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        var height = CGFloat(selectionItems.count) * 75.0 + 75.0 + 75.0
        if height > UIScreen.main.bounds.size.height - 200 {
            height = UIScreen.main.bounds.size.height - 200
        }
        heightConstraint.constant = height
        titleLabel.text = title
        popupView.layer.cornerRadius = 4
    }
    
    static func show(multipleSelection: Bool = true, fromVC: UIViewController, title: String, selectionItems: [SelectionItem], delegate: SelectionListPopupDelegate) {
        let popup = create(popupId: id) as! MultipleSelectionListPopup
        popup.isMultipleSelection = multipleSelection
        popup.initialize(title: title, selectionItems: selectionItems, delegate: delegate)
        popup.show(fromVC: fromVC)
    }
    
    func initialize(title: String, selectionItems: [SelectionItem], delegate: SelectionListPopupDelegate) {
        self.title = title
        self.selectionItems = selectionItems
        self.delegate = delegate
        if isMultipleSelection == false {
            var i = 0
            for selectionItem in selectionItems {
                if selectionItem.selected == true { selectedIndexPath = IndexPath.init(row: i, section: 0) }
                i += 1
            }
        }
    }
    
    @IBAction func doneTapped(_ sender: AnyObject) {
        var selectedItemsIndexes = [Int]()
        if isMultipleSelection == true {
            var i = 0
            for selectionItem in selectionItems {
                if selectionItem.selected { selectedItemsIndexes.append(i) }
                i += 1
            }
        }
        else {
            if selectedIndexPath != nil {                
                let selectionItem = selectionItems[selectedIndexPath!.row]
                if selectionItem.selected {
                    selectedItemsIndexes.append(selectedIndexPath!.row)
                }
            }
        }
        delegate?.finishedSelection(selectedItemsIndexes: selectedItemsIndexes)
        close()
    }
}

extension MultipleSelectionListPopup: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionItemCell.id, for: indexPath) as! SelectionItemCell
        cell.setData(selectionItem: selectionItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMultipleSelection == true {
            let selectionItem = selectionItems[indexPath.row]
            selectionItem.selected = !selectionItem.selected
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
        else {
            if let _ = selectedIndexPath {
                let selectionItem = selectionItems[indexPath.row]
                guard selectionItem.title != "Home" else { return }
                selectionItem.selected = !selectionItem.selected
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                if selectedIndexPath != indexPath {
                    let previousSelectionItem = selectionItems[selectedIndexPath!.row]
                    previousSelectionItem.selected = false
                    tableView.reloadRows(at: [selectedIndexPath!], with: UITableViewRowAnimation.fade)
                    selectedIndexPath = indexPath
                }
            }
            else {
                let selectionItem = selectionItems[indexPath.row]
                guard selectionItem.title != "Home" else { return }
                selectionItem.selected = !selectionItem.selected
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                selectedIndexPath = indexPath
            }
        }
    }
}
