//
//  Constant.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import Foundation

public enum ConnectionType {
    case none, wifi, cellular

    public var description: String {
        switch self {
        case .none:
            return "No Connection"
        case .wifi:
            return "WiFi"
        case .cellular:
            return "Cellular"
        }
    }
}

typealias TransactionDidComplete = (AnyObject?, Error?) -> ()

class Constants {
    class func runOnMainQueue(completionHandler: @escaping () -> ()) {
        DispatchQueue.main.async {
            completionHandler()
        }
    }

    class func noNetworkAvailable() -> Error {
        let error = createError(errorCode: 500,
                                errorMessage: "There seems to be an issue with the network. Please check your connection and try again.",
                                errorTitle: "Error")

        return error as Error
    }

    class func noDataFoundError() -> Error {
        let error = createError(errorCode: 404,
                                errorMessage: "No data found.",
                                errorTitle: "Error")

        return error as Error
    }
}


// MARK: - Private Methods -
extension Constants {
    private class func createError(errorCode:Int, errorMessage:String, errorTitle:String) -> Error {
        let errorMessage = NSLocalizedString(errorTitle, value: errorMessage, comment: "Message")

        let userInfo: [String : Any] = [NSLocalizedDescriptionKey : errorMessage,
                                        NSLocalizedFailureReasonErrorKey : errorMessage]
        let error = NSError.init(domain: Constants.APP_DOMIAN, code: errorCode, userInfo: userInfo)

        return error as Error
    }
}


//MARK: - Localizable Strings -
extension Constants {
    static let SORRY_TITLE = NSLocalizedString("Sorry!", comment: "Title")
    static let EMPTY_STRING = NSLocalizedString("", comment: "Message")
    static let OK_TITLE = NSLocalizedString("OK", comment: "Message")
    static let ERROR_TITLE = NSLocalizedString("Error", comment: "Title")
}


// MARK: - Constants -
extension Constants {
    static let APP_DOMIAN = "com.creativeappz.com.ProofOfConcept"
}


// MARK: - End Points -
extension Constants {
    static let BASE_URL = "https://swapi.co/api"
}


// MARK: - Notification Names -
extension Constants {
    static let NETWORK_CHANGED_NOTIFICATION_NAME = Notification.Name("NetworkChanged")
}
