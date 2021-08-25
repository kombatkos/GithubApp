//
//  DownloadLictCellViewModel.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import Foundation

class DownloadLictCellViewModel: DownloadLictCellViewModelType {
    
    var repo: DownloadsRepos?
    
    var repoName: String {
        return repo?.repoName ?? "Noname"
    }
    
    var userName: String? {
        return "Owner: \(repo?.userName ?? "Noname")"
    }
    
    init(repo: DownloadsRepos?) {
        self.repo = repo
    }
}
