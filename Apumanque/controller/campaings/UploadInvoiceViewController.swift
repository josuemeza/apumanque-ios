//
//  UploadInvoiceViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 10-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class UploadInvoiceViewController: ViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var saveAndContinueButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var imageViewUploadInvoice: UIImageView!
    @IBOutlet weak var textFieldNameStore: UITextField!
    @IBOutlet weak var textFieldBuyDate: UITextField!
    @IBOutlet weak var textFieldAmountPurchase: UITextField!
    @IBOutlet weak var textFieldNumberInvoice: UITextField!
    
    private var campaings: Campaing!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        campaings = Campaing.unitCampaing(on: managedObjectContext)
        if let url = campaings.imageUrl {
            imageViewUploadInvoice.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        }

        contentView.roundOut(radious: 10)
        saveAndContinueButton.roundOut(radious: 28)
        
        print("CAMPANIAS \(Session.currentUser?.rut)")
        
//        let view = UIView()
//        let button = UIButton(type: .system)
//        button.semanticContentAttribute = .forceRightToLeft
//        button.setImage(UIImage(named: "right-icon-white"), for: .normal)
//        button.setTitle("Ayuda", for: .normal)
//        button.addTarget(self, action: #selector(openHelp), for: .touchUpInside)
//        button.sizeToFit()
//        view.addSubview(button)
//        view.frame = button.bounds
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
        
        helpButton.layer.cornerRadius = 12
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.white.cgColor
        helpButton.clipsToBounds = true
        helpButton.backgroundColor = .clear
        
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if Session.isLogged{
            if Session.currentUser?.rut == nil {
                
                let alert = UIAlertController(title: "Para participar en la promoción, debes registrar tu RUT", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                let finish = UIAlertAction(title: "Salir sin resgistrar RUT", style: .default, handler: { action in
                    self.tabBarController?.selectedIndex = 0
                })
                let uploadOther = UIAlertAction(title: "Registrar RUT", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "campaings_to_edit_user_segue", sender: nil)
                })
                
                finish.setValue(UIColor(red:255.00, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
                uploadOther.setValue(UIColor(red:255.00, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
                alert.addAction(uploadOther)
                alert.addAction(finish)
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                //                performSegue(withIdentifier: "discount_to_coupon_segue", sender: nil)
            }
        } else {
                        performSegue(withIdentifier: "campaings_to_login_segue", sender: nil)
        }
    }
    
    
    @IBAction func helpButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "campaings_to_help_segue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAndContinueButtonTap(_ sender: Any) {
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MenuViewController {
            let viewController = segue.destination as! MenuViewController
            viewController.delegate = self
        }
    }
    

}

// MARK: -
// MARK: - Menu view controller delegate
extension UploadInvoiceViewController: MenuViewControllerDelegate {
    
    func menuViewController(_ controller: MenuViewController, didSelect selection: MenuViewSelection) {
        switch selection {
        case .login:
            performSegue(withIdentifier: "campaings_to_login_segue", sender: nil)
        case .logout: ()
        case .editUser:
            performSegue(withIdentifier: "campaings_to_edit_user_segue", sender: nil)
        case .contact:
            performSegue(withIdentifier: "campaings_to_contact_segue", sender: nil)
        case .register:
            performSegue(withIdentifier: "campaings_to_register_segue", sender: nil)
        case .discounts:
            tabBarController?.selectedIndex = 1
        case .featured:
            performSegue(withIdentifier: "campaings_to_featured_segue", sender: nil)
        case .services:
            performSegue(withIdentifier: "campaings_to_services_segue", sender: nil)
        case .stores:
            performSegue(withIdentifier: "campaings_to_stores_segue", sender: nil)
        case .news:
            performSegue(withIdentifier: "campaings_to_news_segue", sender: nil)
        case .campaign:
            performSegue(withIdentifier: "campaings_to_valid_campaign_segue", sender: nil)
        case .invoices:
            tabBarController?.selectedIndex = 2
        case .help:
            performSegue(withIdentifier: "campaings_to_help_segue", sender: nil)
        }
    }
    
}
