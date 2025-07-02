//
//  ReplyVM.swift
//  Goodz
//
//  Created by Akruti on 09/01/24.
//

import Foundation
class ReplyVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = MyStoreRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchReviewsReplyData(reviewId: String, message: String, storeId : String, completion: @escaping (Bool) -> Void) {
            self.repo.reviewsReplyAPI(reviewId: reviewId, message: message, storeId: storeId) { status, error in
                if status {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        
    }
}
