//
//  AccountModel.swift
//  Goodz
//
//  Created by Akruti on 04/01/24.
//

import Foundation
struct CurrentUserModel: Codable {
    let userID, storeID, storeName, token: String?
    let fullName, firstName, lastName, username, email, isVerified: String? //fullName,
    let birthDate, mobile, countryCode: String?
    let userProfile, unreadNotification, readNotification: String?
    let isStoreBoosted, userType, documentsSubmitted, documentsValidated: String?
    let firstStageAmount, firstStageDiscount, secondStageAmount, secondStageDiscount: String?
    let thirdStageAmount, thirdStageDiscount, proRequestStatus, proPlanStartDate: String?
    let proPlanEndDate, isGoodzPro, city, area: String?
    let cityID, areaID, streetAddress, floor, isUpdateProfile, socialType: String?
    let bankAdded: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case firstName = "name"
        case lastName = "last_name"
        case bankAdded = "bankAdded"
        case userID = "user_id"
        case storeID = "store_id"
        case storeName = "store_name"
        case token
        case fullName = "full_name"
        case username, email
        case isVerified = "is_verified"
        case birthDate = "birth_date"
        case mobile
        case countryCode = "country_code"
        case userProfile = "user_profile"
        case isStoreBoosted
        case userType = "user_type"
        case documentsSubmitted, documentsValidated
        case firstStageAmount = "first_stage_amount"
        case firstStageDiscount = "first_stage_discount"
        case secondStageAmount = "second_stage_amount"
        case secondStageDiscount = "second_stage_discount"
        case thirdStageAmount = "third_stage_amount"
        case thirdStageDiscount = "third_stage_discount"
        case proRequestStatus
        case proPlanStartDate = "pro_plan_start_date"
        case proPlanEndDate = "pro_plan_end_date"
        case isGoodzPro = "is_goodz_pro"
        case city, area
        case streetAddress = "street_address"
        case floor
        case isUpdateProfile = "is_update_profile"
        case cityID = "city_id"
        case areaID = "area_id"
        case unreadNotification = "unread_notification"
        case readNotification = "read_notification"
        case socialType = "social_type"
    }
}

struct BundleDiscount : Codable {
    
    let firstStageAmount: String?
    let firstStageDiscount: String?
    let secondStageAmount: String?
    let secondStageDiscount: String?
    let thirdStageAmount: String?
    let thirdStageDiscount: String?
    
    enum CodingKeys: String, CodingKey {
        
        case firstStageAmount = "first_stage_amount"
        case firstStageDiscount = "first_stage_discount"
        case secondStageAmount = "second_stage_amount"
        case secondStageDiscount = "second_stage_discount"
        case thirdStageAmount = "third_stage_amount"
        case thirdStageDiscount = "third_stage_discount"
    }
    
}
