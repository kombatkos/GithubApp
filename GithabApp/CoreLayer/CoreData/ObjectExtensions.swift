//
//  ObjectExtensions.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import Foundation
import CoreData

extension DownloadsRepos {
    
    convenience init(userName: String,
                     repoName: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.userName = userName
        self.repoName = repoName
    }
}
