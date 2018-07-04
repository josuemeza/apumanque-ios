//
//  TutorialPageViewController.swift
//  Apumanque
//
//  Created by Rinno on 18-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageImages = ["Splash1", "Splash2", "Splash3"]
    var pageContentText = ["Encuentra fácilmente locales y productos de tu interés.", "sube de nivel y acumula más cupones en cada campaña. Más cupones, más probabilidadesde ganar !", "Obtén suculentos descuentos y productosen promoción !"]
    
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func reverse(index: Int) {
        if let nextViewController = contentViewController(at: index - 1) {
            setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> TutorialContentViewController? {
        if index < 0 || index >= pageImages.count {
            return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "TutorialContentViewController") as? TutorialContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.content = pageContentText[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
                break
            }
        }
        dataSource = self
        
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        FIRAnalytics.logEvent(withName: "Tutorial", parameters: nil)
    }
    override var prefersStatusBarHidden : Bool {
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension TutorialPageViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        percentComplete = fabs(point.x - view.frame.size.width)/view.frame.size.width
        //NSLog("percentComplete: %f", percentComplete)
        
        if(0.8 > percentComplete)
        {
            //selectedIndex = 1
            scrollView.bounces = false
        }
            
        else
        {
            scrollView.bounces = true
            
        }
    }
}
