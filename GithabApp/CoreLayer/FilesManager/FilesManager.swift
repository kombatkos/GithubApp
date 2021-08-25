//
//  FilesManager.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import UIKit

protocol IFilesManager {
    func openFile(fromFolderInDocumentDirecory folderName: String, fileName: String)
    func deleteFile(fromFolderInDocumentDirecory folderName: String, fileName: String)
    func saveFile(fromThe url: URL,
                  fileNameOld: String,
                  fileNameNew: String,
                  location: URL,
                  folderName: String,
                  completion: @escaping () -> Void)
}

class FilesManager: IFilesManager {
    
    let fileManager = FileManager.default
    
    func openFile(fromFolderInDocumentDirecory folderName: String, fileName: String) {
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let downloadFileURL = documentsURL?.appendingPathComponent("/\(folderName)/\(fileName)")
        
        guard let sharedPath = downloadFileURL?.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://"),
              let sharedURL = URL(string: sharedPath) else { return }
        UIApplication.shared.open(sharedURL, options: [:], completionHandler: nil)
    }
    
    func deleteFile(fromFolderInDocumentDirecory folderName: String, fileName: String) {
        
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fooURL = documentsPath.appendingPathComponent(folderName).appendingPathComponent(fileName)
        let fileExists = FileManager().fileExists(atPath: fooURL.path)
        
        if fileExists {
            do {
                try fileManager.removeItem(at: fooURL)
            }
            catch {
                print("Remove Error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveFile(fromThe url: URL, fileNameOld: String, fileNameNew: String,
                  location: URL, folderName: String, completion: @escaping () -> Void) {
        
        createDownloadDirectory(folderName: folderName)
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let downloadPath = documentsPath.appendingPathComponent(folderName)
        let pathComponent = url.lastPathComponent.replacingOccurrences(of: fileNameOld, with: fileNameNew)
        var destinationURL = downloadPath.appendingPathComponent(pathComponent)
        destinationURL.appendPathExtension("zip")
        
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            completion()
        }
        catch {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
    private func createDownloadDirectory(folderName: String) {
        
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fooURL = documentsPath.appendingPathComponent(folderName)
        let fileExists = FileManager().fileExists(atPath: fooURL.path)
        print(fooURL)
        if !fileExists {
            do {
                let newPath = documentsPath.path + "/\(folderName)"
                try fileManager.createDirectory(atPath: newPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Create Error: \(error.localizedDescription)")
            }
        }
    }
}
