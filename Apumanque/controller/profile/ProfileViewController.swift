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
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "logo"), for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        
        
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
        }
    }
    
}
