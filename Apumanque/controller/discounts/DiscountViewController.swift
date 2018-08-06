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
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var resumeLabel: UILabel!
    
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
                
                let alert = UIAlertController(title: "Para obtener tu cupón de descuento debes registrar tu RUT", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                let finish = UIAlertAction(title: "Salir sin obtener cupón", style: .default, handler: { action in
                    
                })
                let uploadOther = UIAlertAction(title: "Registrar RUT", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "discounts_to_edit_segue", sender: nil)
                })
                
                finish.setValue(UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
                uploadOther.setValue(UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
                alert.addAction(uploadOther)
                alert.addAction(finish)
                
                self.present(alert, animated: true, completion: nil)
                
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
        conditionsLabel.text = discount.conditions
        resumeLabel.text = discount.detail
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is BlurredViewController {
            let viewController: BlurredViewController
            if segue.destination is DiscountViewController {
                guard let indexPath = storeDiscountsCollectionView.indexPathsForSelectedItems?.first else { return }
                let storeDiscountsController = segue.destination as! DiscountViewController
                storeDiscountsController.discount = storeDiscounts[indexPath.row]
                viewController = storeDiscountsController
            } else if segue.destination is StoreViewController {
                let storeController = segue.destination as! StoreViewController
                storeController.store = discount.store!
                viewController = storeController
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = backgroundImage
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
