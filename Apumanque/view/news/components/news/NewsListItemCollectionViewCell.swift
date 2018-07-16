//
//  NewsListItemCollectionViewCell.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 15-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class NewsListItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Definitions
    
    private let colors: [UIColor] = [
        UIColor(red: 30/255, green: 155/255, blue: 90/255, alpha: 1),
        UIColor(red: 244, green: 85/255, blue: 22/255, alpha: 1),
        UIColor(red: 1, green: 120, blue: 215/255, alpha: 1)
    ]
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Enumerations
    
    enum TagColor: Int {
        case green = 0, orange, blue
    }
    
    enum CellType {
        case full, left, right
    }
    
    // MARK: - Attributes
    
    var tagColor: TagColor = .green {
        didSet {
            tagLabel.backgroundColor = colors[tagColor.rawValue]
        }
    }
    
    var type: CellType = .full {
        didSet {
            switch type {
            case .full:
                leftConstraint.constant = 20
                rightConstraint.constant = 20
            case .left:
                leftConstraint.constant = 20
                rightConstraint.constant = 5
            case .right:
                leftConstraint.constant = 5
                rightConstraint.constant = 20
            }
            if type == .full {
                titleLabel.font = titleLabel.font.withSize(33)
                subtitleLabel.font = subtitleLabel.font.withSize(18)
                subtitleBottomConstraint.constant = 51
            } else {
                titleLabel.font = titleLabel.font.withSize(16)
                subtitleLabel.font = subtitleLabel.font.withSize(10)
                subtitleBottomConstraint.constant = 15
            }
        }
    }
    
}
