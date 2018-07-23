//
//  HelpViewCommonController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 18-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class HelpViewCommonController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Attributes
    
    var helpArray: [Help]!
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
        helpArray = Help.all(on: managedObjectContext)
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "logo"), for: .normal)
        
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultViewController.reloadData()
    }

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
        } else if segue.destination is AnswerViewController {
            let helpViewController = segue.destination as! AnswerViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let help = helpArray[indexPath.row]
            helpViewController.help = help
        } else if segue.destination is SearchResultViewController {
            let viewController = segue.destination as! SearchResultViewController
            viewController.managedObjectContext = managedObjectContext
            viewController.delegate = self
            searchResultViewController = viewController
        }
    }
    
}

extension HelpViewCommonController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HelpCommonTableViewCell
        let data = helpArray[indexPath.row]
        cell.numbreLabel.text = String(data.order)
        cell.contentLabel.text = data.question
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

// MARK: - Search result delegate
extension HelpViewCommonController: SearchResultViewControllerDelegate {
    
    func searchResultViewController(_ controller: SearchResultViewController, didSelectSearchStore store: Store) {
        performSegue(withIdentifier: "help_to_store_segue", sender: store)
    }
    
    func searchResultViewController(_ controller: SearchResultViewController, didSelectRecentSearchStore store: Store) {
        performSegue(withIdentifier: "help_to_store_segue", sender: store)
    }
    
}

// MARK: - Search bar delegate
extension HelpViewCommonController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !searchBar.showsCancelButton {
            searchBar.showsCancelButton = true
            searchBar.cancelButton?.setTitle("Cancelar", for: .normal)
        }
        searchResultView.isHidden = false
        view.bringSubview(toFront: searchResultView)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultViewController.resultFiltered(by: searchText.lowercased())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchResultView.isHidden = true
        view.sendSubview(toBack: searchBar)
//        view.bringSubview(toFront: tableView)
        searchResultViewController.resultFiltered(by: "")
    }
    
}
