//
//  NetworkingManager.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

/**
 **NetworkManager**
 
 Manager for all networking interactions in the application.
 */
class NetworkingManager {
    
    typealias Callback<T> = (_ value: T?) -> Void
    
    let apiUrl = "http://develop.rinnolab.cl"
    var context: NSManagedObjectContext?
    
    func login(username: String, password: String, completion: @escaping Callback<(user: User, token: String)>) {
        guard let context = context else { completion(nil) ; return }
        let endpoint = "/hxc/api/login_token/"
        let parameters: Parameters = ["username": username, "password": password]
        Alamofire.request("\(apiUrl)\(endpoint)", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)["results"][0]
                let user = User(context: context)
                if let token = json["token"].string, user.setData(from: json["user"]) {
                    user.password = password
                    completion((user: user, token: token))
                } else {
                    completion(nil)
                }
            case .failure(let responseError):
                print(responseError.localizedDescription)
                completion(nil)
            }
        }
    }
    
    private func user(action: HTTPMethod, user: User, completion: @escaping Callback<User>) {
        let endpoint = "/hxc/api/user/\(action == .put ? "\(user.id!)/" : "")"
        let headers: HTTPHeaders = ["Authorization": "token \(SessionManager.singleton.token!)"]
        // TODO: review commune on user put API
        var parameters: Parameters = [
            "username": user.email!,
            "password": user.password!,
            "email": user.email!,
            "first_name": user.firstName!,
            "last_name": user.lastName!,
            "rut": user.rut ?? "",
            "phone_number": user.phone ?? ""
        ]
        if let address = user.address {
            parameters["address"] = address
        }
        if let region = user.region {
            parameters["region"] = region
        }
        if let birthday = user.birthday {
            parameters["birthdate"] = (birthday as Date).string(format: "yyyy-MM-dd")
        }
        Alamofire.request("\(apiUrl)\(endpoint)", method: action, parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)["results"][0]
                if user.setData(from: json) {
                    completion(user)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func user(create user: User, completion: @escaping Callback<User>) {
        self.user(action: .post, user: user, completion: completion)
    }
    
    func user(edit user: User, completion: @escaping Callback<User>) {
        self.user(action: .put, user: user, completion: completion)
    }
    
    func stores(completion: @escaping Callback<[Store]>) {
        guard let context = context else { completion(nil) ; return }
        let endpoint = "/basicmall/api/stores/"
        let headers: HTTPHeaders = ["Authorization": "token \(SessionManager.singleton.token!)"]
        Alamofire.request("\(apiUrl)\(endpoint)", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("TOKEN \(SessionManager.singleton.token!)")
                guard let storesJSON = JSON(value)["results"].array else { completion(nil) ; return }
                var stores = [Store]()
                for storeJSON in storesJSON {
                    let store = Store(context: context)
                    if store.setData(from: storeJSON) {
                        stores.append(store)
                    }
                }
                completion(stores)
            case .failure(let responseError):
                print(responseError.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func storeCategories(completion: @escaping Callback<[StoreCategory]>) {
        guard let context = context else { completion(nil) ; return }
        let endpoint = "/basicmall/api/categories/"
        let headers: HTTPHeaders = ["Authorization": "token \(SessionManager.singleton.token!)"]
        Alamofire.request("\(apiUrl)\(endpoint)", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let categoriesJSON = JSON(value)["results"].array else { completion(nil) ; return }
                var storeCategories = [StoreCategory]()
                for categoryJSON in categoriesJSON {
                    let storeCategory = StoreCategory(context: context)
                    if storeCategory.setData(from: categoryJSON) {
                        storeCategories.append(storeCategory)
                    }
                }
                completion(storeCategories)
            case .failure(let responseError):
                print(responseError.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func spetialSales(completion: @escaping Callback<[Discount]>) {
        guard let context = context else { completion(nil) ; return }
        let endpoint = "/basicmall/api/\(SessionManager.singleton.isLogged ? "user_" : "")special_sales/"
        let headers: HTTPHeaders = ["Authorization": "token \(SessionManager.singleton.token!)"]
        Alamofire.request("\(apiUrl)\(endpoint)", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let discountsJSON = JSON(value)["results"].array else { completion(nil) ; return }
                var discounts = [Discount]()
                for discountJSON in discountsJSON {
                    let discount = Discount(context: context)
                    if let user = SessionManager.singleton.currentUser {
                        if discount.setData(from: discountJSON["id_special_sale"], featured: false) {
                            discount.addToUsers(user)
                            discounts.append(discount)
                        }
                    } else {
                        if discount.setData(from: discountJSON, featured: false) {
                            discounts.append(discount)
                        }
                    }
                }
                completion(discounts)
            case .failure(let responseError):
                print(responseError.localizedDescription)
            }
        }
    }
    
    func featuredSpetialSales(completion: @escaping Callback<[Discount]>) {
        guard let context = context else { completion(nil) ; return }
        let endpoint = "/basicmall/api/\(SessionManager.singleton.isLogged ? "user_" : "")special_sales/?code=featuredProduct"
        let headers: HTTPHeaders = ["Authorization": "token \(SessionManager.singleton.token!)"]
        Alamofire.request("\(apiUrl)\(endpoint)", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let discountsJSON = JSON(value)["results"].array else { completion(nil) ; return }
                var discounts = [Discount]()
                for discountJSON in discountsJSON {
                    let discount = Discount(context: context)
                    if let user = SessionManager.singleton.currentUser {
                        if discount.setData(from: discountJSON, featured: true) {
                            discount.addToUsers(user)
                            discounts.append(discount)
                        }
                    } else {
                        if discount.setData(from: discountJSON, featured: true) {
                            discounts.append(discount)
                        }
                    }
                }
                completion(discounts)
            case .failure(let responseError):
                print(responseError.localizedDescription)
            }
        }
    }
    
    func campaings(completion: @escaping Callback<[Campaing]>) {
        guard let context = context else { completion(nil) ; return }
        let endpoint = "/basicmall/api/campaigns/"
        let headers: HTTPHeaders = ["Authorization": "token \(SessionManager.singleton.token!)"]
        Alamofire.request("\(apiUrl)\(endpoint)", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let campaingsJSON = JSON(value)["results"].array else { completion(nil) ; return }
                var campaings = [Campaing]()
                for campaingJSON in campaingsJSON {
                    if campaingJSON["is_active"].bool! {
                        let campaing = Campaing(context: context)
                        if campaing.setData(from: campaingJSON) {
                            campaings.append(campaing)
                        }
                    }
                }
                completion(campaings)
            case .failure(let responseError):
                print(responseError.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func requestData(completion: @escaping Callback<JSON>) {
        let endpoint = "/hxc/api/login_token/"
        let parameters: Parameters = ["username": "apumanque_user", "password": "apumanque2018"]
        Alamofire.request("\(apiUrl)\(endpoint)", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
            case .failure(let responseError):
                print(responseError.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func downloadFile(on url: String, completion: @escaping (_ data: Data?) -> Void) {
        Alamofire.request(url).responseData { response in
            guard let data = response.result.value else { completion(nil) ; return }
            completion(data)
        }
    }
    
    // MARK: - Singleton definition
    
    /// Singleton definition
    static let singleton = NetworkingManager()
    
    /// Singleton constructor
    private init() {}
    
}
