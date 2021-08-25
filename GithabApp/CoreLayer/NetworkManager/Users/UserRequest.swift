//
//  GithubRequest.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

class UserRequest: IRequest {
    
    private let secureDataManager = SecureDataManager()
    private var url = "https://api.github.com/"
    private let userName: String
    lazy var token = secureDataManager.getToken()
    
    private var urlString: String  {
        let parameters = "search/users?q=\(userName)"
        return url + parameters
    }
    
    var urlRequest: URLRequest? {
        guard let token = self.token,
              let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "accept")
        return request
    }
    
    init(userName: String) {
        self.userName = userName
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
