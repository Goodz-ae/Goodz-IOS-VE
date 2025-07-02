//
//  WalletModel.swift
//  Goodz
//
//  Created by Akruti on 11/12/23.
//

import Foundation
import UIKit
class TransactionModel {
    var imgProduct : UIImage
    var productName: String
    var date: String
    var amount : String
    var color : UIColor
    internal init(imgProduct: UIImage, productName: String, date: String, amount: String, color: UIColor) {
        self.imgProduct = imgProduct
        self.productName = productName
        self.date = date
        self.amount = amount
        self.color = color
    }
}

class BankCardModel {
    var imgCard : UIImage
    var cardNumber: String
    internal init(imgCard: UIImage, cardNumber: String) {
        self.imgCard = imgCard
        self.cardNumber = cardNumber
    }
}
