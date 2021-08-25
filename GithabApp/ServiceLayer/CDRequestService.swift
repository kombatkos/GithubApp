//
//  CDRequestService.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import CoreData

protocol ICDRequestService {
    func saveReposRequest(repo: Repos)
    func removeReposRequest(repoName: String)
    func getRepos() -> [DownloadsRepos]
}

struct CDRequestService: ICDRequestService {
    
    let coreDataStack: IModernCoreDataStack
    let context: NSManagedObjectContext
    
    init(coreDataStack: IModernCoreDataStack) {
        self.coreDataStack = coreDataStack
        context = coreDataStack.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func getRepos() -> [DownloadsRepos] {
        let context = coreDataStack.container.viewContext
        let request: NSFetchRequest<DownloadsRepos> = DownloadsRepos.fetchRequest()
        do {
            let result = try context.fetch(request)
            return result
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func saveReposRequest(repo: Repos) {
        DispatchQueue.global(qos: .utility).async {
            context.performAndWait {
            
                guard let user = repo.owner?.login,
                      let name = repo.name else { return }
                let newRepo = DownloadsRepos(userName: user, repoName: name, in: context)
                let request: NSFetchRequest<DownloadsRepos> = DownloadsRepos.fetchRequest()
                
                do {
                    var result = try context.fetch(request)
                    result.append(newRepo)
                    try context.save()
                }
                catch { print(error.localizedDescription) }
                
            }
        }
    }
    
    func removeReposRequest(repoName: String) {
        DispatchQueue.global(qos: .utility).async {
            
            context.performAndWait {
                guard let object = getObjectRequest(entityName: "DownloadsRepos",
                                                    predicate: "repoName",
                                                    repoName as CVarArg,
                                                    context: context) else { return }
                object.managedObjectContext?.delete(object)
                
                do { try context.save() } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getObjectRequest<T>(entityName: String, predicate format: String, _ value: CVarArg, context: NSManagedObjectContext) -> T? where T: NSManagedObject {
        
        let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "\(format) = %@", value)
        
        var object: NSManagedObject?
        
        context.performAndWait {
            do {
                let searchMessage = try context.fetch(request)
                object = searchMessage.first
            } catch let error { assertionFailure(error.localizedDescription) }
        }
        return object as? T
    }
    
}

