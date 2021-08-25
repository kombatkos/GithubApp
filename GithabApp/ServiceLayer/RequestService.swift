//
//  GithubService.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

protocol IRequestService {
    func getUsers(userName: String, completion: @escaping (Result<Users?, Error>) -> Void)
    func getRepos(login: String?, completion: @escaping (Result<[Repos]?, Error>) -> Void)
    func authorization(_ code: String)
}

class RequestService: IRequestService {
    
    private let requestSender: IRequestSender?
    private let secureDataManager: ISecureDataManager?
    
    init(requestSender: IRequestSender?, secureDataManager: ISecureDataManager?) {
        self.requestSender = requestSender
        self.secureDataManager = secureDataManager
    }
    
    func authorization(_ code: String) {
        let config = RequestFactory.GithubRequests.authorization(code: code)
        
        requestSender?.send(config: config, completionHandler: { [weak self] result in
            switch result {
            case .success(let token):
                guard let token = token.accessToken else { return }
                self?.secureDataManager?.saveToken(token)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getUsers(userName: String, completion: @escaping (Result<Users?, Error>) -> Void) {
        let config = RequestFactory.GithubRequests.searchUser(userName: userName)
        
        requestSender?.send(config: config, completionHandler: { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func getRepos(login: String?, completion: @escaping (Result<[Repos]?, Error>) -> Void) {
        let config = RequestFactory.GithubRequests.getRepos(login: login)
        
        requestSender?.send(config: config, completionHandler: { result in
            switch result {
            case .success(let repos):
                completion(.success(repos))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}
