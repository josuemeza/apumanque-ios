//
//  UploadInvoiceViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 10-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import Photos

class UploadInvoiceViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    private var campaings: Campaing!
    var photoFromCamera = false
    var imageSelectedOrChosen = false
    var isPhotoOriginal = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

//MARK: - UIIMAGE
extension UploadInvoiceViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //self.invoiceImageButton.imageView?.image = img
            self.imageInvoiceCampaign.image = img
            self.imageInvoiceCampaign.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 126)
        }
        if photoFromCamera {
            print("Mago: Its Original! Taken")
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
                            print("Mago: Is Original! Chosen")
                            self.imageSelectedOrChosen = true
                            self.isPhotoOriginal = true
                            print("Mago")
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
