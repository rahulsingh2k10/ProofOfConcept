//
//  JSONParser.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit

class JSONParser: NSObject {
    /**
     This method serialises the Data to Model.

     - Parameter data: The data to be serialised to Model.
     */
    class func savePlanets(data: Data) {
        guard let dataString = NSString(data: data, encoding: String.Encoding.ascii.rawValue) else {
            return
        }

        guard let jsonData = dataString.data(using: String.Encoding.utf8.rawValue) else {
            return
        }

        guard let jsonResult = try? JSONSerialization.jsonObject(with: jsonData as Data, options: []) as! NSDictionary else {
            return
        }

        let spd = SavePlanetImpelModel()
        spd.save(dictionary: jsonResult)
    }
}
