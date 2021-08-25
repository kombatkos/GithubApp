//
//  DownloadsRepos+CoreDataProperties.swift
//  
//
//  Created by Konstantin Porokhov on 25.08.2021.
//
//

import Foundation
import CoreData


extension DownloadsRepos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadsRepos> {
        return NSFetchRequest<DownloadsRepos>(entityName: "DownloadsRepos")
    }

    @NSManaged public var repoName: String?
    @NSManaged public var userName: String?

}
