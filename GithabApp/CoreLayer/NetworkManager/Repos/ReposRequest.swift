//
//  ReposRequest.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 13.08.2021.
//

import Foundation

class ReposRequest: IRequest {
    
    private let secureDataManager = SecureDataManager()
    
    private let url = "https://api.github.com/"
    private var login: String?
    private lazy var token = secureDataManager.getToken()
    
    var urlString: String? {
        guard let login = self.login else { return nil }
        let parameters = "users/\(login)/repos"
        return url + parameters
    }
    
    var urlRequest: URLRequest? {
        guard let token = self.token,
              let urlString = self.urlString,
              let url = URL(string: urlString)  else { return nil }
        
        var request = URLRequest(url: url)
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "accept")
        
        return request
    }
    
    init(login: String?) {
        self.login = login
    }
}
