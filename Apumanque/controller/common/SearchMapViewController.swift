//
//  SearchMapViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 03-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class SearchMapViewController: ViewController {

    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        boxView.roundOut(radious: 8.0)
        searchView.roundOut(radious: 8.0)
        
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
