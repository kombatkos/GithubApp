//
//  PresentationAssembly.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import UIKit

protocol IPresentationAssembly: AnyObject {
    func createMainViewController(assembly: IPresentationAssembly?) -> MainViewController
    func createSplashViewController() -> SplashViewController
    func createDownloadListViewController() -> DownloadListViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    var serviceAssembly: IServiceAssembly = ServiceAssembly()
    
    func createMainViewController(assembly: IPresentationAssembly?) -> MainViewController {
        let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        let viewModel = MainViewControllerViewModel(requestService: serviceAssembly.requestService,
                                                    downloadService: serviceAssembly.downloadService,
                                                    cdRequestService: serviceAssembly.cdRequestService)
        vc.viewModel = viewModel
        vc.assembly = assembly
        return vc
    }
    
    func createSplashViewController() -> SplashViewController {
        let viewModel = SplashViewControllerViewModel()
        let vc = SplashViewController(nibName: "SplashViewController", bundle: nil)
        vc.viewModel = viewModel
        return vc
    }
    
    func createDownloadListViewController() -> DownloadListViewController {
        let viewModel = DownloadListViewControllerViewModel(
            deleteService: serviceAssembly.deleteService,
            cdRequestService: serviceAssembly.cdRequestService
        )
        let vc = DownloadListViewController(nibName: "DownloadListViewController", bundle: nil)
        vc.viewModel = viewModel
        return vc
    }
}
