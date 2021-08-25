//
//  AppDelegate.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import UIKit
import SafariServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let coreAssembly: ICoreAssembly = CoreAssembly()
    private let serviceAssembly: IServiceAssembly = ServiceAssembly()
    private let presentationSssembly: IPresentationAssembly = PresentationAssembly()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
//        if let _ = coreAssembly.secureDataManager.getToken() {
//            let mainVC = presentationSssembly.createMainViewController()
//            let navigationController = UINavigationController(rootViewController: mainVC)
//            window?.rootViewController = navigationController
//        } else {
            let splashVC = presentationSssembly.createSplashViewController()
            window?.rootViewController = splashVC
//        }
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let components = URLComponents(string: url.absoluteString) else { return false }
        guard let code = components.queryItems?.first(where: { $0.name == "code" })?.value else { return false }
       
        serviceAssembly.requestService.authorization(code)
        
        app.keyWindow?.rootViewController?.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let mainVC = self.presentationSssembly.createMainViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
}
