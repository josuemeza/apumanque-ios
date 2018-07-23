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
    
    // MARK: - Attributes
    
    var searchResultViewController: SearchResultViewController!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        searchResultViewController.reloadData()
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
                storeViewController.store = sender as! Store
                viewController = storeViewController
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = view.takeScreenshot()
        } else if segue.destination is SearchResultViewController {
            let viewController = segue.destination as! SearchResultViewController
            viewController.managedObjectContext = managedObjectContext
            viewController.delegate = self
            searchResultViewController = viewController
        }
    }

}

extension SearchViewController: SearchResultViewControllerDelegate {
    
    func searchResultViewController(_ controller: SearchResultViewController, didSelectSearchStore store: Store) {
        performSegue(withIdentifier: "search_to_store_segue", sender: store)
    }
    
    func searchResultViewController(_ controller: SearchResultViewController, didSelectRecentSearchStore store: Store) {
        performSegue(withIdentifier: "search_to_store_segue", sender: store)
    }
    
}

// MARK: - Search bar delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultViewController.resultFiltered(by: searchText.lowercased())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchResultViewController.resultFiltered(by: "")
    }
    
}
