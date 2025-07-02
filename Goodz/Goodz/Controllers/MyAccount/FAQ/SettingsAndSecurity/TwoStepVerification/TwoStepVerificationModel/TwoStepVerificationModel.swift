//
//  TwoStepVerificationModel.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 28/02/24.
//

import Foundation

// MARK: - Result
struct TwoStepVerificationModel: Codable {
    let mobileNo, isVerified: String?
    let isProtectLogin: String?

    enum CodingKeys: String, CodingKey {
        case mobileNo = "mobile_no"
        case isVerified = "is_verified"
        case isProtectLogin = "is_protect_login"
    }
}
