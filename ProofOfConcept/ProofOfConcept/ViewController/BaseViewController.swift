//
//  BaseViewController.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 06/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Constants.NETWORK_CHANGED_NOTIFICATION_NAME,
                                                  object: .none)

        print("DEINIT CALLED FOR \(self)")
    }

    // MARK: - Public Methods -
    public func networkStatusUpdated(status: ConnectionType) {
        switch status {
        case .none:
            let nwError = Constants.noNetworkAvailable()
            self.presentAlert(title: Constants.SORRY_TITLE, message: nwError.localizedDescription)
        default:
            break
        }
    }

    /**
     * This method present the alert on the screen.

     - Parameter title: The title of the Alert. Defaults to empty string.
     - Parameter message: The message for the Alert.
     - Parameter button: List of Button Titles. Defaults to List of OK String.
     - Parameter alertType: Type of Alert to be presented. Defaults to .alert.
     */
    public func presentAlert(title: String? = Constants.EMPTY_STRING,
                             message: String?,
                             button: [String] = [Constants.OK_TITLE],
                             alertType: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: alertType)

        for button in button {
            let defaultAction = UIAlertAction(title: button,
                                              style: .default,
                                              handler: .none)
            alertController.addAction(defaultAction)
        }

        present(alertController, animated: true, completion: .none)
    }

    // MARK: - Public Methods -
    final private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStausChanged(_:)),
                                               name: Constants.NETWORK_CHANGED_NOTIFICATION_NAME,
                                               object: .none)
    }

    // MARK: - Notification Methods -
    @objc func networkStausChanged(_ notification: Notification) {
        let cv = NetworkReachabilityManager.sharedReachabilityManager.connectionType
        networkStatusUpdated(status: cv)
    }
}
