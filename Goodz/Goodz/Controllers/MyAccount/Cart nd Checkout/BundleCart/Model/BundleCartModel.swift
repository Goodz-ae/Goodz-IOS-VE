//
//  CartModel.swift
//  Goodz
//
//  Created by Akruti on 22/01/24.
//

import Foundation

struct BundleCartModel: Codable {
    let products: [CartProductModel]?
    let subtotal, couponPrice, deliveryPrice, vatPrice: String?
    let totalPrice: String?
  let address: [MyAddressModel]?

    enum CodingKeys: String, CodingKey {
        case products, subtotal
        case couponPrice = "coupon_price"
        case deliveryPrice = "delivery_price"
        case vatPrice = "vat_price"
        case totalPrice = "total_price"
      case address
    }
}
