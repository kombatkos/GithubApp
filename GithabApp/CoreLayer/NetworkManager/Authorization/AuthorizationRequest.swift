//
//  AuthorizationRequest.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 18.08.2021.
//

import Foundation

class AuthorizationRequest: IRequest {
    
    // URL
    let url = "https://github.com/login/oauth/access_token"
    
    // Parameters GithubApp://MainViewController.page
    let redirectUri = Bundle.main.object(forInfoDictionaryKey: "redirectUri") as? String
    let clientID = Bundle.main.object(forInfoDictionaryKey: "clientID") as? String
    let clientSecret = Bundle.main.object(forInfoDictionaryKey: "clientSecret") as? String
    let code: String
    
    // Create request url
    var urlString: String? {
        guard let redirectUri = redirectUri,
              let clientID = clientID,
              let clientSecret = clientSecret else { return nil}
        let params = "?client_id=\(clientID)&client_secret=\(clientSecret)&code=\(code)&redirect_uri=\(redirectUri)"
        return url + params
    }
    
    var urlRequest: URLRequest? {
        guard let urlString = urlString,
              let url = URL(string: urlString)  else { return nil }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    init(code: String) {
        self.code = code
    }
}
