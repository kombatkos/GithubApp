//
//  CoreDataStack.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import Foundation
import CoreData

protocol IModernCoreDataStack {
    var container: NSPersistentContainer {get}
}

class ModernCoreDataStack: IModernCoreDataStack {
    private let dataBaseName = "ReposCD"

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("something went wrong \(error) \(error.userInfo)")
            }
        }
        return container
    }()
}
