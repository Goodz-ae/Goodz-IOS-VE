//
//  CommonModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import UIKit

struct ResponseModel<T: Codable>: Codable {
    let code: String?
    let message: String?
    let result: [T]?
    let updatedDate: String?
    let totalRecords : String?
    let isBundleChat: String?
    let isSeller: String?
    let offerReceived : String?
    let paymentDone : String?
    let offerAccepted : String?
    let isSelectPickupDate : String?
    let isSelectPickupAddress : String?
    let deliveryMethod : String?
    let brandIcon : String?
    let logisticPrice : String?
    let bundleId: String?
    let bundleSellingPrice: String?
    let bundleOriginalPrice: String?
    let bundleForYouPrice: String?
    let isOfferSend: String?
    let deliveryAddress : DeliveryAddress?
    
    enum CodingKeys: String, CodingKey {
        case code, message
        case updatedDate = "updated_date"
        case result
        case totalRecords = "total_records"
        case isBundleChat = "is_bundle_chat"
        case isSeller = "is_seller"
        case offerReceived = "offer_received"
        case paymentDone = "payment_done"
        case offerAccepted = "offer_accepted"
        case isSelectPickupDate = "is_select_pickup_date"
        case isSelectPickupAddress = "is_select_pickup_address"
        case brandIcon = "brand_icon"
        case logisticPrice = "logistic_price"
        case bundleId = "bundle_id"
        case deliveryAddress = "delivery_address"
        case deliveryMethod = "delivery_method"
        case bundleSellingPrice = "bundle_selling_price"
        case bundleOriginalPrice = "bundle_original_price"
        case bundleForYouPrice = "bundle_for_you_price"
        case isOfferSend = "is_offer_send"
    }
}

struct AnyCodable: Codable {
    private let value: Codable
    
    init<T: Codable>(_ value: T) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
    
    init(from decoder: Decoder) throws {
        // Decode the underlying type based on the provided decoder
        if let intValue = try? Int(from: decoder) {
            value = intValue
        } else if let doubleValue = try? Double(from: decoder) {
            value = doubleValue
        } else if let stringValue = try? String(from: decoder) {
            value = stringValue
        } else {
            // Handle other types as needed
            throw DecodingError.typeMismatch(Codable.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type"))
        }
    }
}
struct ResponseModelOne: Codable {
    let code: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code, message
        
    }
}

struct PaymentModel: Codable {
    let code, message: String?
    let redirectURL: String?
    let successURL, cancelURL, declinedURL: String?
    let boostPlan, boostID: String?
    let productID, boostPlanID, storeID, boostPlanStore: String?

    enum CodingKeys: String, CodingKey {
        case code, message
        case redirectURL = "redirect_url"
        case successURL = "success_url"
        case cancelURL = "cancel_url"
        case declinedURL = "declined_url"
        case boostPlan = "boost_plan"
        case boostID = "boost_id"
        case productID = "product_id"
        case boostPlanID = "boost_plan_id"
        case storeID = "store_id"
        case boostPlanStore = "boost_plan_store"
    }
}
struct DeliveryAddress: Codable {
    var addressID, fullName, phoneNumber, countryCode: String
    var cityID, cityName, areaID, areaName: String
    var floor, streetAddress: String

    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case countryCode = "country_code"
        case cityID = "city_id"
        case cityName = "city_name"
        case areaID = "area_id"
        case areaName = "area_name"
        case floor
        case streetAddress = "street_address"
    }
}
