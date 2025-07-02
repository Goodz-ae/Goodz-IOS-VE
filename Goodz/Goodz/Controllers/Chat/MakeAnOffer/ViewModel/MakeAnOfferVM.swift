//
//  MakeAnOfferVM.swift
//  Goodz
//
//  Created by Akruti on 05/02/24.
//

import Foundation
class MakeAnOfferVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = MakeAnOfferRepo()
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    func fetchMakeAnOfferAPI(offerType : String, productId : String, bundleId: String, amount: String, storeId: String ,_ completion: @escaping((_ status: Bool, _ chatId : String, _ error: String) -> Void)) {
        self.repo.deleteAddressAPI(offerType: offerType, productId: productId, bundleId: bundleId, amount: amount, storeId: storeId) { status, data, error in
            if let errorMsg = error {
                notifier.showToast(message: appLANG.retrive(label: errorMsg))
            }
            if !status {
                completion(status, "", error ?? "")
            } else {
                if let chatId = data?.first?.chatId {
                    completion(status, chatId, "")
                }
            }
            
        }
    }
    
    // --------------------------------------------
    
}
