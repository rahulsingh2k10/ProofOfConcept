//
//  CoreDataManager.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 06/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit
import CoreData

let CORE_DATA_MODEL_NAME = "ProofOfConcept"

class CoreDataManager: NSObject {
    public static let sharedInstance: CoreDataManager = {
        let cdManager = CoreDataManager()

        return cdManager
    }()

    /*
     * The persistent container for the application. This implementation
     * creates and returns a container, having loaded the store for the
     * application to it. This property is optional since there are legitimate
     * error conditions that could cause the creation of the store to fail.
     */
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CORE_DATA_MODEL_NAME)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection
                 * when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
