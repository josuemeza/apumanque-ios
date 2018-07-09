//
//  MenuViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

// MARK: -
// MARK: - Enumerations
enum MenuViewSelection {
    case login, logout, editUser, contact, register, discounts, stores, featured, news, services
}

// MARK: -
// MARK: - Protocols
protocol MenuViewControllerDelegate {
    func menuViewController(_ controller: MenuViewController, didSelect selection: MenuViewSelection)
}

// MARK: -
// MARK: - Menu view controller
class MenuViewController: ViewController {
    
    // MARK: - Cell structs
    
    struct MenuLoginCellData {
        var name: String
        var image: UIImage?
    }
    
    struct MenuItemCellData {
        var title: String
        var item: MenuViewSelection?
    }
    
    // MARK: - Element outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - Constraint outlets
    
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Attributes
    
    private var sections = ["top", "center", "bottom"]
    private var menuItems = [
        MenuItemCellData(title: "Campaña Vigente", item: nil),
        MenuItemCellData(title: "Destacados", item: .featured),
        MenuItemCellData(title: "Locales", item: .stores),
        MenuItemCellData(title: "Noticias", item: .news),
        MenuItemCellData(title: "Servicios", item: .services),
        MenuItemCellData(title: "Contacto", item: .contact)
    ]
    var loginCellData: MenuLoginCellData?
    var delegate: MenuViewControllerDelegate?
    
    // MARK: - Actions
    
    @IBAction func closeMenuAction(_ sender: Any?) {
        hideMenu {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func logoutAction(_ sender: Any?) {
        Session.logout()
        logoutButton.isHidden = !Session.isLogged
        tableView.reloadData()
        delegate?.menuViewController(self, didSelect: .logout)
    }
    
    @IBAction func discountsSegueAction(_ sender: Any?) {
        hideMenu {
            self.dismiss(animated: false) {
                self.delegate?.menuViewController(self, didSelect: .discounts)
            }
        }
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.border(.white, width: 1)
        logoutButton.roundOut(radious: 12)
        logoutButton.isHidden = !Session.isLogged
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerLeadingConstraint.constant = -1 * UIScreen.main.bounds.width
        containerTrailingConstraint.constant = -1 * UIScreen.main.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMenu()
    }
    
    // MARK: - Methods
    
    private func showMenu() {
        containerLeadingConstraint.constant = 0
        containerTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideMenu(completion: @escaping () -> Void) {
        containerLeadingConstraint.constant = -1 * UIScreen.main.bounds.width
        containerTrailingConstraint.constant = -1 * UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }

}

// MARK: -
// MARK: - Table view data source and delegate
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return menuItems.count
        case 2: return 2
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Header section
            switch indexPath.row {
            case 0:
                if let currentUser = Session.currentUser {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "menu_logged_cell", for: indexPath) as! MenuLoggedTableViewCell
                    cell.delegate = self
                    cell.nameLabel.text = "\(currentUser.firstName ?? "") \(currentUser.lastName ?? "")"
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "menu_login_cell", for: indexPath) as! MenuLoginTableViewCell
                    cell.delegate = self
                    return cell
                }
            case 1: return tableView.dequeueReusableCell(withIdentifier: "menu_separator_cell", for: indexPath)
            default: return UITableViewCell()
            }
        case 1: // Menu section
            let cell = tableView.dequeueReusableCell(withIdentifier: "menu_item_cell", for: indexPath) as! MenuItemTableViewCell
            cell.titleLabel.text = menuItems[indexPath.row].title
            return cell
        case 2: // Footer section
            switch indexPath.row {
            case 0: return tableView.dequeueReusableCell(withIdentifier: "menu_separator_cell", for: indexPath)
            case 1: return tableView.dequeueReusableCell(withIdentifier: "menu_footer_cell", for: indexPath) as! MenuFooterTableViewCell
            default: return UITableViewCell()
            }
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: // Header section
            switch indexPath.row {
            case 0: return loginCellData == nil ? 171 : 148
            default: return UITableViewAutomaticDimension
            }
        case 2: // Menu section
            switch indexPath.row {
            case 1: return 150
            default: return UITableViewAutomaticDimension
            }
        default: return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let selection = menuItems[indexPath.row].item {
                hideMenu {
                    self.dismiss(animated: false) {
                        self.delegate?.menuViewController(self, didSelect: selection)
                    }
                }
            }
        }
    }
    
}

// MARK: -
// MARK: - Menu login cell delegate methods
extension MenuViewController: MenuLoginTableViewCellDelegate {
    
    func loginAction(on cell: MenuLoginTableViewCell, with sender: Any?) {
        hideMenu {
            self.dismiss(animated: false) {
                self.delegate?.menuViewController(self, didSelect: .login)
            }
        }
    }
    
    func signupAction(on cell: MenuLoginTableViewCell, with sender: Any?) {
        hideMenu {
            self.dismiss(animated: false) {
                self.delegate?.menuViewController(self, didSelect: .register)
            }
        }
    }
    
    func recoveryPasswordAction(on cell: MenuLoginTableViewCell, with sender: Any?) {
        let url = URL(string: "https://www.apumanque.cl/usuarios/reestablecer")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension MenuViewController: MenuLoggedTableViewCellDelegate {
    
    func editAction(on cell: MenuLoggedTableViewCell, with sender: Any?) {
        hideMenu {
            self.dismiss(animated: false) {
                self.delegate?.menuViewController(self, didSelect: .editUser)
            }
        }
    }
    
}
