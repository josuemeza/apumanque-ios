//
//  ServicesMainViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 06-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class ServicesMainViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    var
    
    
    
    var servicesContainerViewController: ServicesContainerViewController?
    
//    var servicesContainerViewController: ServicesContainerViewController? {
//        didSet {
//            servicesContainerViewController?.servicesDelegate = self
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("services \(self.servicesOptions)")
        if let viewController = segue.destination as? ServicesContainerViewController {
            self.servicesContainerViewController = viewController
            self.servicesContainerViewController?.servicesDelegate = self
            self.servicesContainerViewController?.opciones = self.servicesOptions
        }
        
    }

}

extension ServicesMainViewController: ServicesContainerViewControllerDelegate{
    
    func servicesContainerViewController(servicesContainerViewController: ServicesContainerViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    func servicesContainerViewController(servicesContainerViewController: ServicesContainerViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
    
}
