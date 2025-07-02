//
//  UserSessionManager.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 03/03/25.
//

import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()
    
    private let biometricKey = "AuthToken"
    private let emailKey = "UserEmail"
    private let passwordKey = "UserPassword"
    private let userNameKey = "UserName"
    private let userImageKey = "UserImage"
    private let isBiometricEnabledKey = "isBiometricEnabled"

    // Save authentication details securely
    func saveUserSession(token: String, email: String, password: String,username: String,userImage: String, enableBiometric: Bool) {
        if let tokenData = token.data(using: .utf8) {
            KeychainHelper.shared.save(tokenData, forKey: biometricKey)
        }
        if let emailData = email.data(using: .utf8) {
            KeychainHelper.shared.save(emailData, forKey: emailKey)
        }
        if let passwordData = password.data(using: .utf8) {
            KeychainHelper.shared.save(passwordData, forKey: passwordKey)
        }
        if let usernameData = username.data(using: .utf8) {
            KeychainHelper.shared.save(usernameData, forKey: userNameKey)
        }
        if let userImageData = userImage.data(using: .utf8) {
            KeychainHelper.shared.save(userImageData, forKey: userImageKey)
        }
        let biometricData = Data([enableBiometric ? 1 : 0])
        KeychainHelper.shared.save(biometricData, forKey: isBiometricEnabledKey)
        
        UserDefaults.isBiometricOn = enableBiometric
    }
    
    func saveBioMetric(enableBiometric: Bool) {
        let biometricData = Data([enableBiometric ? 1 : 0])
        KeychainHelper.shared.save(biometricData, forKey: isBiometricEnabledKey)
        
        UserDefaults.isBiometricOn = enableBiometric
    }

    // Retrieve stored token for biometric login
    func getSavedToken() -> String? {
        guard let tokenData = KeychainHelper.shared.retrieve(forKey: biometricKey),
              let token = String(data: tokenData, encoding: .utf8) else {
            return nil
        }
        return token
    }

    // Retrieve stored email
    func getSavedEmail() -> String? {
        guard let emailData = KeychainHelper.shared.retrieve(forKey: emailKey),
              let email = String(data: emailData, encoding: .utf8) else {
            return nil
        }
        return email
    }

    // Retrieve stored password
    func getSavedPassword() -> String? {
        guard let passwordData = KeychainHelper.shared.retrieve(forKey: passwordKey),
              let password = String(data: passwordData, encoding: .utf8) else {
            return nil
        }
        return password
    }
    
    // Retrieve stored username
    func getSavedUsername() -> String? {
        guard let usernameData = KeychainHelper.shared.retrieve(forKey: userNameKey),
              let username = String(data: usernameData, encoding: .utf8) else {
            return nil
        }
        return username
    }
    
    // Retrieve stored userImage
    func getSavedUserImage() -> String? {
        guard let userImageData = KeychainHelper.shared.retrieve(forKey: userImageKey),
              let userImage = String(data: userImageData, encoding: .utf8) else {
            return nil
        }
        return userImage
    }

    // Check if biometric login is enabled
    func isBiometricLoginEnabled() -> Bool {
        return UserDefaults.isBiometricOn
    }
    
    // Retrive Biometric status
    func getBiometricStatus() -> Bool {
        if let data = KeychainHelper.shared.read(forKey: isBiometricEnabledKey), let firstByte = data.first {
            return firstByte == 1
        }
        return false
    }

    // Log out user
    func logout() {
        UserDefaults.standard.removeObject(forKey: "UserSession")

        // Keep credentials only if biometric login is enabled
        if !isBiometricLoginEnabled() {
            KeychainHelper.shared.delete(forKey: biometricKey)
            KeychainHelper.shared.delete(forKey: emailKey)
            KeychainHelper.shared.delete(forKey: passwordKey)
            KeychainHelper.shared.delete(forKey: userNameKey)
            KeychainHelper.shared.delete(forKey: userImageKey)
            KeychainHelper.shared.delete(forKey: isBiometricEnabledKey)
        }
    }
    
    // Delete user
    func Delete() {
        UserDefaults.standard.removeObject(forKey: "UserSession")

        KeychainHelper.shared.delete(forKey: biometricKey)
        KeychainHelper.shared.delete(forKey: emailKey)
        KeychainHelper.shared.delete(forKey: passwordKey)
        KeychainHelper.shared.delete(forKey: userNameKey)
        KeychainHelper.shared.delete(forKey: userImageKey)
        KeychainHelper.shared.delete(forKey: isBiometricEnabledKey)
    }
}
