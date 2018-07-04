//
//  ViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 15-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import CoreData

// MARK: -
// MARK: - View controller
class ViewController: UIViewController {
    
    // MARK: - Attributes
    
    let Session = SessionManager.singleton
    
    public var navigationBarHeight : CGFloat{
        get{
            if self.navigationController != nil && !self.navigationController!.navigationBar.isTranslucent{
                return 0
            } else {
                let barHeight = self.navigationController?.navigationBar.frame.height ?? 0
                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                return barHeight + statusBarHeight
            }
        }
    }
    
    // MARK: - Attributes

    var managedObjectContext: NSManagedObjectContext {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        NetworkingManager.singleton.context = managedObjectContext
        setGradientNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Methods
    
    func setGradientNavigationBar() {
        let backgroundImage = UIImage(named: "navigation_background")?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setNavigationItem() {
        let title = navigationItem.title
        navigationItem.title = nil
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        navigationItem.titleView = label
        
//        let button = UIButton(type: .custom)
//        button.setImage(UIImage (named: "logo"), for: .normal)
//        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
//        //button.addTarget(target, action: nil, for: .touchUpInside)
//        let barButtonItem = UIBarButtonItem(customView: button)
//        
//        self.navigationItem.rightBarButtonItems = [barButtonItem]
        
        
        
    }

}

