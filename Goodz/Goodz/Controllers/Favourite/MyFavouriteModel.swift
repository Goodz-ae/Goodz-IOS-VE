//
//  MyFavouriteModel.swift
//  Goodz
//
//  Created by Akruti on 04/01/24.
//

import Foundation
struct MyFavouriteModel : Codable {
    let productID: String?
    let productImage: String?
    let likecount, productName, brand, storeName: String?
    let price, newPrice, isOwner: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productImage = "product_image"
        case likecount
        case productName = "product_name"
        case brand
        case storeName = "store_name"
        case price = "original_price"
        case newPrice = "discounted_price"
        case isOwner = "is_owner"
    }
}
