//
//  SplashViewController.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 18.08.2021.
//

import UIKit
import SafariServices

class SplashViewController: UIViewController {
    
    var viewModel: SplashViewControllerViewModelType?
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var logoLabel: UILabel?
    @IBOutlet weak var loginButton: UIButton?
    @IBOutlet weak var centerVerticalConstraint: NSLayoutConstraint?
    @IBOutlet weak var logoAspectRatioConstraint: NSLayoutConstraint?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !(viewModel?.animationPassed ?? false) {
            startAnimation()
            viewModel?.animationPassed = true
        }
    }
    
    @IBAction func SignInButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: viewModel?.urlString ?? "") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func startAnimation() {
        centerVerticalConstraint?.constant -= 100
        logoAspectRatioConstraint?.constant += 50
        
        UIView.animate(withDuration: 1.5) {
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 1, delay: 1) {
            self.logoLabel?.alpha = 1
        }
        UIView.animate(withDuration: 1, delay: 1.8) {
            self.loginButton?.alpha = 1
        }

    }
}
