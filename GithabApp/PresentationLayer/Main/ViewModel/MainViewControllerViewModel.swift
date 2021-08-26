//
//  MainViewControllerViewModel.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

class MainViewControllerViewModel: MainViewControllerViewModelType {
    
    var requestService: IRequestService
    var downloadService: IDownloadService
    var cdRequestService: ICDRequestService
    var delegate: MainViewControllerDelegate?
    
    private var users: [User] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    init(requestService: IRequestService, downloadService: IDownloadService, cdRequestService: ICDRequestService) {
        self.requestService = requestService
        self.downloadService = downloadService
        self.cdRequestService = cdRequestService
    }
    
    func searchUsers(_ searchText: String?) {
        
        guard let text = searchText?.trim().replacingOccurrences(of: " ", with: "%20"),
              text != "" else { return }
        requestService.getUsers(userName: text, completion: { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = []
                users?.items?.forEach { self?.getRepos($0) }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func getRepos(_ user: User?) {
        DispatchQueue.global().async {
            guard let login = user?.login else { return }
            self.requestService.getRepos(login: login, completion: { [weak self] result in
                switch result {
                case .success(let repos):
                    guard var user = user else { return }
                    user.repos = repos
                    self?.users.append(user)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func numberOfSection() -> Int? {
        users.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if !users.isEmpty {
            guard let repo = users[section].repos else { return 0 }
            return repo.count
        } else {
            return 0
        }
    }
    
    func getViewModelForCell(_ indexPath: IndexPath) -> MainCellViewModelType? {
        let user = users[indexPath.section]
        guard let repo = user.repos?[indexPath.row] else { return nil }
        
        return MainCellViewModel(repo: repo, downloadService: downloadService, cdRequestService: cdRequestService)
    }
    
    func getViewModelForHeader(_ section: Int) -> MainSectionHeaderViewModelType? {
        if !users.isEmpty {
            let user = users[section]
            return MainSectionHeaderViewModel(user: user)
        } else {
            return nil
        }
    }
    
    func getRepo(for indexPath: IndexPath) -> Repos? {
        let user = users[indexPath.section]
        let repo = user.repos?[indexPath.row]
        
        return repo
    }
    
}
