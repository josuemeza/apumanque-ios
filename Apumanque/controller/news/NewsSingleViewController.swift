//
//  NewsSingleViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class NewsSingleViewController: BlurredViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var galleryHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Attributes
    
    var images = [UIImage]()
    
    // MARK: - Actions
    
    @IBAction func legalBasesButtonAction(_ sender: Any) {
        
    }
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        build()
        // TODO: Remove example
        let names = ["home_table_cell_1", "home_table_cell_2", "home_table_cell_3", "home_table_cell_4"]
        images = names.compactMap { name in UIImage(named: name) }
    }
    
    // MARK: - Navigation controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewsSinglePageViewController {
            if images.isEmpty {
                galleryHeightConstraint.constant = 0
            } else {
                let viewController = segue.destination as! NewsSinglePageViewController
                viewController.images = images
            }
        }
    }

}
