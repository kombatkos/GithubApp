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
    
    var imageData: Box<Data?> = Box(nil)
    
    init(repo: DownloadsRepos?) {
        self.repo = repo
        imageData.value = fetchImage(repo?.avatarURL)
    }
    
    private func fetchImage(_ urlString: String?) -> Data? {
        guard let urlString = repo?.avatarURL,
              let url = URL(string: urlString),
              let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}
