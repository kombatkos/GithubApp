//
//  SecureDataManager.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 18.08.2021.
//

import Foundation
import Locksmith

protocol ISecureDataManager {
    func saveToken(_ accessToken: String)
    func getToken() -> String?
}

class SecureDataManager: ISecureDataManager {
    
    private let userAccount = "Github"
    
    func saveToken(_ accessToken: String) {
        do {
            try Locksmith.saveData(data: ["accessToken": accessToken], forUserAccount: userAccount)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getToken() -> String? {
        let token = Locksmith.loadDataForUserAccount(userAccount: userAccount)
        return token?["accessToken"] as? String
    }
}
