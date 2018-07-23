//
//  HelpViewCommonController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 18-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class HelpViewCommonController: ViewController {
    
    var helpArray: [Help]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpArray = Help.all(on: managedObjectContext)
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "logo"), for: .normal)
        
        let backButton = UIBarButtonItem(title: "Volver", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AnswerViewController {
            let helpViewController = segue.destination as! AnswerViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let help = helpArray[indexPath.row]
            helpViewController.help = help
        }
    }
    
}

extension HelpViewCommonController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HelpCommonTableViewCell
        let data = helpArray[indexPath.row]
        cell.numbreLabel.text = String(data.order)
        cell.contentLabel.text = data.question
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
