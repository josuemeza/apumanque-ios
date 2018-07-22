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
