//
//  StoreCategoriesViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 29-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

protocol StoreCategoriesViewControllerDelegate {
    func storeCategories(_ controller: StoreCategoriesViewController, didSelectCategory category: StoreCategory)
}

class StoreCategoriesViewController: BlurredViewController {
    
    private(set) var storeCategories = [StoreCategory]()
    var delegate: StoreCategoriesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "logo"), for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        
        build()
        storeCategories = StoreCategory.all(on: managedObjectContext) ?? []
        storeCategories = storeCategories.sorted { left, right in (left.name ?? "-") < (right.name ?? "-") }
    }

}

// MARK: - Table view data source and delegate
extension StoreCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store_categories_table_cell", for: indexPath)
        let storeCategory = storeCategories[indexPath.row]
        cell.textLabel?.text = storeCategory.name
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = storeCategories[indexPath.row]
        delegate?.storeCategories(self, didSelectCategory: category)
        navigationController?.popViewController(animated: true)
    }
    
}
