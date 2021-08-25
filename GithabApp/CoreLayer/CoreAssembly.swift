//
//  CoreAssembly.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

protocol ICoreAssembly {
    var requestSender: IRequestSender { get }
    var secureDataManager: ISecureDataManager { get }
    var filesManager: IFilesManager { get }
    var coreDataStack: IModernCoreDataStack {get}
}

class CoreAssembly: ICoreAssembly {
    
    lazy var requestSender: IRequestSender = RequestSender()
    lazy var secureDataManager: ISecureDataManager = SecureDataManager()
    lazy var filesManager: IFilesManager = FilesManager()
    lazy var coreDataStack: IModernCoreDataStack = ModernCoreDataStack()
}
