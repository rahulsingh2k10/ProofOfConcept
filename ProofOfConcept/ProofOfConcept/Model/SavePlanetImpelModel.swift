//
//  SavePlanetImpelModel.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit
import CoreData

let PLANET_ENTITY_NAME = "Planet"
let PLANET_NAME = "name"
let PLANET_POPULATION = "population"
let PLANET_CLIMATE = "climate"
let PLANET_TERRAIN = "terrain"

class SavePlanetImpelModel: NSObject {
    /**
      * This method saves the JSON Response to the Core Data

     - Parameter dictionary: The JSON dictionary retreived from the service.
      */
    @discardableResult public func save(dictionary: NSDictionary) -> Bool {
        if let rowDict = dictionary["results"] as? NSArray {
            let planetCoreDataModel = PlanetCoreDataModel()

            for dict in rowDict {
                guard let pDetail = dict as? NSDictionary else {
                    return false
                }

                guard let planetName = pDetail[PLANET_NAME] as? String, !planetName.isEmpty else {
                    return false
                }

                if !isExist(pName: planetName) {
                    planetCoreDataModel.createPlanetEntity(dictionary: dict as! NSDictionary)
                }
            }

            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext

            do {
                try context.save()
                return true
            } catch {
                print("Save Failed")
                return false
            }
        } else {
            return false
        }
    }

    /**
      * This method validates whether the **Planet** already exisits in the Database.
        If it does, then it returns **True** else returns **False**.

     - Parameter pName: The name of the **Planet**
     - Returns: Boolean value.
      */
    public func isExist(pName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: PLANET_ENTITY_NAME)
        let predicateString = "\(PLANET_NAME) LIKE[CD] '\(pName)'"
        let predicate = NSPredicate(format: predicateString)
        fetchRequest.predicate = predicate

        let res = try! managedObjectContext().fetch(fetchRequest)
        return res.count > 0 ? true : false
    }

    // MARK: - Private Methods -
    /**
      * This method returns the current Managed Object Context

     - Returns: The **NSManagedObjectContext** object.
      */
    private func managedObjectContext() -> NSManagedObjectContext {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext

        return context
    }
}


class PlanetCoreDataModel: NSObject {
    /**
      * This method creates the **Planet** NSManagedObject based on the dictonary. This method has
        **@discardableResult** at the beginning which means that the return value can be ignored.

     - Parameter dictionary: The JSON dictionary retreived from the service.
     - Returns: The **Planet**'s NSManagedObject object.
      */
    @discardableResult func createPlanetEntity(dictionary: NSDictionary) -> NSManagedObject {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: PLANET_ENTITY_NAME, in: context)

        let planet = NSManagedObject(entity: entity!, insertInto: context)
        planet.setValue(dictionary[PLANET_NAME] as? String, forKey: PLANET_NAME)
        planet.setValue(dictionary[PLANET_POPULATION] as? NSNumber, forKey: PLANET_POPULATION)
        planet.setValue(dictionary[PLANET_CLIMATE] as? String, forKey: PLANET_CLIMATE)
        planet.setValue(dictionary[PLANET_TERRAIN] as? String, forKey: PLANET_TERRAIN)

        return planet
    }
}
