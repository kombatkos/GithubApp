//
//  DownloadRequest.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 22.08.2021.
//

import Foundation

class DownloadRequest: IRequest {
    
    private let url: String
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.addValue("", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "accept")
        
        return request
    }
    
    init(url: String) {
        self.url = url
    }
}
