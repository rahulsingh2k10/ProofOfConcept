//
//  ProofOfConceptTests.swift
//  ProofOfConceptTests
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import XCTest
import CoreData

@testable import ProofOfConcept

class ProofOfConceptTests: XCTestCase {
    let endPoint = "\(Constants.BASE_URL)\(Constants.PLANET_END_POINT)"
    var validResponse: NSDictionary?

    override func setUp() {
        super.setUp()

        if let path = Bundle.main.path(forResource: "Response", ofType: "json") {
            do {
                let responseData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                validResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as? NSDictionary
            } catch {
                print(error)
            }
        }

        sleep(5)
    }

    func testCheckNetworkConnectivityBeforeAPICall_01() {
        let checkNetworkConnectivityExpectation = expectation(description: "Check Network Connectivity")

        NetworkManager.sharedInstance.fetchData(urlString: endPoint) {(error) in
            if let err = error {
                if (err as NSError).code == 500 {
                    XCTAssertTrue(true)
                    checkNetworkConnectivityExpectation.fulfill()
                }
            } else {
                XCTAssertTrue(true)
                checkNetworkConnectivityExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: .none)
    }

    func testValidJSONResponse_02() {
        let validResponseExpectation = expectation(description: "Check Response Validity")

        NetworkManager.sharedInstance.fetchData(urlString: endPoint) {(error) in
            if error == nil {
                XCTAssertNil(error)
                validResponseExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: .none)
    }

    func testPlanetManagedObjectCreation_03() {
        let planetCoreDataModel = PlanetCoreDataModel()
        guard let vr = validResponse else {
            XCTFail("Response JSON not created.")

            return
        }

        guard let planetList = vr["results"] as? NSArray, planetList.count > 0 else {
            XCTFail("No Planet Found.")

            return
        }

        let dict = planetList.firstObject as! NSDictionary
        let planetManagedObject = planetCoreDataModel.createPlanetEntity(dictionary:dict)
        let name = planetManagedObject.value(forKey: PLANET_NAME) as? String

        XCTAssertNotNil(name, "Planet's Name cannot be nil")
    }

    func testDuplicatePlanetAddition_04() {
        let savePlanetImpelModel = SavePlanetImpelModel()
        let planetName = "Alderaan"
        let modelExists = savePlanetImpelModel.isExist(pName:planetName)

        XCTAssertTrue(modelExists, "Planet details named '\(planetName)' doesn't exists.")
    }

    func testPlantSave_05() {
        guard let vr = validResponse else {
            XCTFail("Response JSON not created.")

            return
        }

        let savePlanetImpelModel = SavePlanetImpelModel()
        let savedSuccessfully = savePlanetImpelModel.save(dictionary: vr)

        XCTAssertTrue(savedSuccessfully, "Managed Object Context failed to saved Data.")
    }
}
