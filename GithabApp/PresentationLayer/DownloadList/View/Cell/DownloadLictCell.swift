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
}

class DownloadLictCell: UITableViewCell {
    
    static let reuseId = "DownloadLictCell"
    
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var repoName: UILabel?
    
    
    var viewModel: DownloadLictCellViewModelType? {
        didSet {
            guard let newModel = viewModel else { return }
            DispatchQueue.main.async {
                self.repoName?.text = newModel.repoName
                self.userName?.text = newModel.userName ?? ""
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
