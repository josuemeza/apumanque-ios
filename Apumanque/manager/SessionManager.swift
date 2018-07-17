//
//  SessionManager.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 28-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import Foundation

// MARK: - SessionManager singleton definition
class SessionManager {
    
    // MARK: - Attributes
    
    var defaultToken: String? {
        didSet {
            token = defaultToken
        }
    }
    var token: String?
    var currentUser: User?
    var isLogged: Bool { get { return currentUser != nil } }
    
    // MARK: - Methods
    
    func login(username: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        NetworkingManager.singleton.login(username: username, password: password, completion: { result in
            if let result = result {
                self.currentUser = result.user
                self.token = result.token
                NetworkingManager.singleton.spetialSales { _ in
                    completion(true)
                }
            } else {
                completion(false)
            }
        })
    }
    
    func logout() {
        token = defaultToken
        currentUser = nil
    }
    
    // MARK: - Singleton definition
    
    /// Singleton definition
    static let singleton = SessionManager()
    
    /// Singleton constructor
    private init() {}
    
}
