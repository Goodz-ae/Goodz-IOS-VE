//
//  CategoriesModels.swift
//  Goodz
//
//  Created by Akruti on 03/01/24.
//

import Foundation
struct CategoryMainModel: Codable {
    
    let categoriesMainTitle , categoriesMainId, categoriesMainImage, isCustomizationSelected : String?
    
    enum CodingKeys: String, CodingKey {
        case categoriesMainTitle = "categories_main_title"
        case categoriesMainId = "categories_main_id"
        case categoriesMainImage = "categories_main_image"
        case isCustomizationSelected = "is_customization_selected"
    }
    
}

struct CategorySubModel: Codable {
    
    let categoriesSubTitle , categoriesSubId, categoriesSubImage : String?
    
    enum CodingKeys: String, CodingKey {
        case categoriesSubTitle = "categories_sub_title"
        case categoriesSubId = "categories_sub_id"
        case categoriesSubImage = "categories_sub_image"
    }
    
}

struct CategoryCollectionModel : Codable {
    
    let categoryCollectionTitle , categoryCollectionId, isCustomizationSelected : String?
    
    enum CodingKeys: String, CodingKey {
        case categoryCollectionTitle = "category_collection_title"
        case categoryCollectionId = "category_collection_id"
        case isCustomizationSelected = "is_customization_selected"
    }
    
}

class SearchDataModel {
    var section : Int?
    var recentData : [String]?
    var categoryList : [CategoryMainModel]?
    var goodDeals : [String]?
    
    internal init(section: Int? = nil, recentData: [String]? = nil, categoryList: [CategoryMainModel]? = nil, goodDeals: [String]? = nil) {
        self.section = section
        self.recentData = recentData
        self.categoryList = categoryList
        self.goodDeals = goodDeals
    }
}
