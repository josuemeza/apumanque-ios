//
//  NewsViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 09-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SDWebImage

class NewsViewController: BlurredViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Attributes
    
    private var news: [News]!
    fileprivate var newsItems: [News]!
    
    // MARK: - Actions
    
    @IBAction func categorySelectorAction(_ sender: UISegmentedControl) {
        filterNewsItems()
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build()
        news = News.all(on: managedObjectContext)
        segmentedControl.setWidth(120, forSegmentAt: 2)
        filterNewsItems()
        segmentedControl.selectedSegmentIndex = 2
    }
    
    // MARK: - Navigation view controller methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BlurredViewController {
            let viewController: BlurredViewController
            if segue.destination is NewsSingleViewController {
                let newsSingle = segue.destination as! NewsSingleViewController
                if let indexPath = collectionView.indexPathsForSelectedItems?.first, indexPath.section == 1 {
                    newsSingle.news = newsItems[indexPath.row]
                }
                viewController = newsSingle
            } else {
                viewController = segue.destination as! BlurredViewController
            }
            viewController.backgroundImage = backgroundImage
        }
    }
    
    func filterNewsItems() {
        newsItems = news
        let newsTypeName = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? ""
        if newsTypeName != "Todo" {
            newsItems = newsItems.compactMap { news in
                guard let typeName = news.newsType?.name, typeName == newsTypeName else { return nil }
                return news
            }
        }
        newsItems.sort { left, right in
            if let leftDate = left.start?.toDate as Date?, let rightDate = right.start?.toDate as Date? {
                return leftDate > rightDate
            }
            return false
        }
        collectionView.reloadData()
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
        case 1: return newsItems.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "news_list_title_cell", for: indexPath) as! NewsListTitleCollectionViewCell
            cell.titleLabel.text = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
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
            let news = newsItems[indexPath.row]
            cell.titleLabel.text = news.title ?? "S/V"
            cell.tagLabel.text = news.newsType?.name ?? "S/V"
            switch news.newsType?.name?.lowercased() ?? "" {
            case "eventos":
                cell.tagColor = .orange
            case "cliente frecuente":
                cell.tagColor = .green
            case "generales":
                cell.tagColor = .blue
            default:
                cell.tagLabel.isHidden = true
            }
            if let stringUrl = news.mainFile?.url, let url = URL(string: stringUrl) {
                cell.backgroundImageView.sd_setImage(with: url, placeholderImage: UIColor.black.toImage())
            } else {
                cell.backgroundImageView.image = UIColor.black.toImage()
            }
            cell.subtitleLabel.text = news.start?.toDate.string(format: "yyyy") ?? "S/V"
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
