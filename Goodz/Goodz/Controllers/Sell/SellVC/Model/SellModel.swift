//
//  SellModel.swift
//  Goodz
//
//  Created by Akruti on 10/01/24.
//

import Foundation
struct BrandModel: Codable {
    let brandTitle, brandID, isCustomizationSelected: String?

    enum CodingKeys: String, CodingKey {
        case brandTitle = "brand_title"
        case brandID = "brand_id"
        case isCustomizationSelected = "is_customization_selected"
        
    }
}
struct ConditionModel: Codable {
    let conditionTitle, description, conditionID: String?

    enum CodingKeys: String, CodingKey {
        case conditionTitle = "condition_title"
        case description
        case conditionID = "condition_id"
    }
}

struct DeliveryMethodsModel: Codable {
    let title, deliveryMethodID, price: String?

    enum CodingKeys: String, CodingKey {
        case title
        case deliveryMethodID = "delivery_method_id"
        case price
    }
}

struct DeliveryTypeModel: Codable {
    let id: String?
    let image: String?
    let deliveryTypeName: String?

    enum CodingKeys: String, CodingKey {
        case id, image
        case deliveryTypeName = "delivery_type_name"
    }
}

struct SellItemMOdel: Codable {
        let productID, productTitle, description, quantity: String?
        let productHeight, productLength, productWidth, productWeight: String?
        let invoice: String?
        let warranty, typeOfDelivery, deliveryMethod, pinProduct: String?
        let originalPrice, sellingPrice, earningPrice: String?
        let colors: [Colors]?
        let material: [Materials]?
        let productImages: [ProductImage]?

        enum CodingKeys: String, CodingKey {
            case productID = "product_id"
            case productTitle = "product_title"
            case description, quantity
            case productHeight = "product_height"
            case productLength = "product_length"
            case productWidth = "product_width"
            case productWeight = "product_weight"
            case invoice, warranty
            case typeOfDelivery = "type_of_delivery"
            case deliveryMethod = "delivery_method"
            case pinProduct = "pin_product"
            case originalPrice = "original_price"
            case sellingPrice = "selling_price"
            case earningPrice = "earning_price"
            case colors, material
            case productImages = "product_images"
        }
}

// MARK: - Color
struct Colors: Codable {
    let color: String?
}

// MARK: - Material
struct Materials: Codable {
    let material: String?
}

// MARK: - ProductImage
struct ProductImage: Codable {
    let images: String?
}

// MARK: - uplaod doc

struct SellItemUploadMediaModel: Codable {
    let productMediaURL: String?
    let productMediaName, mediaType: String?
    var dymyImg : String?

    enum CodingKeys: String, CodingKey {
        case productMediaURL = "product_media_url"
        case productMediaName = "product_media_name"
        case mediaType = "media_type"
    }
    
    func toDictionary() -> [String: Any] {
            var dictionary = [String: Any]()
            dictionary[CodingKeys.productMediaURL.rawValue] = productMediaURL
            dictionary[CodingKeys.productMediaName.rawValue] = productMediaName
            dictionary[CodingKeys.mediaType.rawValue] = mediaType
            return dictionary
        }
}
