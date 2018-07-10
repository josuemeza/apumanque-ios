//
//  recentSearchTableViewCell.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 09-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

protocol RecentSearchTableViewCellDelegate {
    func recentSearchTableViewCell(_ cell: RecentSearchTableViewCell, didSelectStore store: Store)
}

class RecentSearchTableViewCell: UITableViewCell {
    
    // MARK: - Definitions
    
    private let colors: [UIColor] = [
        UIColor(red: 23/255, green: 130/255, blue: 162/255, alpha: 1),
        UIColor(red: 1, green: 173/255, blue: 4/255, alpha: 1),
        UIColor(red: 1, green: 0, blue: 77/255, alpha: 1),
        UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    ]
    
    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Attributes
    
    var delegate: RecentSearchTableViewCellDelegate?
    var recentSearchStores = [Store]()
    
    // MARK: - Methods
    
    fileprivate func colorForCellAt(_ indexPath: IndexPath) -> UIColor {
        let value = indexPath.row + 1
        if value % 4 == 0 {
            return colors[3]
        } else if value % 3 == 0 {
            return colors[2]
        } else if value % 2 == 0 {
            return colors[1]
        } else {
            return colors[0]
        }
    }

}

// MARK: -
// MARK: - Collection view data source
extension RecentSearchTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchStores.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recent_search_collection_cell", for: indexPath) as! RecentSearchCollectionViewCell
        let store = recentSearchStores[indexPath.row]
        cell.characterLabel.text = store.name?.first != nil ? String(store.name!.first!) : ""
        cell.characterLabel.backgroundColor = colorForCellAt(indexPath)
        cell.storeNameLabel.text = store.name
        cell.storeCategoryLabel.text = (store.categories?.allObjects as? [StoreCategory])?.first?.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let store = recentSearchStores[indexPath.row]
        delegate?.recentSearchTableViewCell(self, didSelectStore: store)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
