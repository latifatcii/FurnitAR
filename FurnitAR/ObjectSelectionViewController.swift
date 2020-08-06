//
//  ObjectSelectionViewController.swift
//  FurnitAR
//
//  Created by Latif Atci on 8/5/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

final class ObjectCell: UITableViewCell {
    static let reuseIdentifier = "ObjectCell"

    @IBOutlet weak var nameLabel: UILabel!
}

protocol ObjectSelectionViewControllerDelegate: class {
    func virtualObjectSelectionViewController(_ selectionViewController: ObjectSelectionViewController, didSelectObject: String, indexPath: IndexPath)
    func virtualObjectSelectionViewController(_ selectionViewController: ObjectSelectionViewController, didDeselectObject: String, indexPath: IndexPath)
}
class ObjectSelectionViewController: UITableViewController {

    weak var delegate: ObjectSelectionViewControllerDelegate?
    var objectNames = ["chair", "table", "shelf", "armchair"]
    var selectedObjects = IndexSet()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectCell.reuseIdentifier, for: indexPath) as? ObjectCell else { return UITableViewCell() }
        cell.nameLabel.text = objectNames[indexPath.row].capitalized
        
        if selectedObjects.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object = objectNames[indexPath.row]
        
        if selectedObjects.contains(indexPath.row) {
            delegate?.virtualObjectSelectionViewController(self, didDeselectObject: object, indexPath: indexPath)
        } else {
            delegate?.virtualObjectSelectionViewController(self, didSelectObject: object, indexPath: indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)

        dismiss(animated: true, completion: nil)
    }



}
