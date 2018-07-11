//
//  DialogRutViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 10-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class DialogRutViewController: ViewController {

    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuView.roundOut(radious: 10.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerRutAction(_ sender: Any) {
    }
    
    @IBAction func exitDialogAction(_ sender: Any) {
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
