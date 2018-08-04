//
//  ValidCampaingsViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 07-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SwiftSoup

class ValidCampaingsViewController: ViewController {

    @IBOutlet weak var lastWinnersButton: UIButton!
    @IBOutlet weak var legalAspects: UIButton!
    @IBOutlet weak var tittleCampaingsLabel: UILabel!
    @IBOutlet weak var contentCampaingsLabel: UILabel!
    @IBOutlet weak var imageCampaings: UIImageView!
    
    private var campaings: Campaing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        campaings = Campaing.unitCampaing(on: managedObjectContext)
        lastWinnersButton.roundOut(radious: 28.0)
        legalAspects.roundOut(radious: 28.0)
        tittleCampaingsLabel.text = campaings.title
        if let url = campaings.imageUrl {
            imageCampaings.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        }
        contentCampaingsLabel.text = campaings.contentCampaign?.parsedOnDocument
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        
    }
    
    @IBAction func lastWinnersAction(_ sender: Any) {
    }
    
    @IBAction func legalAspectsAction(_ sender: Any) {
    }
    
    // MARK: - Methods
    private func setup() {
        
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "campaign_to_winner_segue" {
            let destination = segue.destination as! NewsViewController
            destination.isContestDefault = true
        }
    }

}
