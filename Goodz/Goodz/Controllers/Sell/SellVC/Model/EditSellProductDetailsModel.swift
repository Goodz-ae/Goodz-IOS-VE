//
//  EditSellProductDetailsModel.swift
//  Goodz
//
//  Created by vtadmin on 29/02/24.
//

import Foundation

// MARK: - EditSellProductDetailsModel
struct EditSellProductDetailsModel: Codable {
    let productTitle, description, quantity, productHeight: String?
    let productLength, productWidth, productWeight, colors: String?
    let colorID, material, materialID: String?
    let invoice, warranty: String?
    let typeOfDelivery, pinProduct, originalPrice, sellingPrice: String?
    let earningPrice, brand, brandID, condition: String?
    let conditionID, category, categoryID, subCategory: String?
    let subCategoryID, subSubCategory, subSubCategoryID, deliveryMethodIDS: String?
    let address: MyAddressModel?
    let productImages: [EditSellProductImage]?
    let deliveryMethod: [EditSellDeliveryMethod]?
    let isOrderPlaced: String?

    enum CodingKeys: String, CodingKey {
        case productTitle = "product_title"
        case description, quantity
        case productHeight = "product_height"
        case productLength = "product_length"
        case productWidth = "product_width"
        case productWeight = "product_weight"
        case colors
        case colorID = "color_id"
        case material
        case materialID = "material_id"
        case invoice, warranty
        case typeOfDelivery = "type_of_delivery"
        case pinProduct = "pin_product"
        case originalPrice = "original_price"
        case sellingPrice = "selling_price"
        case earningPrice = "earning_price"
        case brand
        case brandID = "brand_id"
        case condition
        case conditionID = "condition_id"
        case category
        case categoryID = "category_id"
        case subCategory = "sub_category"
        case subCategoryID = "sub_category_id"
        case subSubCategory = "sub_sub_category"
        case subSubCategoryID = "sub_sub_category_id"
        case deliveryMethodIDS = "delivery_method_ids"
        case address
        case productImages = "product_images"
        case deliveryMethod = "delivery_method"
        case isOrderPlaced = "is_order_placed"
    }
}

// MARK: - Address
struct Address: Codable {
    let addressID, fullName, mobile, floor: String?
    let streetAddress, countryCode, city, area: String?

    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case fullName = "full_name"
        case mobile, floor
        case streetAddress = "street_address"
        case countryCode = "country_code"
        case city, area
    }
}

// MARK: - DeliveryMethod
struct EditSellDeliveryMethod: Codable {
    let id: String?
}

// MARK: - ProductImage
struct EditSellProductImage: Codable {
    let productMediaUrl, productMediaName, mediaType: String?
    
    enum CodingKeys: String, CodingKey {
        case productMediaUrl = "product_media_url"
        case mediaType = "media_type"
        case productMediaName = "product_media_name"
    }
    
    func toSellItemUploadMediaModel() -> SellItemUploadMediaModel {
        let url = URL(string: self.productMediaUrl ?? "")
        return SellItemUploadMediaModel(productMediaURL: self.productMediaUrl, productMediaName: url?.lastPathComponent, mediaType: mediaType)
    }
}
