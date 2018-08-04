//
//  FeaturedTableViewCell.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 09-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class FeaturedTableViewCell: UITableViewCell {
    
    // MARK: - Attributes
    
    private var initiatedGradient: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView! {
        didSet {
            if !initiatedGradient {
                _ = gradientView.gradient(colours: [.clear, .black], position: 0.8)
                initiatedGradient = true
            }
        }
    }
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueLabelContainer: UIView!

}
