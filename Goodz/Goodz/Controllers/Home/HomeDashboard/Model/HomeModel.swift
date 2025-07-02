//
//  HomeModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 11/12/23.
//

import UIKit

public enum GoodsType: String {
    case buy
    case sell
}

/// Categories Data
class CategoryData {
    let icon: UIImage?
    let title: String
    var isSelected: Bool?
    init(icon: UIImage?, title: String, isSelected: Bool? = nil) {
        self.icon = icon
        self.title = title
        self.isSelected = isSelected
    }
    
}

struct BuySellFurnitureData {
    var background: String
    let title: String
    let goodsType: GoodsType
    
    static func arrCategories() -> [BuySellFurnitureData] {
        return [
            BuySellFurnitureData(background: "", title: Labels.giveASecondLifeToYourFurniture, goodsType: .sell),
            BuySellFurnitureData(background: "", title: Labels.findTheBestDealsOfTheMarket, goodsType: .buy)
        ]
    }
}


// api model

struct HomeModel: Codable {
    let code, message: String?
    let sellBannerImg, buyBannerImg: String?
    let totalRecords, totalPopularStoreRecord: String?
    let result: [HomeData]?
    
    enum CodingKeys: String, CodingKey {
        case code, message
        case sellBannerImg = "sell_banner_img"
        case buyBannerImg = "buy_banner_img"
        case totalRecords = "total_records"
        case totalPopularStoreRecord = "total_popular_store_record"
        case result
    }
}

struct HomeData: Codable {
    let type, title, redirectType, categoryID: String?
    let subcategoryID, subSubcategoryID: String?
    let productList: [ProductList]?
    let latest_arrivals : [ProductList]?
    
    let productID: String?
    let bannerImgurl: String?
    let totalSavedWoodKg, redirectionURL, redirectionID: String?
    let storeList: [StoreList]?
    
    enum CodingKeys: String, CodingKey {
        case type, title
        case redirectType = "redirect_type"
        case categoryID = "category_id"
        case subcategoryID = "subcategory_id"
        case subSubcategoryID = "sub_subcategory_id"
        case productList = "product_list"
        case productID = "product_id"
        case bannerImgurl = "banner_imgurl"
        case totalSavedWoodKg = "total_saved_wood_kg"
        case redirectionURL = "redirection_url"
        case redirectionID = "redirection_id"
        case latest_arrivals = "latest_arrivals"
        case storeList = "store_list"
    }
}

struct ProductList: Codable {
    let imgProduct: String?
    let name, brandName, price, discountedPrice: String?
    var isLike, totalLike, productID, isOwner: String?
    
    enum CodingKeys: String, CodingKey {
        case imgProduct = "product_img"
        case name = "product_name"
        case brandName = "brand"
        case price = "original_price"
        case discountedPrice = "discounted_price"
        case isLike = "is_fav"
        case totalLike = "total_like"
        case productID = "product_id"
        case isOwner = "is_owner"
    }
}

struct StoreList: Codable {
    let storeName, storeID, storeRate, storeItems: String?
    let storeImg, isFollow, numberOfReviews, isGoodzPro: String?
    let productList: [ProductList]?
    let newArrivalList: [ProductList]?
    
    enum CodingKeys: String, CodingKey {
        case storeName = "store_name"
        case storeID = "store_id"
        case storeRate = "store_rate"
        case storeItems = "store_items"
        case storeImg = "store_img"
        case productList = "product_list"
        case newArrivalList = "new_arrival_list"
        case isFollow = "is_follow"
        case numberOfReviews = "number_of_reviews"
        case isGoodzPro = "is_goodz_pro"
    }
}
