//
//  AnswerViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 19-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SwiftSoup

class AnswerViewController: ViewController {

    var help: Help!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionLabel.text = htmlString(text: help.question!)
        answerLabel.text = htmlString(text: help.answer!)
        
    }
    
    func htmlString(text: String) -> String{
        do {
            let doc: Document = try SwiftSoup.parse(text)
            return try doc.text()
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        return ""
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
