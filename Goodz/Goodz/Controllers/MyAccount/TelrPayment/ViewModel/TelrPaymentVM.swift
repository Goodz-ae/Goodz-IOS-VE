//
//  TelrPaymentVM.swift
//  Goodz
//
//  Created by Akruti on 10/05/24.
//

import Foundation
import UIKit

class TelrPaymentVM  {

    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = TelrPaymentRepo()
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    func handlePaymentCancelAPI(datacart : AddOrderModel?,data: PaymentModel?, completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        self.repo.handlePaymentCancelAPI(data: data, cartData: datacart) { status, error in
            completion(status, error)
        }
    }
    
    // --------------------------------------------
    
    func handlePaymentSuccessAPI(datacart : AddOrderModel?,data: PaymentModel?, completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        self.repo.handlePaymentSuccessAPI(data: data, cartData: datacart) { status, error in
            completion(status, error)
        }
    }
    
    // --------------------------------------------
}

