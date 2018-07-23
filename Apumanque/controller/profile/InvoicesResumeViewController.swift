//
//  InvoicesResumeViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 23-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class InvoicesResumeViewController: ViewController {

    @IBOutlet weak var invoiceCampaignCount: UILabel!
    @IBOutlet weak var totalAmountPointCampaign: UILabel!
    @IBOutlet weak var totalPointsCampaign: UILabel!
    @IBOutlet weak var levelUser: UILabel!
    @IBOutlet weak var totalCoupons: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var totalInvoices: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    
    var userScores: UserScores!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userScores = UserScores.unitUserScores(on: managedObjectContext)
        
        invoiceCampaignCount.text = String(userScores.ticketsCampaign)
        totalAmountPointCampaign.text = String(userScores.userScoreCampaign)
        levelUser.text = userScores.nameType
        if Double(userScores.multiplicator!)! > 1.0 {
            totalCoupons.text = "\(userScores.multiplicator!) cupones"
        } else{
            totalCoupons.text = "\(userScores.multiplicator!) cupon"
        }
        totalAmount.text = String(userScores.userScore)
        totalInvoices.text = String(userScores.tickets)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
