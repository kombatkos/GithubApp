//
//  RequestFactory.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

struct RequestFactory {
    
    struct GithubRequests {
        
        static func authorization(code: String) -> RequestConfig<AuthorizationParser> {
            let request = AuthorizationRequest(code: code)
            let parser = AuthorizationParser()
            
            return RequestConfig<AuthorizationParser>(request: request, parser: parser)
        }
        
        static func searchUser(userName: String) -> RequestConfig<UserParser> {
            let request = UserRequest(userName: userName)
            let parser = UserParser()
            
            return RequestConfig<UserParser>(request: request, parser: parser)
        }
        
        static func getRepos(login: String?) -> RequestConfig<ReposParser> {
            let request = ReposRequest(login: login)
            let parser = ReposParser()
            
            return RequestConfig<ReposParser>(request: request, parser: parser)
        }
        
        static func downloadRepo(url: String) -> IRequest? {
            return DownloadRequest(url: url)
        }
    }
    
}
