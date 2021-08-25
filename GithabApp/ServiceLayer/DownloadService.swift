//
//  DownloadService.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 22.08.2021.
//

import Foundation

protocol IDownloadService {
    func downloadFile(repo: Repos, completion: @escaping (Error?) -> Void )
    var completion: (() -> Void)? { get set }
}

class DownloadService: NSObject, IDownloadService {
    
    private let requestSender: IRequestSender?
    private let filesManager: IFilesManager?
    
    private let fileManager = FileManager.default
    private var fileName = "NewRepo"
    
    var completion: (() -> Void)?
    
    init(requestSender: IRequestSender?, filesManager: IFilesManager?) {
        self.requestSender = requestSender
        self.filesManager = filesManager
    }
    
    func downloadFile(repo: Repos, completion: @escaping (Error?) -> Void ) {
        
        guard let url = repo.archiveUrl?.replacingOccurrences(of: "{archive_format}{/ref}", with: "zipball/") else { return }
        fileName = repo.name ?? "NewRepo"
        
        requestSender?.send(
            request: RequestFactory.GithubRequests.downloadRepo(url: url),
            delegate: self,
            completionHandler: { error in
                completion(error)
            })
    }
}

extension DownloadService: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let url = downloadTask.originalRequest?.url else { return }
        
        filesManager?.saveFile(fromThe: url,
                               fileNameOld: "zipball",
                               fileNameNew: fileName,
                               location: location,
                               folderName: "Download",
                               completion: { [weak self] in
                                self?.completion?()
                               })
    }
}
