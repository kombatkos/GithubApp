//
//  DownloadListViewControllerViewModel.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import Foundation

class DownloadListViewControllerViewModel: DownloadListViewControllerViewModelType {
    
    private var fileService: IFileService?
    private var cdRequestService: ICDRequestService?
    
    var repos = [DownloadsRepos]()
    
    init(deleteService: IFileService?, cdRequestService: ICDRequestService?) {
        self.fileService = deleteService
        self.cdRequestService = cdRequestService
        repos = cdRequestService?.getRepos() ?? []
    }
    
    func numberOfRowsInSection() -> Int {
        repos.count
    }
    
    func getViewModelForCell(_ indexPath: IndexPath) -> DownloadLictCellViewModelType? {
        let repo = repos[indexPath.row]
        return DownloadLictCellViewModel(repo: repo)
    }
    
    func deleteRow(_ index: Int) {
        guard let nameRepo = repos[index].repoName else { return }
        fileService?.deleteFile(nameRepo: nameRepo)
        cdRequestService?.removeReposRequest(repoName: nameRepo)
        repos.remove(at: index)
    }
    
    func tapRow(_ index: Int) {
        let nameRepo = repos[index].repoName
        fileService?.openFile(name: nameRepo)
    }
}
