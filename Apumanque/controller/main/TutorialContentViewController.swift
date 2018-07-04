//
//  TutorialContentViewController.swift
//  Apumanque
//
//  Created by Rinno on 18-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class TutorialContentViewController: ViewController {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var pageControler: UIPageControl!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControler.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        contentImageView.image = UIImage(named: imageFile)
        pageControler.currentPage = index
        contentText.text = content
        switch index {
        case 0:
            backButton.isHidden = true
            forwardButton.isHidden = false
            beginButton.isHidden = true
        case 1:
            backButton.isHidden = false
            forwardButton.isHidden = false
            beginButton.isHidden = true
        case 2:
            backButton.isHidden = false
            forwardButton.isHidden = true
            beginButton.isHidden = false
        default:
            break
        }
        
        beginButton.layer.cornerRadius = 29
        beginButton.layer.borderWidth = 3
        beginButton.layer.borderColor = UIColor.white.cgColor
        beginButton.clipsToBounds = true
        beginButton.backgroundColor = .clear
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonTap(_ sender: Any) {
        
        switch index {
        case 1:
            let pageViewController = parent as! TutorialPageViewController
            pageViewController.reverse(index: index)
        case 2:
            let pageViewController = parent as! TutorialPageViewController
            pageViewController.reverse(index: index)
        default:
            break
        }
        
    }
    
    @IBAction func beginButtonTap(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "hasViewedTutorial")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func forwardButtonTap(_ sender: Any) {
        
        switch index {
        case 0...1:
            let pageViewController = parent as! TutorialPageViewController
            pageViewController.forward(index: index)
        case 2:
            UserDefaults.standard.set(true, forKey: "hasViewedTutorial")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
    }
}
