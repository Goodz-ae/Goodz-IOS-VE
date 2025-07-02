//
//  ReportVM.swift
//  Goodz
//
//  Created by Akruti on 30/01/24.
//

import Foundation
class ReportVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------

    var fail: BindFail?
    var repo = ReportRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchConfirmReceptionAPI(issue: String, image: URL?, orderProductId : String,completion: @escaping((Bool) -> Void)) {
        self.repo.confirmReceptionAPI(issue: issue, image: image, orderProductId: orderProductId) { status, error in
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
