//
//  MainSectionHeaderViewModel.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 19.08.2021.
//

import Foundation

var imageCache = NSCache<NSString, NSData>()

class MainSectionHeaderViewModel: MainSectionHeaderViewModelType {
    
    var user: User
    
    var name: String {
        return user.login ?? "User"
    }
    
    var imageData: Box<Data?> = Box(nil)
    
    init(user: User) {
        self.user = user
        DispatchQueue.global().async {
            self.fetchImageData(user)
        }
    }
    
    private func fetchImageData(_ user: User) {
        guard let urlString = user.avatarUrl as NSString? else { return }
        
        if let cahceData = imageCache.object(forKey: urlString as NSString) {
            imageData.value = cahceData as Data
        } else {
            guard let url = URL(string: urlString as String),
                  let data = NSData(contentsOf: url) else { return}
            imageData.value = data as Data
            imageCache.setObject(data, forKey: urlString as NSString)
        }
    }
}
