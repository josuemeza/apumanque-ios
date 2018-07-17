//
//  NewsSingleViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class NewsSingleViewController: BlurredViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var galleryHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Attributes
    
    var news: News!
    fileprivate var images = [URL]()
    
    // MARK: - Actions
    
    @IBAction func legalBasesButtonAction(_ sender: Any) {
        
    }
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        build()
        if let nsSet = news.newsFiles, let newsFiles = nsSet.allObjects as? [NewsFile] {
            images = newsFiles.compactMap { newsFile in  URL(string: newsFile.url!) }
        }
        titleLabel.text = news.title
        subtitleLabel.text = news.start?.toDate.string(format: "yyyy")
        contentLabel.text = news.content?.parsedOnDocument
    }
    
    // MARK: - Navigation controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewsSinglePageViewController {
            if images.isEmpty {
                galleryHeightConstraint.constant = 0
            } else {
                let viewController = segue.destination as! NewsSinglePageViewController
                viewController.images = images
            }
        }
    }

}
