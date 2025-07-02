//
//  ChatDropDownVM.swift
//  Goodz
//
//  Created by Akruti on 12/02/24.
//

import Foundation
class ChatDropDownVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ChatDropDownRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func blockUserAPI(toId : String, chatId: String, isBlock : String, _ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.blockUserAPI(toId: toId, chatId: chatId, isBlock: isBlock) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func reportUserAPI(message : String,toId : String, chatId: String, _ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.reportUserAPI(message : message, toId: toId, chatId: chatId) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func deleteChatAPI(toId : String, chatId: String, _ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.deleteChatAPI(toId: toId, chatId: chatId) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
}
