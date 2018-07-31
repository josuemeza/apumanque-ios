//
//  ProfileViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 11-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ProfileViewController: ViewController {
    
    @IBOutlet weak var menuViewProfile: UIView!
    @IBOutlet weak var circularProgress: UICircularProgressRingView!
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var typeProfile: UILabel!
    @IBOutlet weak var couponCampaign: UILabel!
    @IBOutlet weak var levelProfile: UILabel!
    @IBOutlet weak var multiplicatorProfile: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet var backgroundColorView: UIView!
    
    var isLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        menuViewProfile.roundOut(radious: 10)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Session.isLogged{
            NetworkingManager.singleton.getUserScores { data in
                if let json = data {
                    print(json)
                    self.nameProfile.text = "\(self.Session.currentUser!.firstName!) \(self.Session.currentUser!.lastName!)"
                    self.typeProfile.text = "Ciudadano \(json.nameType!)"
                    self.couponCampaign.text = String(json.ticketsCampaign)
                    self.levelProfile.text = "Nivel actual: Nivel \(json.level)"
                    if Double(json.multiplicator!)! > 1.0 {
                        self.multiplicatorProfile.text = "Recibes \(json.multiplicator!) cupones por cada $10.000.- de compras"
                    } else{
                        self.multiplicatorProfile.text = "Recibes \(json.multiplicator!) cupon por cada $10.000.- de compras"
                    }
                    self.circularProgress.value = CGFloat(json.percentage)
                    self.backgroundColorView.backgroundColor = self.hexStringToUIColor(hex: json.bgcolorcode!)
                    self.blurBackground.isHidden = true
                }
            }
        } else {
            self.blurBackground.isHidden = false
            if isLogin {
                tabBarController?.selectedIndex = 0
                isLogin = false
            } else {
                performSegue(withIdentifier: "profile_to_login_segue", sender: nil)
                isLogin = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ACtions
    
    @IBAction func myInvoicesAction(_ sender: Any) {
        
    }
    
    @IBAction func campaignAction(_ sender: Any) {
    }
    
    @IBAction func lastWinnersAction(_ sender: Any) {
        
    }
    
    @IBAction func helpAction(_ sender: Any) {
        
    }
    
    @IBAction func editUserAction(_ sender: Any) {
        self.performSegue(withIdentifier: "profile_to_edit_user_segue", sender: nil)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MenuViewController {
            let viewController = segue.destination as! MenuViewController
            viewController.delegate = self
        } else if segue.identifier == "profile_to_winner_segue" {
            let destination = segue.destination as! NewsViewController
            destination.isContestDefault = true
        }
    }
    
    
}

// MARK: -
// MARK: - Menu view controller delegate
extension ProfileViewController: MenuViewControllerDelegate {
    
    func menuViewController(_ controller: MenuViewController, didSelect selection: MenuViewSelection) {
        switch selection {
        case .login:
            performSegue(withIdentifier: "profile_to_login_segue", sender: nil)
        case .logout: ()
        case .editUser:
            performSegue(withIdentifier: "profile_to_edit_user_segue", sender: nil)
        case .contact:
            performSegue(withIdentifier: "profile_to_contact_segue", sender: nil)
        case .register:
            performSegue(withIdentifier: "profile_to_register_segue", sender: nil)
        case .discounts:
            tabBarController?.selectedIndex = 1
        case .featured:
            performSegue(withIdentifier: "profile_to_featured_segue", sender: nil)
        case .services:
            performSegue(withIdentifier: "profile_to_services_segue", sender: nil)
        case .stores:
            performSegue(withIdentifier: "profile_to_stores_segue", sender: nil)
        case .news:
            performSegue(withIdentifier: "profile_to_news_segue", sender: nil)
        case .campaign:
            performSegue(withIdentifier: "profile_to_valid_campaign_segue", sender: nil)
        case .invoices:
            tabBarController?.selectedIndex = 2
        case .help:
            performSegue(withIdentifier: "profile_to_help_segue", sender: nil)
        }
    }
    
}

// MARK: -
// MARK: - Methods Background Color
extension ProfileViewController {
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
