//
//  ContactUsVM.swift
//  Goodz
//
//  Created by Akruti on 26/12/23.
//

import Foundation
class ContactUsVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ContactUsRepoRepo()
    
    // --------------------------------------------
    // MARK: - Init methods
    // --------------------------------------------
    
    init(fail: BindFail? = nil, repo: ContactUsRepoRepo = ContactUsRepoRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func checkUserData(docURL : URL?, name : String, email: String, subject : String, message: String, completion: @escaping(Bool) -> Void) {
        if name.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterName)
            completion(false)
        }
//        else if !Validation.shared.isValidateName(name: name) {
//            notifier.showToast(message: Labels.pleaseEnterValidName)
//            completion(false)
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
        } else {
            repo.contactUsAPI(name, email, subject, message, docURL) { status, error in
                if status {
                    completion(true)
                } else {
                    completion(false)
                }
            }
            
        }
    }
    
    // --------------------------------------------
    
}
