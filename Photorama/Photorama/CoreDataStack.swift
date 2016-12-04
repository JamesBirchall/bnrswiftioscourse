//
//  CoreDataStack.swift
//  Photorama
//
//  Created by James Birchall on 04/12/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let managedObjectModelName: String
    
    // model file is where we define entities for app along with properties
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        print(#function)
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private var applicationDirectoryDirectory: URL = {
       let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(#function)
        return urls.first!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        

        let pathComponent = "\(self.managedObjectModelName).sqlite"
        
        let url = self.applicationDirectoryDirectory.appendingPathComponent(pathComponent)
        
        let store: NSPersistentStore!
        
        //print(url)
        
        do {
            store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            
        } catch {
            print("Problem adding Persistent Store: \(error)")
        }
        
        print(#function)
        
        return coordinator
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        
        print(#function)
        return moc
    }()
    
    required init(modelName: String) {
        managedObjectModelName = modelName
        print(#function)
    }
    
    func saveChanges() throws {
        var error: Error?
        
        mainQueueContext.performAndWait {
            
            if self.mainQueueContext.hasChanges {
                do {
                    try self.mainQueueContext.save()
                } catch let saveError {
                    error = saveError
                }
            }
        }
        
        if let error = error {
            throw error
        }
    }
}
