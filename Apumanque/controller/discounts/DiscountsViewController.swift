//
//  DiscountsViewController.swift
//  Apumanque
//
//  Created by Rinno on 20-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SDWebImage

class DiscountsViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listSegmentedControl: UISegmentedControl!
    @IBOutlet weak var listSegmentedControlToTitleContratin: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Attributes
    
    private var tableToTitleConstraint = [Bool: CGFloat]()
    private var defaultSegmentedControlTopConstraintValue: CGFloat!
    private(set) var storeCategory: StoreCategory?
    private(set) var discounts: [Discount]!
    var isSegmentedControlHidden: Bool {
        get {
            return listSegmentedControl.isHidden
        }
        set(hidden) {
            listSegmentedControl.isHidden = hidden
            tableViewTopConstraint.constant = tableToTitleConstraint[hidden] ?? 10
        }
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        initDiscountList()
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableToTitleConstraint[false] = tableViewTopConstraint.constant
        tableToTitleConstraint[true] = listSegmentedControlToTitleContratin.constant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDiscountList()
        isSegmentedControlHidden = !Session.isLogged
    }

    // MARK: - Navigation view controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MenuViewController {
            let viewController = segue.destination as! MenuViewController
            viewController.delegate = self
        }
        if segue.destination is BlurredViewController {
            let viewController: BlurredViewController
            if segue.destination is StoreCategoriesViewController {
                let storeCategories = segue.destination as! StoreCategoriesViewController
                storeCategories.delegate = self
                viewController = storeCategories
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = view.takeScreenshot()
        }
        if segue.destination is DiscountViewController {
            let viewController = segue.destination as! DiscountViewController
            viewController.discount = discounts[tableView.indexPathForSelectedRow?.row ?? 0]
        }
    }
    
    // MARK: - Methods
    
    func sortDiscounts() {
        discounts.sort { left, right in
            if let leftDate = left.startDate?.toDate as Date?, let rightDate = right.startDate?.toDate as Date? {
                return leftDate < rightDate
            }
            return false
        }
    }
    
    func initDiscountList() {
        if let storeCategory = storeCategory {
            let stores: [Store] = storeCategory.stores?.allObjects as? [Store] ?? []
            discounts = stores.map { store in
                let discounts = store.discounts?.allObjects as? [Discount] ?? []
                return discounts.filter { discount in discount.active }
                }.reduce([], +) as! [Discount]
        } else {
            discounts = Discount.all(on: managedObjectContext) ?? []
        }
        if let user = Session.currentUser, listSegmentedControl.selectedSegmentIndex == 1 {
            discounts = discounts.filter { discount in
                ((discount.users?.allObjects as? [User])?.index(of: user) ?? -1) >= 0
            }
        }
        sortDiscounts()
        tableView.reloadData()
    }

}

// MARK: -
// MARK: - Table view data source and delegate methods
extension DiscountsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discount_list_item_cell", for: indexPath) as! DiscountTableViewCell
        let discount = discounts[indexPath.row]
        cell.titleLabel.text = discount.resume ?? discount.title
        if let url = discount.imageUrl {
            cell.backgroundImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        }
        cell.valueLabelContainer.radious(34, on: [.bottomLeft, .topLeft])
        if let value = discount.valuePercent, !value.isEmpty {
            cell.valueLabel.text = value
            switch value.lowercased() {
            case "Dcto":
                cell.valueLabelContainer.backgroundColor = UIColor(red: 30/255, green: 155/255, blue: 132/255, alpha: 1)
            case "LE":
                cell.valueLabelContainer.backgroundColor = UIColor(red: 244/255, green: 85/255, blue: 22/255, alpha: 1)
            default:
                cell.valueLabelContainer.backgroundColor = UIColor(red: 232/255, green: 0/255, blue: 58/255, alpha: 1)
            }
        } else {
            cell.valueLabel.text = ""
            cell.valueLabelContainer.backgroundColor = .clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let _ = storeCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "discount_list_category_cell") as! DiscountCategoryTableViewCell
            cell.categoryLabel.text = storeCategory?.name
            cell.delegate = self
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return storeCategory != nil ? 44 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

// MARK: -
// MARK: - Discount category table view cell methods
extension DiscountsViewController: DiscountCategoryTableViewCellDelegate {
    
    func removeCategoryAction(from cell: DiscountCategoryTableViewCell) {
        storeCategory = nil
        initDiscountList()
        tableView.reloadData()
    }
    
}

// MARK: -
// MARK: - Store category delegate methods
extension DiscountsViewController: StoreCategoriesViewControllerDelegate {
    
    func storeCategories(_ controller: StoreCategoriesViewController, didSelectCategory category: StoreCategory) {
        storeCategory = category
        let stores: [Store] = storeCategory?.stores?.allObjects as? [Store] ?? []
        discounts = stores.map { store in
            let discounts = store.discounts?.allObjects as? [Discount] ?? []
            return discounts.filter { discount in discount.active }
        }.reduce([], +) as! [Discount]
        sortDiscounts()
        tableView.reloadData()
    }
    
}

// MARK: -
// MARK: - Menu view controller delegate
extension DiscountsViewController: MenuViewControllerDelegate {
    
    func menuViewController(_ controller: MenuViewController, didSelect selection: MenuViewSelection) {
        switch selection {
        case .login:
            performSegue(withIdentifier: "discounts_to_login_segue", sender: nil)
        case .logout:
            initDiscountList()
            isSegmentedControlHidden = !Session.isLogged
        case .editUser:
            performSegue(withIdentifier: "discounts_to_edit_segue", sender: nil)
        case .contact:
            performSegue(withIdentifier: "discounts_to_contact_segue", sender: nil)
        case .register:
            performSegue(withIdentifier: "discounts_to_register_segue", sender: nil)
        case .discounts:
            tabBarController?.selectedIndex = 1
        case .featured:
            ()
        case .services:
            performSegue(withIdentifier: "home_to_services_segue", sender: nil)
        }
    }
    
}
