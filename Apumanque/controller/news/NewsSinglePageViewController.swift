//
//  NewsSinglePageViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class NewsSinglePageViewController: UIPageViewController {
    
    // MARK: - Attributes
    
    var images = [UIImage]()
    fileprivate var pages = [NewsSinglePageItemViewController]()
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        if !images.isEmpty {
            presentGallery(with: images)
            setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        }
    }
    
    // MARK: - Methods
    
    private func presentGallery(with images: [UIImage]) {
        pages = []
        for image in images {
            let page = NewsSinglePageItemViewController()
            page.image = image
            pages.append(page)
        }
    }
    
    // MARK: - Internal class
    
    class NewsSinglePageItemViewController: UIViewController {
        
        var image: UIImage!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .clear
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            view.addConstraints([
                view.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
                view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -20),
                view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
                view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
            ])
            view.layoutIfNeeded()
            imageView.image = image
            imageView.layer.cornerRadius = 14
            imageView.clipsToBounds = true
        }
        
    }

}

// MARK: - Page view controller data source and delegate
extension NewsSinglePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let pageViewController = viewController as? NewsSinglePageItemViewController,
            let index = pages.index(of: pageViewController)
            else { return nil }
        let nextIndex = abs((index - 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let pageViewController = viewController as? NewsSinglePageItemViewController,
            let index = pages.index(of: pageViewController)
            else { return nil }
        let nextIndex = abs((index + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard
            let viewController = pageViewController.viewControllers?.first as? NewsSinglePageItemViewController,
            let index = pages.index(of: viewController)
            else { return 0 }
        return index
    }
    
}