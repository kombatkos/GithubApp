//
//  MainCellViewModel.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

class MainCellViewModel: MainCellViewModelType {
    
    private var downloadService: IDownloadService
    private var cdRequestService: ICDRequestService
    
    private let repo: Repos
    
    var name: String {
        return repo.name ?? ""
    }
    
    var about: String {
        return repo.description ?? ""
    }
    
    var rating: String {
        return String(repo.stargazersCount ?? 0)
    }
    
    var completion: (() -> Void)?
    
    init(repo: Repos, downloadService: IDownloadService, cdRequestService: ICDRequestService) {
        self.repo = repo
        self.downloadService = downloadService
        self.cdRequestService = cdRequestService
    }
    
    func downloadZIP(_ completion: @escaping (Error?) -> Void) {
        self.downloadService.completion = self.completion
        downloadService.downloadFile(repo: repo) { error in
            completion(error)
        }
        cdRequestService.saveReposRequest(repo: repo)
    }
}
