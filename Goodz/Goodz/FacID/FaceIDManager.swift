//
//  FaceIDManager.swift
//  Goodz
//
//  Created by Dipesh on 29/01/25.
//

import LocalAuthentication
import UIKit

// MARK: - FaceID & TouchID Manager
class FaceIDManager {
    static let shared = FaceIDManager()
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
   
    var state = AuthenticationState.loggedout
    
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
                    self.state = .loggedin
                    completion(true, nil)
                } else if let error = error as? LAError, error.code == .userCancel {
                    print("User canceled Face ID. Retrying...")
                    self.authenticateUser(completion: completion) // Retry authentication
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
    /*
    
    let isBio = UserDefaults.isBiometricOn
    if isBio {
        appUserDefaults.set(false, forKey: Labels.HasAuthenticatedWithFaceID)
    }
    
    */
    
    
    func facIDVerify(){
        let isBio = UserDefaults.isBiometricOn
        if isBio {
            checkFaceIDAuthentication()
        }
    }
            
     private func checkFaceIDAuthentication() {
        
        guard state == .loggedout else  {return}
        
        if UserDefaults.isLogin && !UserDefaults.accessToken.isEmpty {
            let hasAuthenticated = UserDefaults.HasAuthenticatedWithFaceID
            
            // Run Face ID only if the user hasn't authenticated in this session
            if !hasAuthenticated {
                authenticateUser { success, errorMessage in
                    if success {
                        appUserDefaults.set(true, forKey: Labels.HasAuthenticatedWithFaceID)
                    } else {
                        print(Labels.authFailed)
                    }
                }
            }
        }
    }
}
