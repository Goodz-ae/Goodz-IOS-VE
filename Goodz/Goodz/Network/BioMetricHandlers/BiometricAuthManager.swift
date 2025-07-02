//
//  BiometricAuthManager.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 03/03/25.
//

import Foundation
import LocalAuthentication
import UIKit

class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    private let context = LAContext()
    
    // Check if biometric authentication is available and permitted
    func checkBiometricPermission(completion: @escaping (Bool) -> Void) {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometrics are available, now authenticate the user
            completion(true)
        } else {
            // Biometrics not available or not permitted
            if let laError = error as? LAError, laError.code == .biometryNotEnrolled {
                // Biometry is not enrolled, ask the user to set it up
                DispatchQueue.main.async {
                    self.showBiometricSetupAlert()
                }
            }
            completion(false)
        }
    }
    
    
    private func createNewContext() -> LAContext {
        let newContext = LAContext()
        newContext.localizedFallbackTitle = "Enter Passcode" // Ensures passcode option appears
        return newContext
    }
    
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = createNewContext()
        let reason = getAuthenticationReason(context: context)

        // Use `.deviceOwnerAuthentication` to support both Biometrics & Passcode
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(success, nil)
                } else if let error = error as? LAError, error.code == .userCancel {
                    print("User canceled Face ID. Retrying...")
//                    self.authenticateUser(completion: completion) // Retry authentication
                } else {
                    completion(false, error?.localizedDescription ?? Labels.authFailed)
                }
            }
        }
    }
    
    private func getAuthenticationReason(context: LAContext) -> String {
        if context.biometryType == .faceID {
            return Labels.authenticateWithFaceID
        } else if context.biometryType == .touchID {
            return Labels.authenticateWithTouchID
        }
        return Labels.authWithBiometrics
    }
    
    // Show an alert prompting the user to enable Face ID / Touch ID
    private func showBiometricSetupAlert() {
        guard let topViewController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(
            title: "Biometric Authentication Not Set Up",
            message: "To use Face ID or Touch ID, please enable it in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        topViewController.present(alert, animated: true)
    }
    
    func showBiometricPermissionAlert() {
        guard let topViewController = UIApplication.shared.windows.first?.rootViewController else { return }

        let alert = UIAlertController(
            title: "Biometric Authentication Not Allowed",
            message: "Biometric authentication is not allowed for this app. Open settings and allow it from there.",
            preferredStyle: .alert
        )

        // Cancel Button (Does nothing)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // Open Settings Button (Navigates to app settings)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })

        topViewController.present(alert, animated: true)
    }
}
