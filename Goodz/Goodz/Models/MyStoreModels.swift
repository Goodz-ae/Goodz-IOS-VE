//
//  MyStoreModels.swift
//  Goodz
//
//  Created by Akruti on 05/12/23.
//

import Foundation
import UIKit

class ProductsModel {
    
    var productImage : UIImage
    var productName : String
    var store : String
    var price : String
    var originalPrice : String
    var isPin: Bool
    var isLiked : Bool
    var isBoosted : Bool
    var isHidden : Bool
    internal init(productImage: UIImage, productName: String, store: String, price: String, originalPrice: String, isPin: Bool, isLiked: Bool, isBoosted: Bool, isHidden: Bool) {
        self.productImage = productImage
        self.productName = productName
        self.store = store
        self.price = price
        self.originalPrice = originalPrice
        self.isPin = isPin
        self.isBoosted = isBoosted
        self.isHidden = isHidden
        self.isLiked = isLiked
    }
}

class OtherUserModel {
    var userName : String
    var rate : String
    var date : String
    var description : String
    var profileImage : UIImage
    internal init(userName: String, rate: String, date: String, description: String, profileImage: UIImage) {
        self.userName = userName
        self.rate = rate
        self.date = date
        self.description = description
        self.profileImage = profileImage
    }
}

class PaymentOptionModel {
    var title : String
    var imgCards : UIImage
    internal init(title: String, imgCards: UIImage) {
        self.title = title
        self.imgCards = imgCards
    }
}
