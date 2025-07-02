//
//  AddReviewVM.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 29/03/24.
//

import Foundation
class AddReviewVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------

    var fail: BindFail?
    var repo = AddReviewRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func addReviewAPI(toStoreID: String, orderId: String,rating: String,comment: String,completion: @escaping((Bool) -> Void)) {
        self.repo.addStoreReviewAPI(toStoreID: toStoreID, orderId: orderId, rating: rating, comment: comment) { status, error in
            completion(status)
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
        }
    }
    
    // --------------------------------------------
    
}
