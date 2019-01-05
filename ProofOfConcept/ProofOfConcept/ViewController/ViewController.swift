//
//  ViewController.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    private var planetList: PlanetList?

    override func networkStatusUpdated(status: ConnectionType) {
        super.networkStatusUpdated(status: status)

        switch status {
        case .wifi, .cellular:
            callTransaction()
        default:
            break
        }
    }

    func callTransaction() {
        let endPoint = "\(Constants.BASE_URL)/planets"
        NetworkManager.sharedInstance.fetchData(urlString: endPoint) {[unowned self] (result, error) in
            if let res = result as? PlanetList {
                self.planetList = res
            } else if let err = error {
                self.presentAlert(title: Constants.ERROR_TITLE,
                                  message: err.localizedDescription)
            }
        }
    }
}
