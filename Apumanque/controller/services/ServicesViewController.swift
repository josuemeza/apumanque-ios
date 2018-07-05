//
//  ServicesViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 05-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController {

    @IBOutlet weak var keeperView: UIView!
    @IBOutlet weak var bikeView: UIView!
    @IBOutlet weak var wheelchairView: UIView!
    @IBOutlet weak var babycarriageView: UIView!
    @IBOutlet weak var parkingView: UIView!
    
    var servicesOptions: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        /*self.keeperView.roundOut(radious: 10)
         bikeView.roundOut(radious: 10)
         wheelchairView.roundOut(radious: 10)
         babycarriageView.roundOut(radious: 10)
         parkingView.roundOut(radious: 10)*/
        
        
    }

    @IBAction func keeperButtonTap(_ sender: Any) {
        servicesOptions = 1
        self.performSegue(withIdentifier: "services_show_segue", sender: nil)
        print("services \(self.servicesOptions)")
    }
    
    @IBAction func bikeButtonTap(_ sender: Any) {
        servicesOptions = 2
        self.performSegue(withIdentifier: "services_show_segue", sender: self)
    }
    
    @IBAction func wheelchairButtonTap(_ sender: Any) {
        servicesOptions = 3
        self.performSegue(withIdentifier: "services_show_segue", sender: self)
    }
    
    @IBAction func babycarriageButtonTap(_ sender: Any) {
        servicesOptions = 4
        self.performSegue(withIdentifier: "services_show_segue", sender: self)
    }
    
    @IBAction func parkingButtonTap(_ sender: Any) {
        servicesOptions = 5
        self.performSegue(withIdentifier: "services_show_segue", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        print("services \(self.servicesOptions)")
        if segue.identifier == "services_show_segue"{
            var vc = segue.destination as! ServicesMainViewController
            vc.op = opciones
            //Data has to be a variable name in your RandomViewController
        }
        
    }

}
