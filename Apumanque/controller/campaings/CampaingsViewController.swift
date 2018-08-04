//
//  CampaingsViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 10-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class CampaingsViewController: ViewController {
    
    @IBOutlet weak var seeCampaingsView: UIView!
    @IBOutlet weak var uploadInvoiceBUtton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.seeCampaingsView.roundOut(radious: 10)
        self.uploadInvoiceBUtton.roundOut(radious: 10)
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "logo"), for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func uploadInvoiceButtonTap(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    
    
    @IBAction func seeCampaingsButtonTap(_ sender: Any) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is MenuViewController {
//            let viewController = segue.destination as! MenuViewController
//            viewController.delegate = self
//        }
    }


}


