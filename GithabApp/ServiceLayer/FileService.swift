//
//  DeleteService.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import Foundation

protocol IFileService {
    func deleteFile(nameRepo: String)
    func openFile(name: String?)
}

class FileService: IFileService {
    
    var filesManager: IFilesManager?
    
    init(filesManager: IFilesManager) {
        self.filesManager = filesManager
    }
    
    func openFile(name: String?) {
        guard let name = name else { return}
        let fileName = name + ".zip"
        let folder = "Download"
        filesManager?.openFile(fromFolderInDocumentDirecory: folder, fileName: fileName)
    }
    
    func deleteFile(nameRepo: String) {
        
        let folderName = "Download"
        let fileName = nameRepo+".zip"
        filesManager?.deleteFile(fromFolderInDocumentDirecory: folderName, fileName: fileName)
    }

}
