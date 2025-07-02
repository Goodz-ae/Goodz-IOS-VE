//
//  PaymentOptionVM.swift
//  Goodz
//
//  Created by Akruti on 12/12/23.
//

import Foundation
import UIKit

class PaymentOptionVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrPayment : [PaymentOptionModel] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData() {
        self.arrPayment = [PaymentOptionModel(title: "Credit Card", imgCards: .iconCards),
                           PaymentOptionModel(title: "PayPal", imgCards: .paypal)]
    }
    
    // --------------------------------------------
    
    func setNumberOfPayment() -> Int {
        self.arrPayment.count
    }
    
    // --------------------------------------------
    
    func setRowData(row: Int) -> PaymentOptionModel {
        self.arrPayment[row]
    }
    
    // --------------------------------------------
    
}
