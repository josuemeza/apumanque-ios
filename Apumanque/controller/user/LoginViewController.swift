//
//  LoginViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import Validator

class LoginViewController: BlurredViewController {
    
    // MARK: - Element outlets
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSubmitButton: UIButton!
    
    // MARK: - Constraint outlets
    
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func submitAction(_ sender: Any?) {
//        if validFields() {
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            User.all(on: managedObjectContext)?.forEach { user in managedObjectContext.delete(user) }
            Session.login(username: email, password: password) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.alertErrorLogin()
                }
            }
//        }
    }
    
    @IBAction func showPasswordSwitchAction(_ sender: UISwitch) {
        passwordTextField.isSecureTextEntry = !sender.isOn
    }
    
    @IBAction func registerAction(_ sender: Any?) {
        
        //let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "register_view_controller")
        //viewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        //self.present(viewController, animated: false, completion: nil)
        
    }
    
    @IBAction func recoverPasswordAction(_ sender: Any?) {
        let url = URL(string: "https://www.apumanque.cl/usuarios/reestablecer")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        loginSubmitButton.roundOut(radious: 26)
    }
    
    // MARK: - Methods
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func alertErrorLogin(){
        let optionMenu = UIAlertController(title: "Error", message: "Login incorrecto", preferredStyle: .alert)
        let logInAction = UIAlertAction(title: "Ir al Inicio", style: .destructive, handler: nil)
        optionMenu.addAction(logInAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}

// MARK: -
// MARK: - Field validator
extension LoginViewController {
    
    enum ValidationError: String, Error {
        case requiredError = "El Campo requerido"
        case emailError = "El campo debe ser un email"
        case lengthError = "El campo no tiene el largo requerido"
        var message: String { return self.rawValue }
    }
    
    fileprivate func validFields() -> Bool {
        var valid = true
        if let textFieldEmailErrors = emailValidationErrors() {
            print(textFieldEmailErrors)
            valid = false
        }
        if let textFieldPasswordErrors = passwordValidationErrors() {
            print(textFieldPasswordErrors)
            valid = false
        }
        return valid
    }
    
    fileprivate func emailValidationErrors() -> [String]? {
        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError.emailError)
        let result = emailTextField.validate(rule: emailRule)
        switch result {
        case .valid: return nil
        case .invalid(let errors): return (errors as! [ValidationError]).map { error in error.message }
        }
    }
    
    fileprivate func passwordValidationErrors() -> [String]? {
        let lengthRule = ValidationRuleLength(min: 4, max: 4, error: ValidationError.lengthError)
        let result = passwordTextField.validate(rule: lengthRule)
        switch result {
        case .valid: return nil
        case .invalid(let errors): return (errors as! [ValidationError]).map { error in error.message }
        }
    }
    
}
