//
//  SplashModel.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import Foundation
struct SplashModel: Codable {
  
    let passwordMinCount, androidAppVersion, iosAppVersion, androidVersionUpdate: String
    let iosVersionUpdate, currency, currencyID, vat: String?
    let commission: String?
    let cashbackDays, makeAnOfferDiscount: String?
    
    enum CodingKeys: String, CodingKey {
        case passwordMinCount = "password_min_count"
        case androidAppVersion = "android_app_version"
        case iosAppVersion = "ios_app_version"
        case androidVersionUpdate = "android_version_update"
        case iosVersionUpdate = "ios_version_update"
        case currency
        case currencyID = "currency_id"
        case cashbackDays = "cashback_days"
        case vat, commission
        case makeAnOfferDiscount = "make_an_offer_discount"
    }
}


