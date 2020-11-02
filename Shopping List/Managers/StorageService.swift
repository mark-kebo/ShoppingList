//
//  EntitiesManager.swift
//
//  Created by Dmitry Vorozhbicki on 26/10/2019.
//  Copyright © 2019 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit
import CoreData

protocol StorageServiceProtocol {
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    func save<T>(object: T, completion:((Error?) -> ())?) where T: NSManagedObject
    func update(completion:((Error?) -> ())?)
    func delete<T>(object:T,completion:((Error?) -> ())?) where T: NSManagedObject
    func currentLists(completion:((Error?) -> ())?) -> [List]?
    func archiveLists(completion:((Error?) -> ())?) -> [List]?
}

class StorageService: NSObject {
    var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
}

//MARK: - Save Objects
extension StorageService: StorageServiceProtocol {
    func save<T>(object: T, completion:((Error?) -> ())?) where T: NSManagedObject {
        do {
            self.context.insert(object)
            try context.save()
            completion?(nil)
        } catch {
            completion?(error)
        }
    }

//MARK: - Edit Objects
    func update(completion:((Error?) -> ())?) {
        do {
            try self.context.save()
            completion?(nil)
        } catch {
            completion?(error)
        }
    }

//MARK: - Delete
    func delete<T>(object:T,completion:((Error?) -> ())?) where T: NSManagedObject {
        do {
            self.context.delete(object)
            try self.context.save()
            completion?(nil)
        } catch {
            completion?(error)
        }
    }

//MARK: - Fetch
    func currentLists(completion:((Error?) -> ())?) -> [List]? {
        do {
            let objects = try self.context.fetch(List.fetchRequest() as NSFetchRequest<List>)
            completion?(nil)
            return objects.filter({ (list) -> Bool in
                list.archivedDate == nil && list.createdDate != nil
            }).sorted(by: {
                if let first = $0.createdDate, let second = $1.createdDate {
                    return first < second
                } else {
                    return false
                }
            })
        } catch {
            completion?(error)
            return nil
        }
    }
    
    func archiveLists(completion:((Error?) -> ())?) -> [List]? {
        do {
            let objects = try self.context.fetch(List.fetchRequest() as NSFetchRequest<List>)
            completion?(nil)
            return objects.filter({ (list) -> Bool in
                list.archivedDate != nil
            }).sorted(by: {
                if let first = $0.archivedDate, let second = $1.archivedDate {
                    return first < second
                } else {
                    return false
                }
            })
        } catch {
            completion?(error)
            return nil
        }
    }
}
