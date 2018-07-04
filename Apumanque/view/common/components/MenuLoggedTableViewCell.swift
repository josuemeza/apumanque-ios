//
//  MenuLoggedTableViewCell.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

protocol MenuLoggedTableViewCellDelegate {
    func editAction(on cell: MenuLoggedTableViewCell, with sender: Any?)
}

class MenuLoggedTableViewCell: UITableViewCell {
    
    // MARK: - Attributes
    
    var delegate: MenuLoggedTableViewCellDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func editAction(_ sender: Any?) {
        delegate?.editAction(on: self, with: sender)
    }
    
    // MARK: - Table view cell methods

    override func awakeFromNib() {
        super.awakeFromNib()
        editButton.roundOut(radious: 10)
    }

}
