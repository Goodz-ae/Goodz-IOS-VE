//
//  CartModel.swift
//  Goodz
//
//  Created by Akruti on 22/01/24.
//

import Foundation


struct CartModel: Codable {
    let products: [CartProductModel]?
    let subtotal, couponPrice, deliveryPrice, vatPercentage: String
    let vatPrice, totalPrice, couponAppliedMessage, walletCashbackBalance: String
    let goodzWalletCashback, remaimingWalletCashbackBalance: String
    let address: [MyAddressModel]?
    
    enum CodingKeys: String, CodingKey {
        case products, subtotal
        case couponPrice = "coupon_price"
        case deliveryPrice = "delivery_price"
        case vatPercentage = "vat_percentage"
        case vatPrice = "vat_price"
        case totalPrice = "total_price"
        case couponAppliedMessage = "coupon_applied_message"
        case walletCashbackBalance = "wallet_cashback_balance"
        case goodzWalletCashback = "goodz_wallet_cashback"
        case remaimingWalletCashbackBalance = "remaiming_wallet_cashback_balance"
        case address
    }
}

struct CartProductModel : Codable {
    let cartID, productID, productName, deliveryMethodsID: String?
    let selectedDeliveryMethodsID: String?
    let deliveryTypeList: [DeliveryTypeList]?
    let brand, price, originalPrice: String?
    let productImage: String?
    
    enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
        case productID = "product_id"
        case productName = "product_name"
        case deliveryMethodsID = "delivery_methods_id"
        case selectedDeliveryMethodsID = "selected_delivery_methods_id"
        case deliveryTypeList = "delivery_type_list"
        case brand
        case price = "discounted_price"
        case originalPrice = "original_price"
        case productImage = "product_image"
    }
}

struct DeliveryTypeList: Codable {
    let deliveryMethodID, title, price: String?
    
    enum CodingKeys: String, CodingKey {
        case deliveryMethodID = "delivery_method_id"
        case title, price
    }
}

struct AddOrderModel: Codable {
    let orderID, uniqueOrderID, storeID, chatId: String?
    let deliveryMethod, goodzWalletCashback, totalPrice, subTotal: String?
    let isFromChat: String?
    let redirectURL: String?
    let successURL, cancelURL, declinedURL: String?
    let bundleID, addressID : String?
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case uniqueOrderID = "unique_order_id"
        case storeID = "store_id"
        case chatId = "chat_id"
        case deliveryMethod = "delivery_method"
        case goodzWalletCashback = "goodz_wallet_cashback"
        case totalPrice, subTotal
        case isFromChat = "is_from_chat"
        case redirectURL = "redirect_url"
        case successURL = "success_url"
        case cancelURL = "cancel_url"
        case declinedURL = "declined_url"
        case bundleID = "bundle_id"
        case addressID = "address_id"
    }
}
