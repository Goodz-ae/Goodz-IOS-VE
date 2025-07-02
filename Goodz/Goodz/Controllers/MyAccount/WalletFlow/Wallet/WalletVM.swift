//
//  WalletVM.swift
//  Goodz
//
//  Created by Akruti on 11/12/23.
//

import Foundation
import UIKit

class WalletVM {
    
    var fail: BindFail?
    var repo = WalletRepo()
    
    var walletDetail: WalletDetailsModel?
    var bankDetail: WalletSetupModel?
    init(fail: BindFail? = nil, repo: WalletRepo = WalletRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func fetchMyWalletDetails(completion: @escaping((Bool) -> Void)) {
        self.repo.getMyWalletDetailsAPI({ status, data, error in
            if status , let myWallet = data {
                self.walletDetail = myWallet
                self.setTransactionData()
                completion(true)
                return
            } else {
                completion(false)
            }
        })
    }
    
    func fetchWalletSetup(completion: @escaping((Bool) -> Void)) {
        self.repo.getWalletSetupAPI({ status, data, error in
            if status , let myWallet = data {
                self.bankDetail = myWallet
                completion(true)
                return
            } else {
                completion(false)
            }
        })
    }
    
    func deleteBankDetails(completion: @escaping((Bool) -> Void)) {
        self.repo.deleteBankDetailAPI({ status, error in
            if status {
                completion(true)
                return
            } else {
                completion(false)
            }
        })
    }
    
    var arrTransactions : [WalletTransactionModel] = []
    
    func setTransactionData() {
        self.arrTransactions = walletDetail?.walletTransactions ?? []
    }
    
    func setNumberOfTrasaction() -> Int {
        self.arrTransactions.count >= 5 ? 5 : self.arrTransactions.count
    }
    
    func setRowData(row: Int) -> WalletTransactionModel {
        self.arrTransactions[row]
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func checkUserData(bankName : String, accountHolder: String, accountNumber : String, accNoCount: Int, iBANNumber: String, iBanNoCount: Int, sWIFTCode : String, swiftCodeCount: Int, bankLetter : URL?, completion: (Bool) -> Void) {
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
        } else if accNoCount < 12 {
            notifier.showToast(message: "Account Number must be atleast 12 characters.")
        } else if iBANNumber.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterIBANNumber)
            completion(false)
        } else if iBanNoCount < 22 {
            notifier.showToast(message: "IBAN Number must be atleast 22 characters.")
        } else if sWIFTCode.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterSWIFTCode)
            completion(false)
//        } else if bankLetter == nil {
//            notifier.showToast(message: Labels.pleaseAttachBankLetter)
//            completion(false)
        } else if swiftCodeCount < 8 {
            notifier.showToast(message: "Swift Code must be atleast 8 characters.")
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
