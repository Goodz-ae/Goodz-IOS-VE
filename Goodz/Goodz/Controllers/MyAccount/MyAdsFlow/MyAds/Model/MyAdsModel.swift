//
//  MyAdsModel.swift
//  Goodz
//
//  Created by Akruti on 02/02/24.
//

import Foundation
struct MyAdsModel: Codable {
    let productID, productName, brandName, discountedPrice: String?
    let originalPrice: String?
    let productImage: String?
    let isBoosted, boostItemStatus, remainingDaysOfBoost: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case brandName = "brand_name"
        case discountedPrice = "discounted_price"
        case originalPrice = "original_price"
        case productImage = "product_image"
        case isBoosted = "is_boosted"
        case boostItemStatus = "boost_item_status"
        case remainingDaysOfBoost = "remaining_days_of_boost"
    }
}

struct BoostInfoModal: Codable {
    let productID, productName, brandName, discountedPrice: String?
    let originalPrice: String?
    let productImage: String?
    let isBoosted, remainingDaysOfBoost: String?
    let boostPlans: [BoostPlan]?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case brandName = "brand_name"
        case discountedPrice = "discounted_price"
        case originalPrice = "original_price"
        case productImage = "product_image"
        case isBoosted = "is_boosted"
        case remainingDaysOfBoost = "remaining_days_of_boost"
        case boostPlans = "boost_plans"
    }
}

struct BoostPlan: Codable {
    let boostPlan, clicks, price, boostID: String?
    let isBestOffer: String?

    enum CodingKeys: String, CodingKey {
        case boostPlan = "boost_plan"
        case clicks, price
        case boostID = "boost_id"
        case isBestOffer = "is_best_offer"
    }
}


struct BoostedInfoModel: Codable {
    let productID, planID, productName, brandName: String?
    let discountedPrice, originalPrice: String?
    let productImage: String?
    let totalReachCount, remainingBoostDays: String?
    let graphInfo: [GraphInfo]?
    let boostPlans: [BoostPlan]?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case planID = "plan_id"
        case productName = "product_name"
        case brandName = "brand_name"
        case discountedPrice = "discounted_price"
        case originalPrice = "original_price"
        case productImage = "product_image"
        case totalReachCount = "total_reach_count"
        case graphInfo = "graph_info"
        case boostPlans = "boost_plans"
        case remainingBoostDays = "remaining_boost_days"
    }
}

// MARK: - GraphInfo
struct GraphInfo: Codable {
    let date, reachCount: String?

    enum CodingKeys: String, CodingKey {
        case date
        case reachCount = "reach_count"
    }
}

struct BoostStoreInfoModal: Codable {
    let storeName, storeRate, followers: String?
    let storeImage, storeItem: String?
    let boostPlans: [BoostPlan]?

    enum CodingKeys: String, CodingKey {
        case storeName = "store_name"
        case storeRate = "store_rate"
        case followers
        case storeImage = "store_image"
        case boostPlans = "boost_plans"
        case storeItem = "store_item"
    }
}
struct BoostedStoreInfoModal : Codable {
    let storeName, storeRate, followers: String?
    let storeImage: String?
    let planID, daysRemaining, totalReachCount: String?
    let graphInfo: [GraphInfo]?
    let boostPlans: [BoostPlan]?

    enum CodingKeys: String, CodingKey {
        case storeName = "store_name"
        case storeRate = "store_rate"
        case followers
        case storeImage = "store_image"
        case planID = "plan_id"
        case daysRemaining = "days_remaining"
        case totalReachCount = "total_reach_count"
        case graphInfo = "graph_info"
        case boostPlans = "boost_plans"
    }
}
