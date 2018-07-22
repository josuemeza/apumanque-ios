//
//  MyDiscountTableViewCell.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 08-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

protocol MyDiscountTableViewCellDelegate {
    func myDiscountTableViewCell(_ cell: MyDiscountTableViewCell, didSelectSegueFor store: Store?)
}

class MyDiscountTableViewCell: UITableViewCell {
    
    // MARK: - Attributes
    
    var store: Store?
    var delegate: MyDiscountTableViewCellDelegate?
    
    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func storeAction(_ sender: Any) {
        delegate?.myDiscountTableViewCell(self, didSelectSegueFor: store)
    }
    
}
