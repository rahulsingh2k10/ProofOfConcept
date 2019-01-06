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
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext

    public func save(dictionary: NSDictionary) {
        if let rowDict = dictionary["results"] as? NSArray {
            let planetCoreDataModel = PlanetCoreDataModel()
            for dict in rowDict {
                planetCoreDataModel.createPlanetEntity(dictionary: dict as! NSDictionary)
            }

            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }

    public func fetch() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PLANET_ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: PLANET_NAME) as! String)
            }
            
        } catch {
            print("Failed")
        }
    }
}


class PlanetCoreDataModel: NSObject {
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext

    @discardableResult func createPlanetEntity(dictionary: NSDictionary) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: PLANET_ENTITY_NAME, in: context)

        let planet = NSManagedObject(entity: entity!, insertInto: context)
        planet.setValue(dictionary[PLANET_NAME] as? String, forKey: PLANET_NAME)
        planet.setValue(dictionary[PLANET_POPULATION] as? NSNumber, forKey: PLANET_POPULATION)
        planet.setValue(dictionary[PLANET_CLIMATE] as? String, forKey: PLANET_CLIMATE)
        planet.setValue(dictionary[PLANET_TERRAIN] as? String, forKey: PLANET_TERRAIN)

        return planet
    }
}
