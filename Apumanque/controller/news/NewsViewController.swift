//
//  NewsViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 09-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class NewsViewController: BlurredViewController {
    
    // MARK: - Actions
    
    @IBAction func categorySelectorAction(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        // TODO: implement
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build()
    }
    
    // MARK: - Navigation view controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BlurredViewController {
            let viewController: BlurredViewController
            if segue.destination is NewsSingleViewController {
                let storeCategories = segue.destination as! NewsSingleViewController
                viewController = storeCategories
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = backgroundImage
        }
    }

}

// MARK: - Collection view data source, delegate and layout delegate
extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 6
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "news_list_title_cell", for: indexPath) as! NewsListTitleCollectionViewCell
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "news_list_item_cell", for: indexPath) as! NewsListItemCollectionViewCell
            if indexPath.row == 0 {
                cell.type = .full
            } else if indexPath.row % 2 == 0 {
                cell.type = .right
            } else {
                cell.type = .left
            }
            cell.tagColor = .orange
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.size.width, height: 52)
        case 1:
            let width = Int(collectionView.frame.size.width / (indexPath.row == 0 ? 1 : 2))
            if indexPath.row == 0 {
                return CGSize(width: width, height: width - 20)
            }
            return CGSize(width: width - 5, height: width - 20)
        default:
            return CGSize()
        }
    }
    
}
