//
//  ProductDetailModel.swift
//  Goodz
//
//  Created by Akruti on 16/01/24.
//

import Foundation
struct ProductDetailsModel: Codable {
    let store: Store?
    let product: Product?
    let productImgs: [ProductImg]?
    let description: [Description]?
    let pickupAddress: MyAddressModel?
    let deliveryMethod: [DeliveryMethod]?
    let productDimension: [ProductDimension]?
    let productKpis: [ProductKpis]?
    let deeplink: String?
    
    
    enum CodingKeys: String, CodingKey {
        case store, product
        case productImgs = "product_imgs"
        case description
        case deeplink = "deeplink"
        case pickupAddress = "pickup_address"
        case deliveryMethod = "delivery_method"
        case productDimension = "product_dimension"
        case productKpis = "product_kpis"
    }
}

struct DeliveryMethod: Codable {
    let name: String?
}

struct Description: Codable {
    let title, description, title_condition : String?
}

struct Product: Codable {
    let productName, description, categoryID, category: String?
    let subCategory, subSubCategoryID, subSubCategory, typeOfDelivery: String?
    let invoice, warranty, totalLike, isPin: String?
    let salePrice, originalPrice, isBoosted, isLike, isHide, equirectangularImageUrl, isSold : String?
    let brandName, numberOfPayment, amount, typeOfDeliveryName, isProductVerified, qty, isGoodzPro, isOfferSend,isOfferStatus: String?
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case description
        case categoryID = "category_id"
        case category
        case subCategory = "sub_category"
        case subSubCategoryID = "sub_sub_category_id"
        case subSubCategory = "sub_sub_category"
        case typeOfDelivery = "type_of_delivery"
        case typeOfDeliveryName = "type_of_delivery_name"
        case invoice, warranty
        case totalLike = "total_like"
        case isPin
        case salePrice = "discounted_price"
        case originalPrice = "original_price"
        case isBoosted, isLike
        case isHide = "isHide"
        case equirectangularImageUrl = "equirectangular_image_url"
        case isSold = "isSold"
        case  brandName = "brand_name"
        case  numberOfPayment = "number_of_payment"
        case  amount = "amount"
        case isProductVerified = "is_product_verified"
        case qty = "qty"
        case isGoodzPro = "is_goodz_pro"
        case isOfferSend = "is_offer_send"
        case isOfferStatus = "is_offer_status"
    }
}

struct ProductDimension: Codable {
    let height, width, length, weight: String?
}

struct ProductImg: Codable {
    let productImg, mediaType: String?
    
    enum CodingKeys: String, CodingKey {
        case productImg = "product_img"
        case mediaType = "media_type"
    }
    
    func toSellItemUploadMediaModel() -> SellItemUploadMediaModel {
        return SellItemUploadMediaModel(productMediaURL: self.productImg, productMediaName: URL(string: self.productImg ?? "")?.lastPathComponent, mediaType: self.mediaType)
    }
}

struct Store: Codable {
    let storeID, storeName: String?
    let storeImage: String?
    let storeRate, totalItems, saleTotalItem, storeOwnerID, storeReview: String?
    let isPro, numberOfReviews: String?
    
    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case storeName = "store_name"
        case storeImage = "store_image"
        case storeRate = "store_rate"
        case totalItems = "total_items"
        case saleTotalItem = "sale_total_item"
        case storeOwnerID = "store_owner_id"
        case isPro
        case storeReview = "store_review"
        case numberOfReviews = "number_of_reviews"
    }
}

struct SimilarProductModel: Codable {
    let productID, productName, price, newPrice: String?
    let brand, brandID: String?
    let productImg: String?
    var isFav, totalLike, isOwner: String?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case price = "original_price"
        case newPrice = "discounted_price"
        case brand
        case brandID = "brand_id"
        case productImg = "product_img"
        case isFav = "is_fav"
        case totalLike = "total_like"
        case isOwner = "is_owner"
    }
}


struct StoreMainModel: Codable {
    let storeID, storeName: String?
    let storeImage: String?
    let storeRate, totalItems, saleTotalItem, storeOwnerID: String?
    let isPro: String?
    
    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case storeName = "store_name"
        case storeImage = "store_image"
        case storeRate = "store_rate"
        case totalItems = "total_items"
        case saleTotalItem = "sale_total_item"
        case storeOwnerID = "store_owner_id"
        case isPro
    }
}

struct ProductMainModel: Codable {
    let productID, productName, price, newPrice: String?
    let brand, brandID: String?
    let productImg: String?
    let isFav, totalLike, isOwner: String?
    let storeImage: String?
    let likecount, pruductName, storeName, discountPrice: String?
    let isAdded ,isPin, isBoost: String?
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case price
        case newPrice = "new_price"
        case brand
        case brandID = "brand_id"
        case productImg = "product_img"
        case isFav = "is_fav"
        case totalLike = "total_like"
        case isOwner = "is_owner"
        case storeImage = "store_image"
        case likecount
        case pruductName = "pruduct_name"
        case storeName = "store_name"
        case discountPrice = "discount_price"
        case isAdded
        case isPin = "is_pin"
        case isBoost = "is_boost"
    }
}

struct ProductKpis: Codable {
    let icon, value, description : String?
}
