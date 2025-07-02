//
//  NetworkAlertMessages.swift
//  Goodz
//
//  Created by Priyanka Poojara on 06/11/23.
//

import Foundation

/// Alert Messages to be used for network error in whole app
 struct NetworkAlertMessages {
     // General Messages
     static let yes = "Yes"
     static let no = "No"
     static let cancel = "Cancel"
     static let ok = "OK"
     
     static let networkError = NSLocalizedString("Server is not responding! Please try after some time.", comment: "")
     static let internetError = NSLocalizedString("You might have lost internet connectivity", comment: "")
     static let defaultError = NSLocalizedString("Something went wrong. Please try again.", comment: "")
     static let networkTimeout = NSLocalizedString("Connection timed out or lost. \nPlease try again.", comment: "")
     static let urlConversionError = NSLocalizedString("The requested URL is invalid.", comment: "")
     static let invalidDataFormat = NSLocalizedString("The requested data is not in the correct format.", comment: "")
 }
