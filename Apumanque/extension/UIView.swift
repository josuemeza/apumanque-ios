//
//  UIView.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

extension UIView {
    
    func takeScreenshot(_ shouldSave: Bool = false) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    /**
     **roundOut**
     
     Add corner radious to this view.
     
     - Parameter radious: Radious value to apply.
     */
    func roundOut(radious: Float) {
        self.layer.cornerRadius = CGFloat(radious)
        self.clipsToBounds = true
    }
    
    /**
     **border**
     
     Set border with color to this view.
     
     - Parameters:
     - color: Border color.
     - width: Border width.
     */
    func border(_ color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    /**
     **gradient**
     
     Apply color gradient to UIView
     
     - Parameters:
     - colours: Array with colours to apply on gradient.
     - locations: Percentage location of color apparition.
     */
    func gradient(colours: [UIColor], horizontal: Bool = false, locations: [NSNumber]? = nil) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        if horizontal {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
}
