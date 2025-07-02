//
//  CommonAlert.swift
//  Goodz
//
//  Created by Priyanka Poojara on 03/11/23.
//

import UIKit

class CommonNotifier: NSObject {
    
    static let shared = CommonNotifier()
    
    private override init() {}
    
    func showLoader() {
        if let viewCon = UIApplication.getTopViewController() {
            viewCon.view.endEditing(true)
//            DGProgressView.shared.showLoader(showTo: viewCon.view)
          viewCon.startLoader()
        }
    }
    
    func hideLoader() {
        if let viewCon = UIApplication.getTopViewController() {
            viewCon.view.endEditing(true)
//            DGProgressView.shared.hideLoader()
          viewCon.stopLoader()
        }
    }
    
    func showToast(message: String) {
        if !message.isEmpty {
            if let viewCon = UIApplication.getTopViewController() {
                viewCon.view.endEditing(true)
                viewCon.showToast(message: message, font: AppFont.medium(.size18).value)
            }
        }
    }
    
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            alertViewController.addAction(alertAction)
         }
         // iPad Support
         alertViewController.popoverPresentationController?.sourceView = viewController.view
         
         viewController.present(alertViewController, animated: true, completion: nil)
        }
    
    func showAlert(title: String? = nil, message: String, okTitle: String = "Ok", cancelTitle: String? = nil, dismissTitle: String? = nil, okAction: ((_: UIAlertAction) -> Void)? = nil, cancelAction: ((_: UIAlertAction) -> Void)? = nil) {
        if let viewCon = UIApplication.getTopViewController() {
            viewCon.view.endEditing(true)
            
            var okHandler = okAction
            var cancelHandler = cancelAction
            
            var titleString = title
            
            if okHandler == nil { okHandler = {_ in } }
            if cancelHandler == nil { cancelHandler = {_ in } }
            
            if titleString == nil { titleString = "" }
            
            let alertView = UIAlertController(title: titleString, message: message, preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title: okTitle, style: .default, handler: okHandler))
            
            if let cancelTitleString = cancelTitle {
                alertView.addAction(UIAlertAction(title: cancelTitleString, style: .default, handler: cancelHandler))
            }
            
            if let dismissTitleString = dismissTitle {
                alertView.addAction(UIAlertAction(title: dismissTitleString, style: .default))
            }
            
            viewCon.present(alertView, animated: true, completion: nil)
        }
    }
    
//    func showCameraPermissionAlert() {
//        showAlert(message: StringConstants.CommonAlert.cameraPermissionAlert)
//    }
//    
//    func showPhotosPermissionAlert() {
//        showAlert(message: StringConstants.CommonAlert.photosPermissionAlert)
//    }
//    
//    func showOfflineAlert() {
//        showAlert(message: StringConstants.CommonAlert.offlineAlert)
//    }
    
    func showAuthorizationPermissionAlert(option: String) {
        showAlert(message: "Please enable \(option) in privacy settings", okAction: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        })
    }
    
    func showAlertForInvalidSession() {
        showAlert(title: NSLocalizedString("INVALID SESSION", comment: ""), message: NSLocalizedString("Your session has been expired. Kindly login again", comment: ""), okAction: { _ in
            // AK Change - move accordingly
        })
    }
}
