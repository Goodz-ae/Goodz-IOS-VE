//
//  SignUpModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import Foundation

// MARK: - Result
struct SignUpModel: Codable {
    let userID, token, email, mobile: String?
    let countryCode, otp: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token, email, mobile
        case countryCode = "country_code"
        case otp
    }
}
