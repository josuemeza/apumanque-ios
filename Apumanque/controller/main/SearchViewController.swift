//
//  SearchViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 08-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class SearchViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopContraint: NSLayoutConstraint!
    
    // MARK: - Attributes
    
    private var recentSearchStores = [StoreSearch]()
    private var sectionNames = [String]()
    private var stores = [String: [Store]]()
    private var storeCategories = [StoreCategory]()
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientNavigationBar(with: UIColor.black.toImage())
        ({
            // Search bar setup
            searchBar.cancelButton?.setTitle("Cancelar", for: .normal)
            searchBar.textField?.background = UIColor.clear.toImage()
            searchBar.imageView?.backgroundColor = .clear
            searchBar.imageView?.tintColor = .clear
            searchBar.textField?.textColor = .white
            searchBar.textField?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        })()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Navigation controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BlurredViewController {
            let viewController: BlurredViewController
            if segue.destination is StoreViewController {
                let storeViewController = segue.destination as! StoreViewController
                if sender is Store {
                    storeViewController.store = sender as! Store
                } else {
                    let indexPath = tableView.indexPathForSelectedRow!
                    let store = self.stores[sectionNames[indexPath.section]]![indexPath.row]
                    if let search = searchBar.text, !search.isEmpty {
                        saveSearch(of: store)
                    }
                    storeViewController.store = store
                }
                viewController = storeViewController
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = view.takeScreenshot()
        }
    }
    
    // MARK: - Methods
    
    private func reloadData() {
        sectionNames = [String]()
        stores = [String: [Store]]()
        storeCategories = StoreCategory.all(on: managedObjectContext) ?? []
        for category in storeCategories {
            if let categoryName = category.name {
                let categoryStores = (category.stores?.allObjects as? [Store]) ?? []
                let filteredStores: [Store] = categoryStores.compactMap { store in
                    if let text = searchBar.text?.lowercased(), !text.isEmpty {
                        if store.name?.lowercased().range(of: text) != nil {
                            return store
                        }
                        return nil
                    } else {
                        return store
                    }
                }.sorted { left, right in
                    left.name ?? "" < right.name ?? ""
                }
                if !filteredStores.isEmpty {
                    stores[categoryName] = filteredStores
                    sectionNames.append(categoryName)
                }
            }
        }
        recentSearchStores = StoreSearch.all(on: managedObjectContext) ?? []
        recentSearchStores = recentSearchStores.filter { storeSearch in
            storeSearch.store(on: managedObjectContext) != nil
        }
        sectionNames = sectionNames.sorted()
        if !recentSearchStores.isEmpty {
            sectionNames.insert("", at: 0)
            tableViewTopContraint.constant = -46
        } else {
            tableViewTopContraint.constant = 0
        }
        view.layoutIfNeeded()
        tableView.reloadData()
    }
    
    private func saveSearch(of store: Store) {
        let search = StoreSearch(context: managedObjectContext)
        search.date = Date() as NSDate
        search.storeId = store.id
        search.search = searchBar.text
        try? search.save()
    }

}

// MARK: - Table view data source and delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section > 0 ? stores[sectionNames[section]]?.count ?? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !recentSearchStores.isEmpty && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recent_search_cell", for: indexPath) as! RecentSearchTableViewCell
            cell.recentSearchStores = recentSearchStores.map { recentSearch in recentSearch.store(on: managedObjectContext)! }
            cell.delegate = self
            return cell
        } else {
            guard let store = self.stores[sectionNames[indexPath.section]]?[indexPath.row] else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "store_list_table_cell", for: indexPath) as! StoreListTableViewCell
            cell.nameLabel.text = store.name
            cell.descriptionLabel.text = store.detail
            cell.storeNumberLabel.text = "Local \(store.number ?? "S/N")"
            cell.floorLabel.text = "Piso \(store.floor ?? "S/N")"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "    \(sectionNames[section])"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection: Int) {
        if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            tableViewHeaderFooterView.textLabel?.textColor = .white
        }
    }
    
}

// MARK: - Search bar delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        reloadData()
    }
    
}

extension SearchViewController: RecentSearchTableViewCellDelegate {
    
    func recentSearchTableViewCell(_ cell: RecentSearchTableViewCell, didSelectStore store: Store) {
        performSegue(withIdentifier: "search_to_store_segue", sender: store)
    }
    
}
