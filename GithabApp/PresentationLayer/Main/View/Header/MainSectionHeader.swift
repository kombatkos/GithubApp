//
//  MainSectionHeader.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 19.08.2021.
//

import UIKit

protocol MainSectionHeaderViewModelType {
    var name: String { get }
    var imageData: Box<Data?> { get }
}

class MainSectionHeader: UITableViewHeaderFooterView {
    
    static var reuseId = "MainSectionHeader"
    
    var viewModel: MainSectionHeaderViewModelType? {
        didSet {
            DispatchQueue.main.async {
                self.nameLabel?.text = self.viewModel?.name
            }
        }
    }

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var avatarImageView: UIImageView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        getImage()
        guard let frame = avatarImageView?.frame else { return }
        avatarImageView?.layer.cornerRadius = frame.height / 2
    }
    
    private func getImage() {
        viewModel?.imageData.binde {
            guard let data = $0, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.avatarImageView?.image = image
            }
        }
    }
}
