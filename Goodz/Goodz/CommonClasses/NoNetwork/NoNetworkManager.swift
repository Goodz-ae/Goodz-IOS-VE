//
//  NoNetworkManager.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 19/04/24.
//

import Foundation
import Reachability

let NETWORK = NoNetworkManager.sharedInstance

class NoNetworkManager: NSObject {

    var reachability: Reachability!
    
    static let sharedInstance: NoNetworkManager = { return NoNetworkManager() }()
    
    
    override init() {
        super.init()

        reachability = try! Reachability()
        reachability.allowsCellularConnection = true

        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            try (NoNetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }

    static func isReachable(completed: @escaping (NoNetworkManager) -> Void) {
        if (NoNetworkManager.sharedInstance.reachability).connection != .unavailable {
            completed(NoNetworkManager.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (NoNetworkManager) -> Void) {
        if (NoNetworkManager.sharedInstance.reachability).connection == .unavailable {
            completed(NoNetworkManager.sharedInstance)
        }
    }
    
    static func isReachableViaWWAN(completed: @escaping (NoNetworkManager) -> Void) {
        if (NoNetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NoNetworkManager.sharedInstance)
        }
    }

    static func isReachableViaWiFi(completed: @escaping (NoNetworkManager) -> Void) {
        if (NoNetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NoNetworkManager.sharedInstance)
        }
    }
}
