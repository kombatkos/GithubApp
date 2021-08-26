//
//  MainCell.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 19.08.2021.
//

import UIKit
import AudioToolbox

protocol MainCellViewModelType {
    var name: String { get }
    var about: String { get }
    var rating: String { get }
    func downloadZIP(_ completion: @escaping (Error?) -> Void)
    var completion: (() -> Void)? { get set }
}

class MainCell: UITableViewCell {
    
    static var reuseId = "MainCell"
    private var isVibration = true
    
    weak var delegate: MainViewControllerDelegate?
    
    var viewModel: MainCellViewModelType? {
        didSet {
            guard let newModel = viewModel else { return }
            DispatchQueue.main.async {
                self.nameLabel?.text = newModel.name
                self.aboutLabel?.text = newModel.about
                self.ratingLabel?.text = newModel.rating
            }
            
            viewModel?.completion = { [weak self] in
                DispatchQueue.main.async {
                    self?.delegate?.stopSpiner()
                }
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var aboutLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(showMenu))
        self.addGestureRecognizer(longTap)
        
    }
    
    @objc private func showMenu() {
        if isVibration {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            isVibration = false
        }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let download = UIAlertAction(title: "Download zip", style: .default) { [weak self] _ in
            
            self?.delegate?.runSpiner()
            self?.viewModel?.downloadZIP { [weak self] error in
                guard let error = error else { return }
                self?.showAlert(error: error)
            }
            self?.isVibration = true
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(download)
        actionSheet.addAction(cancel)
        
        delegate?.presentAlert(actionSheet)
    }
    
    private func showAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(ok)
        
        delegate?.presentAlert(alert)
    }
}
