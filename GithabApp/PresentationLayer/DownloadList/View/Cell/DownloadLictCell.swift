//
//  DownloadLictCell.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import UIKit

protocol DownloadLictCellViewModelType {
    var repoName: String { get }
    var userName: String? { get }
    var imageData: Box<Data?> { get }
}

class DownloadLictCell: UITableViewCell {
    
    static let reuseId = "DownloadLictCell"
    
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var repoName: UILabel?
    @IBOutlet weak var avatarImageView: UIImageView?
    
    
    var viewModel: DownloadLictCellViewModelType? {
        didSet {
            guard let newModel = viewModel else { return }
            DispatchQueue.main.async {
                self.repoName?.text = newModel.repoName
                self.userName?.text = newModel.userName ?? ""
            }
            getImage()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let width = avatarImageView?.frame.width else { return }
        avatarImageView?.layer.cornerRadius = width / 5
    }
    
    private func getImage() {
        viewModel?.imageData.binde {
            guard let data = $0, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.avatarImageView?.image = image
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
