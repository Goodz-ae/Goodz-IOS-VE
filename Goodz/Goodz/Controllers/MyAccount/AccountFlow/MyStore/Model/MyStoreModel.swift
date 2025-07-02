//
//  MyStoreModel.swift
//  Goodz
//
//  Created by Akruti on 09/01/24.
//

import Foundation
struct StoreModel: Codable {
    let storeID: String?
    let storeImage: String?
    let storeOwnerName, storeRating, numberOfProducts : String?
    let numberOfReviews, isGoodzPro: String?
    
    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case storeImage = "store_image"
        case storeOwnerName = "store_owner_name"
        case storeRating = "store_rating"
        case numberOfProducts = "number_of_products"
        case numberOfReviews = "number_of_reviews"
        case isGoodzPro = "is_goodz_pro"
    }
}

class StoreDetailsModel: Codable {
    let storeID, addressID, cityTitle, areaTitle: String?
        let cityID, areaID: String?
        let storeImage: String?
        let storeOwnerName, storeDescription, storeRating, isFollow: String?
        let numberOfReviews, highestDiscount, isGoodzPro: String?
        let productList: [ProductListModel]?
        let discount: [Discount]?

        enum CodingKeys: String, CodingKey {
            case storeID = "store_id"
            case addressID = "address_id"
            case cityTitle = "city_title"
            case areaTitle = "area_title"
            case cityID = "city_id"
            case areaID = "area_id"
            case storeImage = "store_image"
            case storeOwnerName = "store_owner_name"
            case storeDescription = "store_description"
            case storeRating = "store_rating"
            case isFollow = "is_follow"
            case numberOfReviews = "number_of_reviews"
            case highestDiscount = "highest_discount"
            case productList = "product_list"
            case discount
            case isGoodzPro = "is_goodz_pro"
        }
}

class ProductListModel: Codable {
    
    let productID, productName,pruductName, brand, totalLike: String?
    let discountedPrice, originalPrice: String?
    let productImg: String?
    let isFav, isPin, isBoost: String?
    let isHidden,isProductVerified: String?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case brand
        case totalLike = "total_like"
        case discountedPrice = "discounted_price"
        case originalPrice = "original_price"
        case productImg = "product_img"
        case isFav = "is_fav"
        case isPin = "is_pin"
        case isBoost = "is_boost"
        case isHidden = "is_hidden"
        case pruductName = "pruduct_name"
        case isProductVerified = "is_product_verified"
    }
    internal init(productID: String? = nil, productName: String? = nil, brand: String? = nil, totalLike: String? = nil, discountedPrice: String? = nil, originalPrice: String? = nil, productImg: String? = nil, isFav: String? = nil, isPin: String? = nil, isBoost: String? = nil, isHidden: String? = nil, pruductName: String? = nil, isProductVerified : String? = nil) {
        self.productID = productID
        self.productName = productName
        self.brand = brand
        self.totalLike = totalLike
        self.discountedPrice = discountedPrice
        self.originalPrice = originalPrice
        self.productImg = productImg
        self.isFav = isFav
        self.isPin = isPin
        self.isBoost = isBoost
        self.isHidden = isHidden
        self.pruductName = pruductName
        self.isProductVerified = isProductVerified
    }
}

struct StoreReviewModel: Codable {
    let userID, reviewID, userName: String?
    let userProfile: String?
    let dateOfReview, rating, reviewDescription, isReply, storeID: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case reviewID = "review_id"
        case userName = "user_name"
        case userProfile = "user_profile"
        case dateOfReview = "date_of_review"
        case rating
        case reviewDescription = "review_description"
        case isReply = "is_reply"
        case storeID = "store_id"
        
    }
}

struct StoreFollowerModel: Codable {
    let userID, storeID, userName: String?
    let userProfile: String?
    let rating, followStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case storeID = "store_id"
        case userName = "user_name"
        case userProfile = "user_profile"
        case rating
        case followStatus = "follow_status"
    }
}

struct Discount: Codable {
    let firstStageAmount, firstStageDiscount, secondStageAmount, secondStageDiscount: String?
    let thirdStageAmount, thirdStageDiscount: String?

    enum CodingKeys: String, CodingKey {
        case firstStageAmount = "first_stage_amount"
        case firstStageDiscount = "first_stage_discount"
        case secondStageAmount = "second_stage_amount"
        case secondStageDiscount = "second_stage_discount"
        case thirdStageAmount = "third_stage_amount"
        case thirdStageDiscount = "third_stage_discount"
    }
}

// my store
struct MyStoreModel: Codable {
    let storeID, cityTitle, areaTitle, cityID: String?
    let areaID: String?
    let storeImage: String?
    let storeOwnerName, storeDescription, storeRating, numberOfProducts, numberOfReviews: String?
    let productList: [ProductListModel]?

    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case cityTitle = "city_title"
        case areaTitle = "area_title"
        case cityID = "city_id"
        case areaID = "area_id"
        case storeImage = "store_image"
        case storeOwnerName = "store_owner_name"
        case storeDescription = "store_description"
        case storeRating = "store_rating"
        case numberOfProducts = "number_of_products"
        case productList = "product_list"
        case numberOfReviews = "number_of_reviews"
    }
}


