//
//  UploadInvoiceViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 10-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class UploadInvoiceViewController: ViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var saveAndContinueButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var imageViewUploadInvoice: UIImageView!
    @IBOutlet weak var textFieldNameStore: UITextField!
    @IBOutlet weak var textFieldBuyDate: UITextField!
    @IBOutlet weak var textFieldAmountPurchase: UITextField!
    @IBOutlet weak var textFieldNumberInvoice: UITextField!
    
    private var campaings: Campaing!
    
    
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
        
    }

//    @objc func openHelp(){
//        self.performSegue(withIdentifier: "campaings_to_help_segue", sender: nil)
//    }
    
    @IBAction func helpButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "campaings_to_help_segue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAndContinueButtonTap(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
