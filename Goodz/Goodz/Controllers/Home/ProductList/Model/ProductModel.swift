//
//  ProductModel.swift
//  Goodz
//
//  Created by Akruti on 08/01/24.
//

import Foundation

struct ProductModel: Codable {
    let productID, productName, price, newPrice: String?
    var brand, brandID, productImg, isFav: String?
    var totalLike, isOwner: String?
    
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
