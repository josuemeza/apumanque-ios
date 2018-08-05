//
//  UploadInvoiceViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 10-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import Photos
import JGProgressHUD

class UploadInvoiceViewController: ViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var saveAndContinueButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var imageViewUploadInvoice: UIImageView!
    @IBOutlet weak var textFieldNameStore: UITextField!
    @IBOutlet weak var textFieldBuyDate: UITextField!
    @IBOutlet weak var textFieldAmountPurchase: UITextField!
    @IBOutlet weak var textFieldNumberInvoice: UITextField!
    @IBOutlet weak var nameStoreView: UIView!
    @IBOutlet weak var buyDateView: UIView!
    @IBOutlet weak var amountPurchaseView: UIView!
    @IBOutlet weak var numberInvoiceView: UIView!
    @IBOutlet weak var getDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var dateConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var imageInvoiceCampaign: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private var campaings: Campaing!
    private(set) var stores = [Store]()
    var autoComplete = [String]()
    var autoCompletePosibilities = [String]()
    var autoCompletePosibilitiesTMP = [Store]()
    var photoFromCamera = false
    var imageSelectedOrChosen = false
    var isPhotoOriginal = false
    var currentString = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stores = Store.all(on: managedObjectContext) ?? []
        
        autoCompletePosibilitiesTMP = stores
        autoCompletePosibilitiesTMP = autoCompletePosibilitiesTMP.filter{$0.floor  != "0"}
        
        autoCompletePosibilities = autoCompletePosibilitiesTMP.map{$0.name!}
        
        print("TIENDA \(stores[0].name)")
        textFieldAmountPurchase.delegate = self
        textFieldNumberInvoice.delegate = self
        textFieldNameStore.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.cornerRadius = 5
        
        campaings = Campaing.unitCampaing(on: managedObjectContext)
        if let url = campaings.imageUrl {
            imageViewUploadInvoice.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        }
        
        contentView.roundOut(radious: 10)
        saveAndContinueButton.roundOut(radious: 28)
        
        print("CAMPANIAS \(Session.currentUser?.rut)")
        
        //        let view = UIView()
        //        let button = UIButton(type: .system)
        //        button.semanticContentAttribute = .forceRightToLeft
        //        button.setImage(UIImage(named: "right-icon-white"), for: .normal)
        //        button.setTitle("Ayuda", for: .normal)
        //        button.addTarget(self, action: #selector(openHelp), for: .touchUpInside)
        //        button.sizeToFit()
        //        view.addSubview(button)
        //        view.frame = button.bounds
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
        
        helpButton.layer.cornerRadius = 12
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.white.cgColor
        helpButton.clipsToBounds = true
        helpButton.backgroundColor = .clear
        
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        nameStoreView.roundOut(radious: 10)
        buyDateView.roundOut(radious: 10)
        amountPurchaseView.roundOut(radious: 10)
        numberInvoiceView.roundOut(radious: 10)
        dateView.roundOut(radious: 10)
        
        dateConstraint.constant = 36
        datePicker.isHidden = true
        getDateButton.isHidden = true
        dateView.isHidden = true
        
        //MARK: TapGesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(UploadInvoiceViewController.tapFunction))
        textFieldBuyDate.isUserInteractionEnabled = true
        textFieldBuyDate.addGestureRecognizer(tap)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(UploadInvoiceViewController.choseOrTakePhotoTapped))
        imageInvoiceCampaign.addGestureRecognizer(tapImage)
        imageInvoiceCampaign.isUserInteractionEnabled = true
        
        let tapKeyboard = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tapKeyboard.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapKeyboard)
        
    }
    
    
    
    /*
     override func viewDidAppear(_ animated: Bool) {
     if Session.isLogged{
     if Session.currentUser?.rut == nil {
     
     let alert = UIAlertController(title: "Para participar en la promoción, debes registrar tu RUT", message: nil, preferredStyle: UIAlertControllerStyle.alert)
     let finish = UIAlertAction(title: "Salir sin resgistrar RUT", style: .default, handler: { action in
     self.tabBarController?.selectedIndex = 0
     })
     let uploadOther = UIAlertAction(title: "Registrar RUT", style: .default, handler: { action in
     //                    self.performSegue(withIdentifier: "campaings_to_edit_user_segue", sender: nil)
     })
     
     finish.setValue(UIColor(red:255.00, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
     uploadOther.setValue(UIColor(red:255.00, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
     alert.addAction(uploadOther)
     alert.addAction(finish)
     
     self.present(alert, animated: true, completion: nil)
     
     } else {
     //                performSegue(withIdentifier: "discount_to_coupon_segue", sender: nil)
     }
     } else {
     performSegue(withIdentifier: "campaings_to_login_segue", sender: nil)
     }
     }
     */
    
    //MARK: Button Action
    
    @IBAction func helpButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "campaings_to_help_segue", sender: nil)
    }
    
    @IBAction func saveAndContinueButtonTap(_ sender: Any) {
        
        guard let img = imageInvoiceCampaign.image else {
            let hud = JGProgressHUD(style: .dark)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Imagen no Valida"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            return
        }
    
        guard imageSelectedOrChosen else {
            let hud = JGProgressHUD(style: .dark)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Imagen no Valida"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        guard isPhotoOriginal else {
            let hud = JGProgressHUD(style: .dark)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Imagen no Valida"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        if textFieldAmountPurchase.text == "" && textFieldAmountPurchase.text == "$" && textFieldAmountPurchase.text == "$0" {
            let hud = JGProgressHUD(style: .dark)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Ingrese Monto Valido"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        guard let amount = textFieldAmountPurchase.text else {
            let hud = JGProgressHUD(style: .dark)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Ingrese Monto Valido"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        guard let digits = textFieldNumberInvoice.text, digits.count == 4 else {
            let hud = JGProgressHUD(style: .dark)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Ingrese Últimos 4 digitos boleta correctamente"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
    }
    
    @IBAction func getDateButtonTap(_ sender: Any) {
        datePicker.isHidden = true
        dateView.isHidden = true
        dateConstraint.constant = 36
        getDateButton.isHidden = true
        blurView.isHidden = false
        textFieldBuyDate.isHidden = false
        adjustTextFieldDate()
    }
    
    //MARK: - Methods
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        datePicker.isHidden = false
        dateView.isHidden = false
        dateConstraint.constant = 256
        getDateButton.isHidden = false
        blurView.isHidden = true
        textFieldBuyDate.isHidden = true
    }
    
    func adjustTextFieldDate() {
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_CL")
        dateFormatter.dateFormat = "dd-MMMM-YYYY"
        let strDate = dateFormatter.string(from: date)
        textFieldBuyDate.text = strDate
    }
    
    @objc
    func choseOrTakePhotoTapped() {
        
        //        last4Digits.resignFirstResponder()
        //        amountTextField.resignFirstResponder()
        let alertController = UIAlertController(title: "Elige de dónde obtener la foto de tu boleta", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Sacar foto con la cámara", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.takePhoto()
        })
        cameraAction.setValue(UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
        
        let galeryAction = UIAlertAction(title: "Obtener de la Galería", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.chosePhoto()
        })
        galeryAction.setValue(UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(red:0.85, green:0.00, blue:0.00, alpha:1.0), forKey: "titleTextColor")
        alertController.addAction(cameraAction)
        alertController.addAction(galeryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func takePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.allowsEditing = false
        photoFromCamera = true
        present(picker, animated: true)
    }
    
    func chosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        photoFromCamera = false
        present(picker, animated: true)
    }
    
    //Format text amount
    func formatCurrency(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "es_CL") as Locale!
        formatter.maximumFractionDigits = 0;
        let numberFromField = (NSString(string: currentString).doubleValue)
        textFieldAmountPurchase.text = formatter.string(from: numberFromField as NSNumber);
    }
    
    func searchAutocompleteEntriesWith(substring: String) {
        autoComplete.removeAll(keepingCapacity: false)
        
        for key in autoCompletePosibilities {
            
            let myString: NSString! = key.lowercased() as NSString
            let substringRange: NSRange! = myString.range(of: substring.lowercased())
            if substringRange.location == 0 {
                autoComplete.append(key)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MenuViewController {
            let viewController = segue.destination as! MenuViewController
            viewController.delegate = self
        }
    }
    
    
}

// MARK: -
// MARK: - Menu view controller delegate
extension UploadInvoiceViewController: MenuViewControllerDelegate {
    
    func menuViewController(_ controller: MenuViewController, didSelect selection: MenuViewSelection) {
        switch selection {
        case .login:
            performSegue(withIdentifier: "campaings_to_login_segue", sender: nil)
        case .logout: ()
        case .editUser:
            performSegue(withIdentifier: "campaings_to_edit_user_segue", sender: nil)
        case .contact:
            performSegue(withIdentifier: "campaings_to_contact_segue", sender: nil)
        case .register:
            performSegue(withIdentifier: "campaings_to_register_segue", sender: nil)
        case .discounts:
            tabBarController?.selectedIndex = 1
        case .featured:
            performSegue(withIdentifier: "campaings_to_featured_segue", sender: nil)
        case .services:
            performSegue(withIdentifier: "campaings_to_services_segue", sender: nil)
        case .stores:
            performSegue(withIdentifier: "campaings_to_stores_segue", sender: nil)
        case .news:
            performSegue(withIdentifier: "campaings_to_news_segue", sender: nil)
        case .campaign:
            performSegue(withIdentifier: "campaings_to_valid_campaign_segue", sender: nil)
        case .invoices:
            tabBarController?.selectedIndex = 2
        case .help:
            performSegue(withIdentifier: "campaings_to_help_segue", sender: nil)
        }
    }
    
}

//MARK: - UIImagePickerDelegate Methods
extension UploadInvoiceViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //self.invoiceImageButton.imageView?.image = img
            self.imageInvoiceCampaign.image = img
            self.imageInvoiceCampaign.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 126)
        }
        if photoFromCamera {
            imageSelectedOrChosen = true
            isPhotoOriginal = true
        } else {
            let assetURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL as URL], options: nil)
            if let result = asset.firstObject {
                let imageManager = PHImageManager.default()
                imageManager.requestImageData(for: result , options: nil, resultHandler:{
                    (data, responseString, imageOriet, info) -> Void in
                    let imageData: NSData = data! as NSData
                    if let imageSource = CGImageSourceCreateWithData(imageData, nil), let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? NSDictionary, let tiff = imageProperties["{TIFF}"] as? NSDictionary, let make = tiff["Make"] as? String {
                        if make == "Apple" {
                            self.imageSelectedOrChosen = true
                            self.isPhotoOriginal = true
                            //                            guard let storeName = self.storeNameTextField.text, !storeName.isEmpty, let amount = self.amountTextField.text, !amount.isEmpty, let digits = self.last4Digits.text, !digits.isEmpty, digits.characters.count == 4, self.imageSelectedOrChosen else {
                            //                                self.sendButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
                            //                                self.sendButton.isEnabled = false
                            //                                return
                            //                            }
                            //                            self.sendButton.setTitleColor(.white, for: UIControlState.normal)
                            //                            self.sendButton.isEnabled = true
                        }
                    }
                })
            }
        }
        dismiss(animated: true)
    }
}

//MARK: TextFieldDelegate Methods
extension UploadInvoiceViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.restorationIdentifier == "amount" {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                currentString += string
                formatCurrency(string: currentString)
            default:
                let array = string
                var currentStringArray = currentString
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    currentString = ""
                    for character in currentStringArray {
                        currentString += String(character)
                    }
                    formatCurrency(string: currentString)
                }
            }
//            textFieldDidChange()
            return false
            
        }
        
        if textField.restorationIdentifier == "storeName" {
            let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string.lowercased())
            searchAutocompleteEntriesWith(substring: substring.lowercased())
            if string.count > 0 {
                tableView.isHidden = false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.restorationIdentifier == "amount" {
            if let number = textFieldAmountPurchase.text {
                if number != "" && number != "$" && number != "$0" {
                    textFieldAmountPurchase.clearButtonMode = .never
                    textFieldAmountPurchase.rightViewMode = .never
                } else {
                    textFieldAmountPurchase.clearButtonMode = .always
                    textFieldAmountPurchase.rightViewMode = .always
                    textFieldAmountPurchase.textColor = .red
                }
            } else {
                textFieldAmountPurchase.clearButtonMode = .always
                textFieldAmountPurchase.rightViewMode = .always
                textFieldAmountPurchase.textColor = .red
            }
            textFieldAmountPurchase.resignFirstResponder()
        }
        
        if textField.restorationIdentifier == "fourDigits" {
            if let digits = textFieldNumberInvoice.text {
                if digits != "" && digits.count == 4  {
                    textFieldNumberInvoice.clearButtonMode = .never
                    textFieldNumberInvoice.rightViewMode = .never
                } else {
                    textFieldNumberInvoice.clearButtonMode = .always
                    textFieldNumberInvoice.rightViewMode = .always
                    textFieldNumberInvoice.textColor = .red
                }
            } else {
                textFieldNumberInvoice.clearButtonMode = .always
                textFieldNumberInvoice.rightViewMode = .always
                textFieldNumberInvoice.textColor = .red
            }
            textFieldNumberInvoice.resignFirstResponder()
        }
    }
    
    
    
}

//MARK: - UITableView methods
extension UploadInvoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if autoComplete.count > 4 {
            let h = 44 * 4
            heightConstraint.constant = CGFloat(h)
            return 4
        } else {
            let h = 44 * autoComplete.count
            heightConstraint.constant = CGFloat(h)
            return autoComplete.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel!.text = autoComplete[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        textFieldNameStore.text = selectedCell.textLabel!.text!
        tableView.isHidden = true
        view.endEditing(true)
    }
    
    
}
