//
//  WalletDetailsModel.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 06/04/24.
//

import Foundation

struct WalletDetailsModel : Codable {
    let totalRecords, availableBalance, goodzEarnings, username: String?
       let walletTransactions: [WalletTransactionModel]?

       enum CodingKeys: String, CodingKey {
           case totalRecords = "total_records"
           case availableBalance = "available_balance"
           case goodzEarnings = "goodz_earnings"
           case username
           case walletTransactions = "wallet_transactions"
       }
}

struct WalletTransactionModel : Codable {
    let transactionID, orderID, orderUniqueID, transactionDate: String?
        let walletTransactionAmount, isCredit: String?

        enum CodingKeys: String, CodingKey {
            case transactionID = "transaction_id"
            case orderID = "order_id"
            case orderUniqueID = "order_unique_id"
            case transactionDate = "transaction_date"
            case walletTransactionAmount = "wallet_transaction_amount"
            case isCredit = "is_credit"
        }

}

struct WalletSetupModel : Codable {
    let userID : String?
    let bankName : String?
    let accountHolderName : String?
    let accountNumber : String?
    let secureAccountNumber : String?
    let ibanNumber : String?
    let secure_ibanNumber : String?
    let swiftCode : String?
    let bankLetter : String?

    enum CodingKeys: String, CodingKey {

        case userID = "user_id"
        case bankName = "bank_name"
        case accountHolderName = "account_holder_name"
        case accountNumber = "account_number"
        case secureAccountNumber = "secure_account_number"
        case ibanNumber = "iban_number"
        case secure_ibanNumber = "secure_iban_number"
        case swiftCode = "swift_code"
        case bankLetter = "bank_letter"
    }

}
