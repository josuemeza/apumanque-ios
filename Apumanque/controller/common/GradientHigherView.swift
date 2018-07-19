//
//  GradientHigherView.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 18-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import Foundation
import UIKit

class GradientHigherView: UIView {
    
    lazy private var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        layer.locations = [NSNumber(value: -0.5), NSNumber(value: 1.0)]
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
}
