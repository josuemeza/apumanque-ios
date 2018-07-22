//
//  DiscountViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 31-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SDWebImage

class DiscountViewController: BlurredViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var storeDiscountsCollectionView: UICollectionView!
    @IBOutlet weak var discountBackgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var documentExpandButtonIconImageView: UIImageView!
    @IBOutlet weak var documentDetailContainerView: UIView!
    @IBOutlet weak var documentDetailSeparatorView: UIView!
    
    private var user: User!
    
    // MARK: - Attributes
    
    var discount: Discount!
    var storeDiscounts: [Discount]!
    
    // MAKR: - Attribute accessor
    
    var documentDetailViewIsHidden: Bool = true {
        didSet {
            documentExpandButtonIconImageView.image = UIImage(named: "arrow-\(documentDetailViewIsHidden ? "down" : "up")")
            documentDetailContainerView.isHidden = documentDetailViewIsHidden
            documentDetailSeparatorView.isHidden = documentDetailViewIsHidden
        }
    }
    
    // MARK: - Actions
    
    @IBAction func getDiscountAction(_ sender: Any) {
        
        if Session.isLogged{
            if Session.currentUser?.rut == nil {
                print("ES NULO")
                let alert = UIAlertController(title: "Para obtener tu cupón de descuento debes registrar tu RUT", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
                alert.addAction(UIAlertAction(title: "Cerrar sesión", style: .destructive, handler: { action in
                    
                }))
                
                self.present(alert, animated: true)
            } else {
             performSegue(withIdentifier: "discount_to_coupon_segue", sender: nil)
            }
        } else {
            performSegue(withIdentifier: "discount_to_login_segue", sender: nil)
        }
        
        
        
    }
    @IBAction func detailExpandAction(_ sender: Any) {
        documentDetailViewIsHidden = !documentDetailViewIsHidden
    }
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        build(withOpaqueNavigationBar: true)
        documentDetailViewIsHidden = true
        discountBackgroundImageView.sd_setImage(with: URL(string: discount.imageUrl!), placeholderImage: UIImage(named: "placeholder-image"))
        titleLabel.text = discount.title
        valueLabel.text = discount.valueText
        valueLabel.backgroundColor = discount.valueColor?.color ?? .clear
        expireDateLabel.text = (discount.expireDate as Date?)?.string(format: "dd/MM/yy")
        storeNameLabel.text = discount.store?.name
//        storePhoneLabel.text = discount.store?.phone
        storeDiscounts = discount.store?.discounts?.allObjects as? [Discount] ?? []
        storeDiscounts.remove(discount)
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
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
