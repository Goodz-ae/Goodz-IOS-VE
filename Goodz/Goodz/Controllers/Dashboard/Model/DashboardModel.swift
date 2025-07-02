//
//  DashboardModel.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 20/02/24.
//

import Foundation

struct DashboardModel: Codable {
    let totalSalesAmount : String?
    let salesInAed : [String:String?]?
}


struct MyInvoiceModel : Codable {
    let productId : String?
    let productName : String?
    let brandName : String?
    let discountedPrice : String?
    let originalPrice : String?
    let productImage : String?
    let invoiceUrl : String?

    enum CodingKeys: String, CodingKey {

        case productId = "product_id"
        case productName = "product_name"
        case brandName = "brand_name"
        case discountedPrice = "discounted_price"
        case originalPrice = "original_price"
        case productImage = "product_image"
        case invoiceUrl = "invoice_url"
    }
}

struct MyFiguresStoreModel : Codable {
    let totalFollowers : String?
    let totalReview : String?
    let totalViews : String?
    let totalLikes : String?

    enum CodingKeys: String, CodingKey {

        case totalFollowers = "total_followers"
        case totalReview = "total_review"
        case totalViews = "total_views"
        case totalLikes = "total_likes"
    }
}

struct TotalSalesModel : Codable {
    let totalSalesAmount : String?
    let salesInAed : DashboardGraphModel?

    enum CodingKeys: String, CodingKey {

        case totalSalesAmount = "total_sales_amount"
        case salesInAed = "sales_in_aed"
    }
}

struct StoreViewsModel : Codable {
    let totalStoreView : String?
    let storeViews : DashboardGraphModel?

    enum CodingKeys: String, CodingKey {

        case totalStoreView = "total_store_view"
        case storeViews = "store_views"
    }
}

struct DashboardGraphModel : Codable {
    let key : [String]?
    let value : [String]?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case value = "value"
    }
}

struct SalesByCategoryeModel : Codable {
    let salesByCategory : [SalesGraphModel]?
    let salesByCategoryVolume : [SalesGraphModel]?

    enum CodingKeys: String, CodingKey {

        case salesByCategory = "sales_by_category"
        case salesByCategoryVolume = "sales_by_category_volume"
    }

}

struct SalesGraphModel : Codable {
    let title : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case value = "value"
    }

}
