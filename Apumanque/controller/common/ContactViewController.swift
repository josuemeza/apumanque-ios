//
//  ContactViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class ContactViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var blurContainerView: UIVisualEffectView!
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func backAction(_ sender: Any?) {
        hide {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        blurContainerView.roundOut(radious: 10)
        backButton.imageView?.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerLeadingConstraint.constant = UIScreen.main.bounds.width
        containerTrailingConstraint.constant = UIScreen.main.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        show()
    }
    
    // MARK: - Methods
    
    private func show() {
        containerLeadingConstraint.constant = 0
        containerTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hide(completion: @escaping () -> Void) {
        containerLeadingConstraint.constant = UIScreen.main.bounds.width
        containerTrailingConstraint.constant = UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }

}
