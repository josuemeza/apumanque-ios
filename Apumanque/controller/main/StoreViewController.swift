//
//  StoreViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 29-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SDWebImage

class StoreViewController: BlurredViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var discountsCollectionView: UICollectionView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var titleDiscountLabel: UILabel!
    @IBOutlet weak var discountsCollectionConstraint: NSLayoutConstraint!
    
    // MARK: - Attributes
    
    private var discounts: [Discount]!
    var store: Store!
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        build()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // Init data
        nameLabel.text = store.name
        let categories = store.categories?.allObjects as? [StoreCategory] ?? []
        categoryLabel.text = categories.map { category in category.name ?? "S/N" }.joined(separator: ", ")
        addressLabel.text = "Local \(store.number ?? "S/N") - Piso \(store.floor ?? "S/N")"
        phoneLabel.text = store.phone
        debugPrint("aqui en la tienda \(store.image) ")
        webLabel.text = store.web
        emailLabel.text = store.email
        tagsLabel.text = store.tags
        discounts = store.discounts?.allObjects as? [Discount] ?? []
        logoImageView.sd_setImage(with: URL(string: store.image!), placeholderImage: UIImage(named: "placeholder-image"))
        
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        print("DISCOUNT STORES \(discounts.count)")
        if (discounts.count == 0){
            discountsCollectionConstraint.constant = 0.0
            titleDiscountLabel.isHidden = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DiscountViewController {
            guard let indexPath = discountsCollectionView.indexPathsForSelectedItems?.first else { return }
            let viewController = segue.destination as! DiscountViewController
            viewController.discount = discounts[indexPath.row]
        }
    }

}

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discounts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoreSingleDiscountCollectionViewCell
        let discount = discounts[indexPath.row]
        if let imageUrl = discount.imageUrl {
            cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder-image"))
        }
        cell.productNameLabel.text = discount.title
        cell.storeNumberLabel.text = "Local \(store.number ?? "S/N")"
        cell.storeNameLabel.text = store.name
        cell.valueLabel.text = discount.valueText
        cell.valueLabel.backgroundColor = discount.valueColor?.color ?? .clear
        return cell
    }
    
}
