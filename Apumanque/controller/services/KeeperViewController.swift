//
//  KeeperViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 06-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class KeeperViewController: UIViewController {

    @IBOutlet weak var keeperLabel: UILabel!
    @IBOutlet weak var howgetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        howgetButton.layer.cornerRadius = 28
        
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
