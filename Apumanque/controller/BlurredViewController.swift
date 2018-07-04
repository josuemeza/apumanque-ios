//
//  TestViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 29-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class BlurredViewController: ViewController {
    
    var navigationBarBackgorundView: UIView!
    var backgroundImageView: UIImageView!
    var blurBackgroundView: UIVisualEffectView!
    var backgroundImage: UIImage?
    
    func build(withOpaqueNavigationBar opaque: Bool = false) {
        backgroundImageView = UIImageView()
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        blurBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.addSubview(blurBackgroundView)
        blurBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            blurBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            blurBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        backgroundImageView.image = backgroundImage
        if let _ = navigationController, opaque {
            navigationBarBackgorundView = UIView()
            navigationBarBackgorundView.backgroundColor = .black
            view.addSubview(navigationBarBackgorundView)
            navigationBarBackgorundView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([
                navigationBarBackgorundView.topAnchor.constraint(equalTo: view.topAnchor),
                navigationBarBackgorundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navigationBarBackgorundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navigationBarBackgorundView.heightAnchor.constraint(equalToConstant: navigationBarHeight)
            ])
            view.sendSubview(toBack: navigationBarBackgorundView)
        }
        view.sendSubview(toBack: blurBackgroundView)
        view.sendSubview(toBack: backgroundImageView)
    }

}
