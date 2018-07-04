//
//  LoadingViewController.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: -
// MARK: - Loading view controller
class LoadingViewController: ViewController {
    
    // MARK: - Attributes
    
    private var downloads = [String]()
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.singleton.requestData { data in
            if let json = data {
                SessionManager.singleton.defaultToken = json["results"][0]["token"].string
                let menuItems = json["results"][0]["config"][1]["menues"][0]["options"].arrayValue
                NetworkingManager.singleton.storeCategories { storeCategories in
                    NetworkingManager.singleton.stores { stores in
                        NetworkingManager.singleton.spetialSales { discounts in
                            self.initMenuItems(from: menuItems)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func initMenuItems(from array: [JSON]) {
        for item in array {
            let category = HomeCategory(context: managedObjectContext)
            category.title = item["name"].string
            category.subtitle = item["texts"][0]["description"].string
            let imageUrl = item["icons"][0]["file"]["image_resolutions"]["image_1280"].stringValue
            downloads.append(imageUrl)
            NetworkingManager.singleton.downloadFile(on: imageUrl, completion: { data in
                if let data = data {
                    category.background = NSData(data: data)
                    if let index = self.downloads.index(where: { url in return url == imageUrl }) {
                        self.downloads.remove(at: index)
                        if self.downloads.isEmpty {
                            self.performSegue(withIdentifier: "loading_to_home_segue", sender: nil)
                        }
                    }
                } else {
                    print("Error downloading \(imageUrl)")
                }
            })
            ApplicationManager.singleton.homeCategories.append(category)
        }
    }

}
