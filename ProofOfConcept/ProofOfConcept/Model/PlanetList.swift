//
//  PlanetList.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit

class PlanetList: NSObject {
    var planetDetailList: [PlanetDetailModel]?

    init(dictionary: NSDictionary) {
        var planetList = [PlanetDetailModel]()

        if let rowDict = dictionary["results"] as? NSArray {
            for dict in rowDict {
                let rm = PlanetDetailModel.init(dictionary: dict as! NSDictionary)
                planetList.append(rm)
            }

            planetDetailList = planetList
        }
    }
}


class PlanetDetailModel: NSObject {
    public var name: String?
    public var population: NSNumber?
    public var climate: String?
    public var terrain: String?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        population = dictionary["population"] as? NSNumber
        climate = dictionary["climate"] as? String
        climate = dictionary["terrain"] as? String
    }
}
