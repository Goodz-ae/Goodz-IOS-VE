//
//  ChatContactUsVM.swift
//  Goodz
//
//  Created by Akruti on 19/02/24.
//

import Foundation
class ChatContactUsVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ChatListRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func contactUsChatAPI(chatId : String, message: String, bundleId : String, productId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.contactUsChatAPI(chatId: chatId, message: message, bundleId: bundleId, productId: productId){ status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }

}
