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
    
    var opciones: Int?
    
    var servicesContainerViewController: ServicesContainerViewController?
    
//    var servicesContainerViewController: ServicesContainerViewController? {
//        didSet {
//            servicesContainerViewController?.servicesDelegate = self
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
    
       servicesContainerViewController?.servicesDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "services_container_segue"{
            let vc = segue.destination as! ServicesContainerViewController
            vc.opciones = opciones!
        }
        
    }

}

extension ServicesMainViewController: ServicesContainerViewControllerDelegate{
    
    func servicesContainerViewController(servicesContainerViewController: ServicesContainerViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
        print("QWERTYUIO")
    }
    
    func servicesContainerViewController(servicesContainerViewController: ServicesContainerViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        print("QWERTYUIO 1234567890")
    }
    
    
}
