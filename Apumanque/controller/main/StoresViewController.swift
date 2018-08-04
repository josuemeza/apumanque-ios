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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Attributes
    
    private(set) var stores = [Store]()
    private(set) var storeCategory: StoreCategory?
    
    // MARK: - Attribute accessors
    
    private var sectionNames: [Character] {
        get {
            return groupedStores.keys.sorted()
        }
    }
    private var groupedStores: [Character: [Store]] {
        get {
            let filtered: [Store] = stores.compactMap { store in
                if let text = searchBar.text?.lowercased(), !text.isEmpty {
                    if store.name?.lowercased().range(of: text) != nil {
                        return store
                    } else if store.tags?.lowercased().range(of: text) != nil {
                        return store
                    } else if store.number?.lowercased().range(of: text) != nil {
                        return store
                    }
                    return nil
                } else {
                    return store
                }
            }
            var grouped = Dictionary(grouping: filtered) { store -> Character in
                var prefix = store.name?.prefix(1).uppercased() ?? "-"
                prefix = Double(prefix) != nil ? "#" : prefix
                return prefix.folding(options: .diacriticInsensitive, locale: .current).first!
            }
            grouped.forEach { (key, value) in
                grouped[key] = value.sorted { left, right in left.name ?? "" < right.name ?? "" }
            }
            return grouped
        }
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build(withOpaqueNavigationBar: true)
        searchBar.showsCancelButton = false
        searchBar.textField?.textColor = .white
        searchBar.textField?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
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
            } else if segue.destination is StoreViewController {
                let storeViewController = segue.destination as! StoreViewController
                let indexPath = tableView.indexPathForSelectedRow!
                let store = groupedStores[sectionNames[indexPath.section]]![indexPath.row]
                storeViewController.store = store
                viewController = storeViewController
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = backgroundImage
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
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionNames.map { name in String(name) }
    }
    
}

extension StoresViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
        searchBar.showsCancelButton = true
        searchBar.cancelButton?.setTitle("Cancelar", for: .normal)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
        searchBar.textField?.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
}

extension StoresViewController: StoreCategoriesViewControllerDelegate {
    
    func storeCategories(_ controller: StoreCategoriesViewController, didSelectCategory category: StoreCategory) {
        storeCategory = category
        initData()
    }
    
}
