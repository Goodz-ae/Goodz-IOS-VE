//
//  LoginModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import Foundation

// MARK: - Result
struct LoginModel: Codable {
    let userID, userType, name, email: String?
    let isVerified, mobile, countryCode, token: String?
    let userProfile: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userType = "user_type"
        case name, email
        case isVerified = "is_verified"
        case mobile
        case countryCode = "country_code"
        case token
        case userProfile = "user_profile"
    }
}


