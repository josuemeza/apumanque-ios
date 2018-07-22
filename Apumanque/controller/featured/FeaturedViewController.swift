//
//  FeaturedViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 18-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class FeaturedViewController: BlurredViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Attributes
    
    private var discounts = [Discount]()
    private var storeCategory: StoreCategory?
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        build(withOpaqueNavigationBar: true)
        initDiscountList()
    }
    
    // MARK: - Navigation view controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BlurredViewController {
            let viewController: BlurredViewController
            if segue.destination is StoreCategoriesViewController {
                let storeCategories = segue.destination as! StoreCategoriesViewController
                storeCategories.delegate = self
                viewController = storeCategories
            } else if segue.destination is FeaturedSingleViewController {
                let featuredSingle = segue.destination as! FeaturedSingleViewController
                featuredSingle.featured = discounts[tableView.indexPathForSelectedRow?.row ?? 0]
                viewController = featuredSingle
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = view.takeScreenshot()
        }
    }
    
    // MARK: - Methods
    
    func initDiscountList() {
        if let storeCategory = storeCategory {
            let stores: [Store] = storeCategory.stores?.allObjects as? [Store] ?? []
            let collection: [[Discount]] = stores.map { store in
                let discounts = store.discounts?.allObjects as? [Discount] ?? []
                return discounts.filter { discount in discount.active && discount.featured }
            }
            discounts = collection.reduce([], +)
        } else {
            discounts = Discount.all(featured: true, on: managedObjectContext) ?? []
        }
        discounts.sort { left, right in
            if let leftDate = left.startDate?.toDate as Date?, let rightDate = right.startDate?.toDate as Date? {
                return leftDate > rightDate
            }
            return false
        }
        tableView.reloadData()
    }

}

// MARK: -
// MARK: - Table view data source and delegate
extension FeaturedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featured_list_item_cell", for: indexPath) as! FeaturedTableViewCell
        let discount = discounts[indexPath.row]
        cell.titleLabel.text = discount.resume ?? discount.title
        if let url = discount.imageUrl {
            cell.backgroundImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        }
        cell.storeNameLabel.text = discount.store?.name
        let value = Int(discount.valuePercent!)?.formattedWithSeparator
        cell.valueLabel.text = value != nil ? "$\(value!)" : "S/V"
        cell.valueLabelContainer.backgroundColor = discount.valueColor?.color ?? .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let _ = storeCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featured_list_category_cell") as! DiscountCategoryTableViewCell
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
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

// MARK: -
// MARK: - Store category delegate methods
extension FeaturedViewController: StoreCategoriesViewControllerDelegate {
    
    func storeCategories(_ controller: StoreCategoriesViewController, didSelectCategory category: StoreCategory) {
        storeCategory = category
        initDiscountList()
        tableView.reloadData()
    }
    
}

// MARK: -
// MARK: - Discount category cell delegate
extension FeaturedViewController: DiscountCategoryTableViewCellDelegate {
    
    func removeCategoryAction(from cell: DiscountCategoryTableViewCell) {
        storeCategory = nil
        initDiscountList()
        tableView.reloadData()
    }
    
}
