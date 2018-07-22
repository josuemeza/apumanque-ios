//
//  EditProfileViewController.swift
//  Apumanque
//
//  Created by Rinno on 19-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import Validator

class EditProfileViewController: BlurredViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelRut: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldBirthdate: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldRegion: UITextField!
    @IBOutlet weak var textFieldComuna: UITextField!
    @IBOutlet weak var buttonUpdateData: UIButton!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorPhone: UILabel!
    @IBOutlet weak var labelErrorAddress: UILabel!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func buttonUpdateDataTap(_ sender: Any) {
        if validFields() {
            let user = Session.currentUser!
            user.email = textFieldEmail.text
            user.phone = textFieldPhone.text
            user.address = textFieldAddress.text
            user.region = textFieldRegion.text
            user.commune = textFieldComuna.text
            if let date = textFieldBirthdate.text {
                user.birthday = Date.parse(stringDate: date, format: "dd-MM-yyyy")! as NSDate
            }
            NetworkingManager.singleton.user(edit: user) { user in
                if let _ = user {
                    self.alertSaveData()
                } else {
                    self.alertErrorData()
                }
            }
        }
    }
    
    @IBAction func textFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build()
        initUserData()
        buttonUpdateData.layer.cornerRadius = 30
        buttonUpdateData.clipsToBounds = true
        labelErrorEmail.text = ""
        labelErrorPhone.text = ""
        labelErrorAddress.text = ""
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
    
    func initUserData() {
        if let user = Session.currentUser {
            labelName.text = user.firstName
            labelLastName.text = user.lastName
            labelRut.text = user.rut
            textFieldEmail.text = user.email
            textFieldPhone.text = user.phone
            textFieldBirthdate.text = (user.birthday as Date?)?.string(format: "dd-MM-yyyy")
            textFieldAddress.text = user.address
            textFieldRegion.text = user.region
        }
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        textFieldBirthdate.text = dateFormatter.string(from: sender.date)
        
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
extension EditProfileViewController {
    
    enum ValidationError: String, Error {
        case emailError = "El campo debe contener un email"
        case phoneError = "El campo debe contener un teléfono válido"
        var message: String { return self.rawValue }
    }
    
    fileprivate func validFields() -> Bool {
        var valid = true
        if let textFieldEmailErrors = emailValidationErrors() {
            labelErrorEmail.text = textFieldEmailErrors.joined(separator: ", ")
            valid = false
        } else {
            labelErrorEmail.text = ""
        }
        if let textFieldPhoneErrors = phoneValidationErrors() {
            labelErrorPhone.text = textFieldPhoneErrors.joined(separator: ", ")
            valid = false
        } else {
            labelErrorPhone.text = ""
        }
        return valid
    }
    
    fileprivate func emailValidationErrors() -> [String]? {
        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError.emailError)
        let result = textFieldEmail.validate(rule: emailRule)
        switch result {
        case .valid: return nil
        case .invalid(let errors): return (errors as! [ValidationError]).map { error in error.message }
        }
    }
    
    fileprivate func phoneValidationErrors() -> [String]? {
        let phoneRule = ValidationRulePattern(pattern: "\\+?\\d{6,15}", error: ValidationError.phoneError)
        let result = textFieldPhone.validate(rule: phoneRule)
        switch result {
        case .valid: return nil
        case .invalid(let errors): return (errors as! [ValidationError]).map { error in error.message }
        }
    }
    
}
