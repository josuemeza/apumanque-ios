//
//  FeaturedSingleViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 21-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SDWebImage

class FeaturedSingleViewController: BlurredViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var storeFeaturedCollectionView: UICollectionView!
    @IBOutlet weak var featuredMainImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productValueLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    
    // MARK: - Attributes
    
    var featured: Discount!
    fileprivate var storeFeatured = [Discount]()
    
    // MARK: - Actions
    
    @IBAction func getDiscountAction(_ sender: Any) {
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build()
        featuredMainImageView.sd_setImage(with: URL(string: featured.imageUrl!), placeholderImage: UIImage(named: "placeholder-image"))
        productNameLabel.text = featured.title
        let value = Int(featured.valuePercent!)?.formattedWithSeparator
        productValueLabel.text = value != nil ? "$\(value!)" : "S/V"
        storeNameLabel.text = featured.store?.name
        storeAddressLabel.text = "Local \(featured.store?.number ?? "S/N") - Piso \(featured.store?.floor ?? "S/N")"
        var array = featured.store?.discounts?.allObjects as? [Discount] ?? []
        array = array.compactMap { featured in featured.featured ? featured : nil }
        array.remove(featured)
        storeFeatured = array
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BlurredViewController {
            let viewController: BlurredViewController
            if segue.destination is StoreViewController {
                let storeViewController = segue.destination as! StoreViewController
                storeViewController.store = featured.store!
                viewController = storeViewController
            } else if segue.destination is FeaturedSingleViewController {
                guard let indexPath = storeFeaturedCollectionView.indexPathsForSelectedItems?.first else { return }
                let featured = segue.destination as! FeaturedSingleViewController
                featured.featured = storeFeatured[indexPath.row]
                viewController = featured
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = backgroundImage
        }
    }

}

extension FeaturedSingleViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeFeatured.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoreFeaturedCollectionViewCell
        let featured = storeFeatured[indexPath.row]
        cell.backgroundImageView.sd_setImage(with: URL(string: featured.imageUrl!), placeholderImage: UIImage(named: "placeholder-image"))
        cell.storeNameLabel.text = featured.store?.name
        cell.productNameLabel.text = featured.title
        let value = Int(featured.valuePercent!)?.formattedWithSeparator
        cell.productValueLabel.text = value != nil ? "$\(value!)" : "S/V"
        return cell
    }
    
}
