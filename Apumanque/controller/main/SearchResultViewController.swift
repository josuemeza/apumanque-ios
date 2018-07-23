//
//  SearchResultViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 22-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import CoreData

protocol SearchResultViewControllerDelegate {
    
    func searchResultViewController(_ controller: SearchResultViewController, reloadTableWithFilter filter: String)
    func searchResultViewController(_ controller: SearchResultViewController, didSelectSearchStore store: Store)
    func searchResultViewController(_ controller: SearchResultViewController, didSelectRecentSearchStore store: Store)
}

class SearchResultViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Attributes
    
    fileprivate var searchFilter: String = ""
    var managedObjectContext: NSManagedObjectContext!
    var delegate: SearchResultViewControllerDelegate?
    var storeCategories = [StoreCategory]()
    var sectionNames = [String]()
    var stores = [String: [Store]]()
    var recentSearchStores = [StoreSearch]()
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        reloadData()
    }
    
    // MARK: - Methods
    
    func resultFiltered(by filter: String) {
        searchFilter = filter
        reloadData()
    }
    
    func reloadData() {
        sectionNames = [String]()
        stores = [String: [Store]]()
        storeCategories = StoreCategory.all(on: managedObjectContext) ?? []
        for category in storeCategories {
            if let categoryName = category.name {
                let categoryStores = (category.stores?.allObjects as? [Store]) ?? []
                let filteredStores: [Store] = categoryStores.compactMap { store in
                    if !searchFilter.isEmpty {
                        if store.name?.lowercased().range(of: searchFilter) != nil {
                            return store
                        } else if store.number?.range(of: searchFilter) != nil {
                            return store
                        } else if let tags = store.tags {
                            for tag in tags.components(separatedBy: ",") {
                                if tag.lowercased().range(of: searchFilter) != nil {
                                    return store
                                }
                            }
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
        }
        tableView.reloadData()
        delegate?.searchResultViewController(self, reloadTableWithFilter: searchFilter)
    }
    
    private func saveSearch(of store: Store) {
        let search = StoreSearch(context: managedObjectContext)
        search.date = Date() as NSDate
        search.storeId = store.id
        search.search = searchFilter
    }

}

extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            cell.collectionView.reloadData()
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
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let store = stores[sectionNames[indexPath.section]]![indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        saveSearch(of: store)
        delegate?.searchResultViewController(self, didSelectSearchStore: store)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection: Int) {
        if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            tableViewHeaderFooterView.textLabel?.textColor = .white
        }
    }
    
}

extension SearchResultViewController: RecentSearchTableViewCellDelegate {
    
    func recentSearchTableViewCell(_ cell: RecentSearchTableViewCell, didSelectStore store: Store) {
        delegate?.searchResultViewController(self, didSelectRecentSearchStore: store)
    }
    
}
