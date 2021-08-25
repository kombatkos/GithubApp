//
//  ServiceAssembly.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

protocol IServiceAssembly {
    var requestService: IRequestService { get }
    var downloadService: IDownloadService { get }
    var deleteService: IFileService { get }
    var coreDataStack: IModernCoreDataStack {get}
    var cdRequestService: ICDRequestService { get }
}

class ServiceAssembly: IServiceAssembly {
    
    let coreAssembly: ICoreAssembly = CoreAssembly()
    
    lazy var coreDataStack: IModernCoreDataStack = coreAssembly.coreDataStack
    lazy var cdRequestService: ICDRequestService = CDRequestService(
        coreDataStack: coreAssembly.coreDataStack
    )
    lazy var requestService: IRequestService = RequestService(
        requestSender: coreAssembly.requestSender,
        secureDataManager: coreAssembly.secureDataManager
    )
    
    lazy var downloadService: IDownloadService = DownloadService(
        requestSender: coreAssembly.requestSender,
        filesManager: coreAssembly.filesManager
    )
    
    lazy var deleteService: IFileService = FileService(
        filesManager: coreAssembly.filesManager
    )
}
