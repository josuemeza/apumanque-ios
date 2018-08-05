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
        layer.cornerRadius = CGFloat(radious)
        clipsToBounds = true
    }
    
    func radious(_ value: Int, on corners: UIRectCorner) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: value, height: value)
        ).cgPath
        layer.backgroundColor = UIColor.green.cgColor
        layer.mask = rectShape
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
    func gradient(colours: [UIColor], position: Double = 0.5, horizontal: Bool = false, locations: [NSNumber]? = nil) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        if horizontal {
            gradient.startPoint = CGPoint(x: 0.0, y: position)
            gradient.endPoint = CGPoint(x: 1.0, y: position)
        }
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    @IBInspectable var borderUIColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}
