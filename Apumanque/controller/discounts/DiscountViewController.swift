//
//  DiscountViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 31-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SDWebImage

class DiscountViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var storeDiscountsCollectionView: UICollectionView!
    @IBOutlet weak var discountBackgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storePhoneLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Attributes
    
    var discount: Discount!
    var storeDiscounts: [Discount]!
    
    // MARK: - Actions
    
    @IBAction func getDiscountAction(_ sender: Any) {
        // TODO: implements
    }
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        discountBackgroundImageView.sd_setImage(with: URL(string: discount.imageUrl!), placeholderImage: UIImage(named: "placeholder-image"))
        titleLabel.text = discount.title
        valueLabel.text = discount.valuePercent
        expireDateLabel.text = (discount.expireDate as Date?)?.string(format: "dd/MM/yy")
        storeNameLabel.text = discount.store?.name
        storePhoneLabel.text = discount.store?.phone
        storeDiscounts = discount.store?.discounts?.allObjects as? [Discount] ?? []
        storeDiscounts.remove(discount)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DiscountViewController {
            guard let indexPath = storeDiscountsCollectionView.indexPathsForSelectedItems?.first else { return }
            let viewController = segue.destination as! DiscountViewController
            viewController.discount = storeDiscounts[indexPath.row]
        }
    }

}

extension DiscountViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeDiscounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DiscountOfStoreCollectionViewCell
        let discount = storeDiscounts[indexPath.row]
        if let url = discount.imageUrl {
            cell.backgroundImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        }
        cell.titleLabel.text = discount.title
        cell.valueLabel.text = discount.valuePercent
        return cell
    }
    
}
