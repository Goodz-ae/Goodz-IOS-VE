//
//  BundleProductModel.swift
//  Goodz
//
//  Created by Akruti on 18/01/24.
//

import Foundation
struct BundleProductModel: Codable {
    let productID: String?
    let storeId: String?
    let storeImage: String?
    let likecount, pruductName, storeName, discountPrice: String?
    let price, isAdded, isFav, isOwner, brandName : String?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case storeImage = "store_image"
        case storeId = "store_id"
        case likecount
        case pruductName = "pruduct_name"
        case storeName = "store_name"
        case discountPrice = "discounted_price"
        case price = "original_price"
        case isAdded
        case isFav = "is_fav"
        case isOwner = "is_owner"
        case brandName = "brand_name"
    }
}

struct BundleProductCartModel: Codable {
    let vatPercentage, vatPrice, discountPercentage, totalPrice, deliveryPrice, isOfferSend, isOfferStatus: String?
        let discountPrice, totalPriceWithTax, walletCashbackBalance, goodzWalletCashback: String?
        let remaimingWalletCashbackBalance, bundleID, couponPrice, maxOfferPrice: String?
        let bundleAddedProductList: [BundleProductModel]?

        enum CodingKeys: String, CodingKey {
            case vatPercentage = "vat_percentage"
            case vatPrice = "vat_price"
            case discountPercentage = "discount_percentage"
            case totalPrice = "total_price"
            case discountPrice = "discount_price"
            case totalPriceWithTax = "total_price_with_tax"
            case walletCashbackBalance = "wallet_cashback_balance"
            case goodzWalletCashback = "goodz_wallet_cashback"
            case remaimingWalletCashbackBalance = "remaiming_wallet_cashback_balance"
            case bundleID = "bundle_id"
            case bundleAddedProductList = "bundle_added_product_list"
            case deliveryPrice = "delivery_price"
            case couponPrice = "coupon_price"
            case isOfferSend = "is_offer_send"
            case maxOfferPrice = "max_offer_price"
            case isOfferStatus = "is_offer_status"
        }
}
//BundleProductModel
