//
//  SplashViewControllerViewModel.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 19.08.2021.
//

import Foundation

protocol SplashViewControllerViewModelType {
    var animationPassed: Bool { get set }
    var urlString: String? { get }
}

class SplashViewControllerViewModel: SplashViewControllerViewModelType {
    
    // URL
    private let authorizeURL = Bundle.main.object(forInfoDictionaryKey: "authorizeURL") as? String
    
    // Parameters
    private let redirectUri = Bundle.main.object(forInfoDictionaryKey: "redirectUri") as? String
    private let clientID = Bundle.main.object(forInfoDictionaryKey: "clientID") as? String
    
    // Create request url
    var urlString: String? {
        let state = randomString(length: 7)
        guard let authorizeURL = authorizeURL,
              let redirectUri = redirectUri,
              let clientID = clientID else { return nil }
        
        let params = "?redirect_uri=\(redirectUri)&state=\(state)&client_id=\(clientID)"
        return authorizeURL + params
    }
    
    var animationPassed = false
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
