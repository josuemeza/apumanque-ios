//
//  StoresViewController.swift
//  Apumanque
//
//  Created by Rinnno on 19-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class StoresViewController: BlurredViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Attributes
    
    private(set) var stores = [Store]()
    private(set) var storeCategory: StoreCategory?
    private var sectionNames = [Character]()
    private var groupedStores = [Character: [Store]]()
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build(withOpaqueNavigationBar: true)
        initData()
    }
    
    // MARK: - Navigation controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BlurredViewController {
            let viewController: BlurredViewController
            if segue.destination is StoreCategoriesViewController {
                let storeCategories = segue.destination as! StoreCategoriesViewController
                storeCategories.delegate = self
                viewController = storeCategories
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = backgroundImage
        } else if segue.destination is StoreViewController {
            let viewController = segue.destination as! StoreViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let store = groupedStores[sectionNames[indexPath.section]]![indexPath.row]
            viewController.store = store
        }
    }
    
    // MARK: - Methods
    
    private func initData() {
        if let category = storeCategory {
            titleLabel.text = category.name
            stores = category.stores?.allObjects as? [Store] ?? []
        } else {
            titleLabel.text = "Locales"
            stores = Store.all(on: managedObjectContext) ?? []
        }
        groupedStores = Dictionary(grouping: stores, by: { store in store.name?.first ?? "-" })
        sectionNames = groupedStores.keys.sorted()
        groupedStores.forEach { key, value in groupedStores[key] = value.sorted { left, right in left.name ?? "" < right.name ?? "" } }
        tableView.reloadData()
    }

}

// MARK: -
// MARK: - Table view data source and delegate methods
extension StoresViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedStores[sectionNames[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let store = groupedStores[sectionNames[indexPath.section]]?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "store_list_table_cell", for: indexPath) as! StoreListTableViewCell
        cell.nameLabel.text = store.name
        cell.descriptionLabel.text = store.detail
        cell.storeNumberLabel.text = "Local \(store.number ?? "S/N")"
        cell.floorLabel.text = "Piso \(store.floor ?? "S/N")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionNames[section])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension StoresViewController: StoreCategoriesViewControllerDelegate {
    
    func storeCategories(_ controller: StoreCategoriesViewController, didSelectCategory category: StoreCategory) {
        storeCategory = category
        initData()
    }
    
}
