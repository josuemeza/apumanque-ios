//
//  MenuFooterTableViewCell.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class MenuFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var voucherButton: UIButton!
    @IBOutlet weak var discountsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        voucherButton.centerVertically(padding: 13)
        discountsButton.centerVertically(padding: 8)
        helpButton.centerVertically(padding: 3)
    }

}
