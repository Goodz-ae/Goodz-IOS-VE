//
//  AddBankDetailsVM.swift
//  Goodz
//
//  Created by Akruti on 26/12/23.
//

import Foundation
class AddBankDetailsVM {
    var fail: BindFail?
    var repo = WalletRepo()
    
    var bankDetail: WalletSetupModel?
    
    init(fail: BindFail? = nil, repo: WalletRepo = WalletRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func checkUserData(bankName : String, accountHolder: String, accountNumber : String, iBANNumber: String, sWIFTCode : String, bankLetter : URL?, completion: (Bool) -> Void) {
        if bankName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterBankName)
            completion(false)
        } else if accountHolder.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterAccountHolderName)
            completion(false)
        } 
//        else if !Validation.shared.isValidateWithSpaceName(name: accountHolder) {
//            notifier.showToast(message: Labels.pleaseEnterValidAccountHolderName)
//            completion(false)
//        }
        else if accountNumber.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterAccountNumber)
            completion(false)
        } else if iBANNumber.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterIBANNumber)
            completion(false)
        } else if sWIFTCode.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterSWIFTCode)
            completion(false)
        } else if bankLetter == nil {
            notifier.showToast(message: Labels.pleaseAttachBankLetter)
            completion(false)
        } else {
            completion(true)
        }
    }
    
    func AddBankDetails(isEdit: Bool, bankName : String, accountHolder: String, accountNumber : String, iBANNumber: String, sWIFTCode : String, imgUrl: URL?, completion: @escaping((Bool) -> Void)) {
        self.repo.addBankDetailAPI(isEdit: isEdit, bankName: bankName, accountHolderName: accountHolder, accountNumber: accountNumber, ibanNumber: iBANNumber, swiftCode: sWIFTCode, imgUrl: imgUrl) { isDone, str in
            completion(isDone)
        }
    }
}
