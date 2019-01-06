//
//  NetworkManager.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit

protocol ConnectionManager {
    func networkReachable() -> Error?
}


extension ConnectionManager {
    func networkReachable() -> Error? {
        let nwStatus = NetworkReachabilityManager.sharedReachabilityManager.connectionType
        guard nwStatus == .none else {
            return .none
        }

        return Constants.noNetworkAvailable()
    }
}


final class NetworkManager: NSObject, ConnectionManager {
    public static let sharedInstance: NetworkManager = {
        let nwManager = NetworkManager()

        return nwManager
    }()

    /**
      * This method fetches the data from the service.

     - Parameter urlString: The endPoint of the Transaction.
     - Parameter completionHandler: This closure gets called once the transaction is complete.
      */
    public func fetchData(urlString: String,
                          completionHandler: @escaping TransactionDidComplete) {
        let nwReachable = networkReachable()
        guard nwReachable == nil else {
            Constants.runOnMainQueue {
                completionHandler(nwReachable)
            }

            return
        }

        guard let url = URL(string: urlString) else {
            Constants.runOnMainQueue {
                completionHandler (.none)
            }

            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                Constants.runOnMainQueue {
                    completionHandler(error)
                }

                return
            }

            guard let content = data else {
                let err = Constants.noDataFoundError()
                Constants.runOnMainQueue {
                    completionHandler(err)
                }

                return
            }

            JSONParser.savePlanets(data: content)

            Constants.runOnMainQueue {
                completionHandler (.none)
            }
        }

        task.resume()
    }
}
