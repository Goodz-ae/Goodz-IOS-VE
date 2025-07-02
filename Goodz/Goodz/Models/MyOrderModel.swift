//
//  MyOrderModel.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
import UIKit

// MARK: - Result
struct SellListResult: Codable {
    let sellID, sellProductID, productName: String?
    let productImage: String?
    let price, status, deliveryDate: String?
    let paymentStatus: String?
    let orderType: String?
    
    
    enum CodingKeys: String, CodingKey {
        case sellID = "sell_id"
        case sellProductID = "sell_product_id"
        case productName = "product_name"
        case productImage = "product_image"
        case price, status
        case deliveryDate = "delivery_date"
        case paymentStatus = "payment_status"
        case orderType = "order_type"
    }
}

// MARK: - OrderListResult
struct OrderListResult: Codable {
    let orderID, orderProductID, productName: String?
    let productImage: String?
    let price, status, deliveryDate: String?
    let paymentStatus: String?
    let orderType: String?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderProductID = "order_product_id"
        case productName = "product_name"
        case productImage = "product_image"
        case price, status
        case deliveryDate = "delivery_date"
        case paymentStatus = "payment_status"
        case orderType = "order_type"
    }
}

// MARK: - Result

struct OrderDetailsResult: Codable {
    var itemToConfirm : ItemToConfirm?
    var slotOptions  : [OptionsSlotBooking]?
   
    let isReceptionConfirmed, isReview, sellID, storeID, orderID, placedDate, buyerName: String?
    let items: [OrderItem]?
    let totalItems, paymentOption, couponCode, subtotal: String?
    let couponDiscountPrice, deliveryCost, vat, totalPrice: String?
    let deliveryToName, deliveryAddress, deliveryPhone, sellerName: String?
    let pickUpDate, pickUpTime: String?
    let sallerName, username, address, mobile, goodzWalletCashback, MainOrderId , bundleDiscountPrice, bundleDiscountPercentage, orderStatus : String?
    let awbNumber, courierCompany, labelPath: String?
        

    enum CodingKeys: String, CodingKey {
        case slotOptions = "slotOptions"
        case itemToConfirm = "itemToConfirm"
        case orderID = "order_id"
        case sellID = "sell_id"
        case storeID = "store_id"
        case placedDate = "placed_date"
        case items = "Items"
        case totalItems = "total_items"
        case paymentOption = "payment_option"
        case orderStatus = "order_status"
        case couponCode = "coupon_code"
        case subtotal
        case username, mobile, address
        case sallerName = "saller_name"
        case couponDiscountPrice = "coupon_discount_price"
        case deliveryCost = "delivery_cost"
        case vat
        case totalPrice = "total_price"
        case buyerName = "buyer_name"
        case deliveryToName = "delivery_to_name"
        case deliveryAddress = "delivery_address"
        case deliveryPhone = "delivery_phone"
        case sellerName = "seller_name"
        case pickUpDate = "pick_up_date"
        case pickUpTime = "pick_up_time"
        case isReceptionConfirmed
        case isReview = "is_review"
        case goodzWalletCashback = "goodz_wallet_cashback"
        case MainOrderId = "orderId"
        case bundleDiscountPrice = "bundle_discount_price"
        case bundleDiscountPercentage = "bundle_discount_percentage"
        case awbNumber = "awb_number"
        case courierCompany = "courier_company"
        case labelPath = "label_path"
    }
}

// MARK: - Item
struct OrderItem: Codable {
    let sellProductID,orderProductID, productName: String?
    let productImage: String?
    let discountPrice, originalPrice, brandTitle, brandID: String?
    let deliveryStatus, isOwner: String?

    enum CodingKeys: String, CodingKey {
        case orderProductID = "order_product_id"
        case sellProductID = "sell_product_id"
        case productName = "product_name"
        case productImage = "product_image"
        case discountPrice = "discounted_price"
        case originalPrice = "original_price"
        case brandTitle = "brand_title"
        case brandID = "brand_id"
        case deliveryStatus = "delivery_status"
        case isOwner = "is_owner"
    }
}

class OrderModel {
    
    var productImg : UIImage
    var productName : String
    var date : String
    var price : String
    var status : String
    var isBoosted : Bool
    internal init(productImg: UIImage, productName: String, date: String, price: String, status: String, isBoosted: Bool) {
        self.productImg = productImg
        self.productName = productName
        self.date = date
        self.price = price
        self.status = status
        self.isBoosted = isBoosted
    }
    
}


class AddressModel {
    
    var username: String
    var mobile : String
    var city : String
    var area : String
    var streetAddress : String
    var floor : String
    
    internal init(username: String, mobile: String, city: String, area: String, streetAddress: String, floor: String) {
        self.username = username
        self.mobile = mobile
        self.city = city
        self.area = area
        self.streetAddress = streetAddress
        self.floor = floor
    }
    
}

//class BoostPlanModel {
//    var days : String
//    var price: String
//    var description : String
//    var isBestOffer : Bool
//    internal init(days: String, price: String, description: String, isBestOffer: Bool) {
//        self.days = days
//        self.price = price
//        self.description = description
//        self.isBestOffer = isBestOffer
//    }
//}

class OrderTrackModel {
    var data: String
    var status : String
    var isDone : Bool
    var imgDeselct : UIImage
    var imgSelect : UIImage
    internal init(data: String, status: String, isDone: Bool, imgDeselct: UIImage, imgSelect: UIImage) {
        self.data = data
        self.status = status
        self.isDone = isDone
        self.imgDeselct = imgDeselct
        self.imgSelect = imgSelect
    }
}
