//
//  AppConstant.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit

struct AppConstants {
    static let serverURL: String = "@{serverURL}"
}

public var screenWidth = UIScreen.main.bounds.width
public var screenHeight = UIScreen.main.bounds.height

/// Enum to check for coin transfer modules
enum CoinList {
    case send
    case buy
    case receive
    case receiveNFT
}

// MARK: Global function to set any screen as root
public func setRootViewController(viewController: UIViewController) {
    let appDelegate = UIApplication.shared.delegate as? SceneDelegate
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.setNavigationBarHidden(true, animated: true)
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        appDelegate?.window = windowScene.windows.first
    }
    appDelegate?.window?.makeKeyAndVisible()
    appDelegate?.window?.rootViewController = navigationController
}
