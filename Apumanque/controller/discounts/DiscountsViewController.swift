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
    private(set) var storeForSegue: Store?
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
            } else if segue.destination is StoreViewController {
                let storeViewController = segue.destination as! StoreViewController
                storeViewController.store = storeForSegue
                viewController = storeViewController
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
            if listSegmentedControl.selectedSegmentIndex == 0 {
                if let leftDate = left.startDate?.toDate, let rightDate = right.startDate?.toDate {
                    return leftDate > rightDate
                }
            } else {
                if let leftDate = left.createdAt?.toDate, let rightDate = right.createdAt?.toDate {
                    return leftDate > rightDate
                }
            }
            return false
        }
    }
    
    func initDiscountList() {
        discounts = []
        if let storeCategory = storeCategory {
            let stores: [Store] = storeCategory.stores?.allObjects as? [Store] ?? []
            let collection: [[Discount]] = stores.map { store in
                let discounts = store.discounts?.allObjects as? [Discount] ?? []
                return discounts.filter { discount in discount.active && !discount.featured }
            }
            discounts = collection.reduce([], +)
        } else {
            discounts = Discount.all(featured: false, on: managedObjectContext) ?? []
        }
        if listSegmentedControl.selectedSegmentIndex == 1, Session.isLogged {
            discounts = discounts.filter { discount in discount.user?.id == Session.currentUser!.id! }
        } else {
            discounts = discounts.filter { discount in discount.user == nil }
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
        switch listSegmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "discount_list_item_cell", for: indexPath) as! DiscountTableViewCell
            let discount = discounts[indexPath.row]
            cell.titleLabel.text = discount.resume ?? discount.title
            if let url = discount.imageUrl {
                cell.backgroundImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
            }
            cell.valueLabelContainer.radious(34, on: [.bottomLeft, .topLeft])
            cell.valueLabel.text = discount.valueText
            cell.valueLabelContainer.backgroundColor = discount.valueColor?.color ?? .clear
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "my_discount_list_item_cell", for: indexPath) as! MyDiscountTableViewCell
            let discount = discounts[indexPath.row]
            let expireDays: Int? = ({
                guard let expireDate = discount.expireDate?.toDate else { return nil }
                let now = Date()
                let calendar = Calendar.current
                let start = calendar.startOfDay(for: now)
                let end = calendar.startOfDay(for: expireDate)
                let components = calendar.dateComponents([.day], from: start, to: end)
                return components.day
            })()
            let expireMessage: String = ({
                if let expireDays = expireDays {
                    if expireDays >= 0 {
                        return "Quedan \(expireDays) días para canjear"
                    } else {
                        return "Cupón fuera de fecha"
                    }
                } else {
                    return "Fecha pendiente de ingreso"
                }
            })()
            cell.titleLabel.text = discount.resume ?? discount.title
            cell.storeLabel.text = discount.store?.name
            cell.expirationLabel.text = expireMessage
            cell.store = discount.store
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
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
        switch listSegmentedControl.selectedSegmentIndex {
        case 0:
            return 200
        default:
            return UITableViewAutomaticDimension
        }
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
// MARK: - My discount table view cell delegate
extension DiscountsViewController: MyDiscountTableViewCellDelegate {
    
    func myDiscountTableViewCell(_ cell: MyDiscountTableViewCell, didSelectSegueFor store: Store?) {
        storeForSegue = store
        performSegue(withIdentifier: "discounts_to_store_segue", sender: nil)
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
            performSegue(withIdentifier: "home_to_featured_segue", sender: nil)
        case .services:
            performSegue(withIdentifier: "home_to_services_segue", sender: nil)
        case .stores:
            performSegue(withIdentifier: "home_to_stores_segue", sender: nil)
        case .news:
            performSegue(withIdentifier: "discounts_to_news_segue", sender: nil)
        case .campaign:
            performSegue(withIdentifier: "discounts_to_valid_campaign_segue", sender: nil)
        case .invoices:
            tabBarController?.selectedIndex = 2
        case .help:
            performSegue(withIdentifier: "discounts_to_help_segue", sender: nil)
        }
    }
    
}
