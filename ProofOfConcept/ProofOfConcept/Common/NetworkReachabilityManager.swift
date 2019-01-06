//
//  NetworkReachabilityManager.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit
import Reachability

let HOST_NAME = "www.google.com"

final class NetworkReachabilityManager: NSObject {
    public var connectionType: ConnectionType = .none
    private let reachability = Reachability(hostname: HOST_NAME)

    public static let sharedReachabilityManager: NetworkReachabilityManager = {
        let networkReachability = NetworkReachabilityManager()

        return networkReachability
    }()

    // MARK: - Public Methods -
    public func addReachabilityObserver() {
        reachability!.whenReachable = {[unowned self] reachability in
            if reachability.connection == .wifi {
                self.connectionType = .wifi
            } else {
                self.connectionType = .cellular
            }

            print("####################\nNetwork Connection Type: \(self.connectionType.description)")
            NotificationCenter.default.post(name: Constants.NETWORK_CHANGED_NOTIFICATION_NAME,
                                            object: self.connectionType)
        }

        reachability!.whenUnreachable = {[unowned self] reachability in
            self.connectionType = .none

            print("####################\nNetwork Not Reachable")
            NotificationCenter.default.post(name: Constants.NETWORK_CHANGED_NOTIFICATION_NAME,
                                            object: self.connectionType)
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
}
