//
//  AppDelegate.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let nwReachabilityManager = NetworkReachabilityManager.sharedReachabilityManager
        nwReachabilityManager.addReachabilityObserver()

        launchHomeScreen()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.saveContext()
    }

    // MARK: - Private Methods -
    private func launchHomeScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = ViewController()

        let navigationController = UINavigationController()
        navigationController.viewControllers = [rootViewController]

        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }
}
