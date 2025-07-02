//
//  ForgotPasswordModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 04/01/24.
//

import Foundation

// MARK: - Forgot Password
struct ForgotPasswordModel: Codable {
    let otp, userID, mobileNo: String?
    
    enum CodingKeys: String, CodingKey {
        case otp
        case userID = "user_id"
        case mobileNo = "mobile_no"
    }
}
