//
//  CouponViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 22-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class CouponViewController: ViewController {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var viewMenuName: UIView!
    @IBOutlet weak var titleDiscount: UILabel!
    @IBOutlet weak var codeDiscount: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRut: UILabel!
    @IBOutlet weak var imageDiscount: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeLocation: UILabel!
    @IBOutlet weak var dateDiscount: UILabel!
    
    var discount: Discount!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        borderColor()
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "logo"), for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    func borderColor(){
        
        self.borderView.layer.cornerRadius = 8
        self.borderView.layer.borderWidth = 1
        self.borderView.layer.borderColor = UIColor.white.cgColor
        self.viewMenuName.layer.cornerRadius = 14
        self.titleDiscount.text = discount.title
        self.codeDiscount.text = discount.code
        self.userName.text = Session.currentUser?.firstName
//        self.userRut.text = Session.currentUser?.rut
        imageDiscount.sd_setImage(with: URL(string: discount.imageUrl!), placeholderImage: UIImage(named: "placeholder-image"))
        imageDiscount.roundOut(radious: 30)
        self.storeName.text = discount.store?.name
        self.storeLocation.text = "Local \(discount.store!.number!) - Piso \(discount.store!.floor!)"
        print("DESCUENTO \(discount.id!)")
        sendDiscount(id_special_sale: discount.id!)
    }
    
    func sendDiscount(id_special_sale: String){
        NetworkingManager.singleton.sendDiscount(id_special_sale: id_special_sale, completion: { data in
            if let json = data {
                print("PASO EL DESCUENTO")
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
