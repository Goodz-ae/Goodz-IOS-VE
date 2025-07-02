//
//  SecurityEmailVM.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
class SecurityEmailVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
   
    var fail: BindFail?
    var repo = SecurityEmailRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func changeCurrentEmailAPI(email: String,completion: @escaping((_ otp : String,_ status : Bool)-> Void)) {
        self.repo.changeCurrentEmailAPI(email) { status, data, error in
            if status , let otp = data?.first?.result?.first {
                completion(otp.otp ?? "", status)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion( "", status)
            }
            
        }
    }
    
    // --------------------------------------------
    
}
