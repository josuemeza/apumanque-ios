//
//  MenuLoginTableViewCell.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

protocol MenuLoginTableViewCellDelegate {
    func loginAction(on cell: MenuLoginTableViewCell, with sender: Any?)
    func signupAction(on cell: MenuLoginTableViewCell, with sender: Any?)
    func recoveryPasswordAction(on cell: MenuLoginTableViewCell, with sender: Any?)
}

class MenuLoginTableViewCell: UITableViewCell {
    
    // MARK: - Attributes
    
    var delegate: MenuLoginTableViewCellDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func loginAction(_ sender: Any?) {
        delegate?.loginAction(on: self, with: sender)
    }
    
    @IBAction func signupAction(_ sender: Any?) {
        delegate?.signupAction(on: self, with: sender)
    }
    
    @IBAction func recoverPasswordAction(_ sender: Any?) {
        delegate?.recoveryPasswordAction(on: self, with: sender)
    }
    
    // MARK: - Table view cell methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loginButton.roundOut(radious: 15)
    }

}
