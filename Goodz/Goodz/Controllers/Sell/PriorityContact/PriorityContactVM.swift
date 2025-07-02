//
//  PriorityContactVM.swift
//  Goodz
//
//  Created by Akruti on 26/12/23.
//

import UIKit

class PriorityContactVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = PriorityContactRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    func priorityContactDetails(name : String, email : String, subject : String, message : String, attachFile : UIImage?, fileUrl: URL?, completion: @escaping((Bool) -> Void)) {
        self.repo.priorityContactAPI(name : name, email : email, subject : subject, message : message, attachFile : attachFile, fileUrl: fileUrl) { status, error in
            
            if status {
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func setPriorityContactData(name : String, email: String, subject : String, message: String, isAttachment: Bool, completion: (Bool) -> Void) {
        if name.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterName)
            completion(false)
        } 
//        else if !Validation.shared.isValidateName(name: name) {
//            notifier.showToast(message: Labels.pleaseEnterValidName)
//           completion(false)
//        }
        else if email.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterEmail)
            completion(false)
        } else if !Validation.shared.isValidEmail(email) {
            notifier.showToast(message: Labels.pleaseEnterValidEmail)
           completion(false)
        } else if subject.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterSubject)
            completion(false)
        } else if message.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterMessage)
            completion(false)
        } else if !isAttachment {
            notifier.showToast(message: Labels.pleaseUploadMedia)
            completion(false)
        } 
        else {
            completion(true)
        }
    }
}
