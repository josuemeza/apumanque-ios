//
//  DiscountCategoryTableViewCell.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 30-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

protocol DiscountCategoryTableViewCellDelegate {
    func removeCategoryAction(from cell: DiscountCategoryTableViewCell)
}

class DiscountCategoryTableViewCell: UITableViewCell {
    
    // MARK: - Attributes

    var delegate: DiscountCategoryTableViewCellDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func removeCategoryAction(_ sender: Any?) {
        delegate?.removeCategoryAction(from: self)
    }

}
