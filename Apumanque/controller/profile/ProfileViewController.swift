//
//  ProfileViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 11-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ProfileViewController: UIViewController {

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
//        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
//        navigationItem.backBarButtonItem = backButton
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "logo"), for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
