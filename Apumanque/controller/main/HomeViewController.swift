//
//  HomeViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 15-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SwiftSoup

// MARK: -
// MARK: - Home view controller
class HomeViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchFieldContainer: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Attributes
    
    var homeCategories = [HomeCategory]()
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCategories = ApplicationManager.singleton.homeCategories
        searchFieldContainer.roundOut(radious: 8)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
//        view.addGestureRecognizer(tapGesture)
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "logo"), for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        
        if UserDefaults.standard.bool(forKey: "hasViewedTutorial") {
            //ProgressHUD.show("Descargando último contenido", interaction: false)
            return
        }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "TutorialController") as? TutorialPageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Navigation view controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MenuViewController {
            let viewController = segue.destination as! MenuViewController
            viewController.delegate = self
        } else if segue.destination is BlurredViewController {
            let viewController = segue.destination as! BlurredViewController
            viewController.backgroundImage = view.takeScreenshot()
        }
    }
    
    // MARK: - Methods
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
}

// MARK: -
// MARK: - Table view data source and delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home_menu_item_cell", for: indexPath) as! HomeMenuItemTableViewCell
        let data = homeCategories[indexPath.row]
        cell.titleLabel.text = data.title
        cell.subtitleLabel.text = data.subtitle?.parsedOnDocument
        cell.backgrounImageView.image = UIImage(data: data.background! as Data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Locales")
            performSegue(withIdentifier: "home_to_stores_segue", sender: nil)
        case 1:
            print("Cliente frecuente")
        case 2:
            print("Descuentos")
            tabBarController?.selectedIndex = 1
        case 3:
            print("Destacados")
            performSegue(withIdentifier: "home_to_featured_segue", sender: nil)
        case 4:
            print("Noticias")
            performSegue(withIdentifier: "home_to_news_segue", sender: nil)
        case 5:
            print("Servicios")
            performSegue(withIdentifier: "home_to_services_segue", sender: nil)
        default:
            print("default")
        }
    }
    
}

// MARK: -
// MARK: - Tab bar data source and delegate
extension HomeViewController: UITabBarControllerDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }
    
}

// MARK: -
// MARK: - Menu view controller delegate
extension HomeViewController: MenuViewControllerDelegate {
    
    func menuViewController(_ controller: MenuViewController, didSelect selection: MenuViewSelection) {
        switch selection {
        case .login:
            performSegue(withIdentifier: "home_to_login_segue", sender: nil)
        case .logout: ()
        case .editUser:
            performSegue(withIdentifier: "home_to_edit_user_segue", sender: nil)
        case .contact:
            performSegue(withIdentifier: "home_to_contact_segue", sender: nil)
        case .register:
            performSegue(withIdentifier: "home_to_resgister_segue", sender: nil)
        case .discounts:
            tabBarController?.selectedIndex = 1
        case .featured:
            performSegue(withIdentifier: "home_to_featured_segue", sender: nil)
            return
        case .services:
            performSegue(withIdentifier: "home_to_services_segue", sender: nil)
        case .stores:
            performSegue(withIdentifier: "home_to_stores_segue", sender: nil)
        case .news:
            performSegue(withIdentifier: "home_to_news_segue", sender: nil)
        case .campaign:
            performSegue(withIdentifier: "home_to_valid_campaign_segue", sender: nil)
        case .invoices:
            tabBarController?.selectedIndex = 2
        }
    }
    
}

