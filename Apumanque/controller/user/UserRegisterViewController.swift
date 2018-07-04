//
//  UserRegisterViewController.swift
//  Apumanque
//
//  Created by Rinno on 18-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import Validator

protocol UserRegisterViewCellDelegate {
    func registerAction(controller: UserRegisterViewController, with sender: Any?)
}

class UserRegisterViewController: BlurredViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldRut: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var labelErrorRut: UILabel!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorPhone: UILabel!
    @IBOutlet weak var labelErrorPassword: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func buttonRegisterTap(_ sender: UIButton) {
        if validFields() {
            let user = User(context: managedObjectContext)
            user.firstName = textFieldName.text
            user.lastName = textFieldLastName.text
            user.rut = textFieldRut.text
            user.email = textFieldEmail.text
            user.phone = textFieldPhone.text
            user.password = textFieldPassword.text
            NetworkingManager.singleton.user(create: user) { user in
                if let _ = user {
                    self.alertSaveData()
                } else {
                    self.alertErrorData()
                }
            }
        }
    }
    
    @IBAction func buttonLoginTap(_ sender: UIButton) {
    }
    
    @IBAction func showPasswordSwitchAction(_ sender: UISwitch) {
        textFieldPassword.isSecureTextEntry = !sender.isOn
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        buttonLogin.layer.cornerRadius = 10
        buttonLogin.layer.borderWidth = 2
        buttonLogin.layer.borderColor = UIColor.white.cgColor
        buttonLogin.clipsToBounds = true
        buttonLogin.backgroundColor = .clear
        buttonRegister.layer.cornerRadius = 30
        buttonRegister.clipsToBounds = true
        labelErrorEmail.text = ""
        labelErrorPhone.text = ""
        labelErrorRut.text = ""
        labelErrorPassword.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Methods
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textFieldName.resignFirstResponder()
        textFieldLastName.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
        textFieldRut.resignFirstResponder()
        textFieldPhone.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            containerViewBottomConstraint.constant = (keyboardRectangle.height + 50)
            UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }

        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        containerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
    }

    func alertSaveData(){
        let optionMenu = UIAlertController(title: "Datos guardados", message: "Sus datos se han actualizado con éxito", preferredStyle: .alert)
        let logInAction = UIAlertAction(title: "Ir al Inicio", style: .destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        optionMenu.addAction(logInAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func alertErrorData(){
        let optionMenu = UIAlertController(title: "Error", message: "Error al guardar los datos", preferredStyle: .alert)
        let logInAction = UIAlertAction(title: "Ir al Inicio", style: .destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        optionMenu.addAction(logInAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

}

// MARK: -
// MARK: - Field validator
extension UserRegisterViewController {
    
    enum ValidationError: String, Error {
        case rutError = "El campo debe contener un RUT válido"
        case emailError = "El campo debe contener un email válido"
        case lengthError = "El campo no tiene el largo requerido"
        case phoneError = "El campo debe contener un teléfono válido"
        var message: String { return self.rawValue }
    }
    
    fileprivate func validFields() -> Bool {
        var valid = true
        if let textFieldRutErrors = rutValidationErrors() {
            labelErrorRut.text = textFieldRutErrors.joined(separator: ", ")
            valid = false
        } else {
            labelErrorRut.text = ""
        }
        if let textFieldEmailErrors = emailValidationErrors() {
            labelErrorEmail.text = textFieldEmailErrors.joined(separator: ", ")
            valid = false
        } else {
            labelErrorEmail.text = ""
        }
        if let textFieldPasswordErrors = passwordValidationErrors() {
            labelErrorPassword.text = textFieldPasswordErrors.joined(separator: ", ")
            valid = false
        } else {
            labelErrorPassword.text = ""
        }
        if let textFieldPhoneErrors = phoneValidationErrors() {
            labelErrorPhone.text = textFieldPhoneErrors.joined(separator: ", ")
            valid = false
        } else {
            labelErrorPhone.text = ""
        }
        return valid
    }
    
    fileprivate func rutValidationErrors() -> [String]? {
        let rutRule = ValidationRulePattern(pattern: "^0*(\\d*)\\-?([\\dkK])$", error: ValidationError.rutError)
        let result = textFieldRut.validate(rule: rutRule)
        switch result {
        case .valid: return nil
        case .invalid(let errors): return (errors as! [ValidationError]).map { error in error.message }
        }
    }
    
    fileprivate func emailValidationErrors() -> [String]? {
        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError.emailError)
        let result = textFieldEmail.validate(rule: emailRule)
        switch result {
        case .valid: return nil
        case .invalid(let errors): return (errors as! [ValidationError]).map { error in error.message }
        }
    }
    
    fileprivate func passwordValidationErrors() -> [String]? {
        let lengthRule = ValidationRuleLength(min: 4, max: 4, error: ValidationError.lengthError)
        let result = textFieldPassword.validate(rule: lengthRule)
        switch result {
        case .valid: return nil
        case .invalid(let errors): return (errors as! [ValidationError]).map { error in error.message }
        }
    }
    
    fileprivate func phoneValidationErrors() -> [String]? {
        let phoneRule = ValidationRulePattern(pattern: "+?\\d{6,15}", error: ValidationError.phoneError)
        let result = textFieldPhone.validate(rule: phoneRule)
        switch result {
        case .valid: return nil
        case .invalid(let errors): return (errors as! [ValidationError]).map { error in error.message }
        }
    }
    
}
