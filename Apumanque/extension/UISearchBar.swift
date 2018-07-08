//
//  UISearchBar.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 08-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    var textField: UITextField? {
        get {
            return findTextField(self)
        }
    }
    
    var cancelButton: UIButton? {
        get {
            return findCancelButton(self)
        }
    }
    
    private func findTextField(_ view: UIView) -> UITextField? {
        for subview in view.subviews {
            if subview is UITextField {
                return subview as? UITextField
            } else if let result = findTextField(subview) {
                return result
            }
        }
        return nil
    }
    
    private func findCancelButton(_ view: UIView) -> UIButton? {
        for subview in view.subviews {
            if subview.isKind(of: UIButton.self), (subview as? UIButton)?.titleLabel?.text != nil {
                return subview as? UIButton
            } else if let result = findCancelButton(subview) {
                return result
            }
        }
        return nil
    }
    
}
