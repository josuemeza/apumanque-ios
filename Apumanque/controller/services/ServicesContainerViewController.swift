//
//  ServicesContainerViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 06-06-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

protocol ServicesContainerViewControllerDelegate: class {
    

    func servicesContainerViewController(servicesContainerViewController: ServicesContainerViewController,
                                    didUpdatePageCount count: Int)
    

    func servicesContainerViewController(servicesContainerViewController: ServicesContainerViewController,
                                    didUpdatePageIndex index: Int)
    
}

class ServicesContainerViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    weak var servicesDelegate: ServicesContainerViewControllerDelegate?
    var opciones: Int?
    
    lazy var subViewControllers = {
        return [
        UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "KeeperViewController") as! KeeperViewController,
        UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "BikeViewController") as! BikeViewController,
        UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "WheelchairViewController") as! WheelchairViewController,
        UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "BabycarriageViewController") as! BabycarriageViewController,
        UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "ParkingViewController") as! ParkingViewController]}()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        print("OPCIONES \(opciones)")
        // Do any additional setup after loading the view.
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        servicesDelegate?.servicesContainerViewController(servicesContainerViewController: self, didUpdatePageCount: subViewControllers.count)
        servicesDelegate?.servicesContainerViewController(servicesContainerViewController: self, didUpdatePageIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if(currentIndex <= 0) {
            servicesDelegate?.servicesContainerViewController(servicesContainerViewController: self, didUpdatePageIndex: currentIndex)
            return nil
        }
        servicesDelegate?.servicesContainerViewController(servicesContainerViewController: self, didUpdatePageIndex: currentIndex)
        return subViewControllers[currentIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if(currentIndex >= subViewControllers.count - 1) {
            servicesDelegate?.servicesContainerViewController(servicesContainerViewController: self, didUpdatePageIndex: currentIndex)
            return nil
        }
        servicesDelegate?.servicesContainerViewController(servicesContainerViewController: self, didUpdatePageIndex: currentIndex)
        return subViewControllers[currentIndex+1]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
