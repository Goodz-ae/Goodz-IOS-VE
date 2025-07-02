//
//  TransactionVM.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 06/04/24.
//

import Foundation

class TransactionVM {
    
    var fail: BindFail?
    var repo = WalletRepo()
    
    init(fail: BindFail? = nil, repo: WalletRepo = WalletRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func fetchMyWalletDetails(completion: @escaping((Bool) -> Void)) {
        self.repo.getWalletTransactionListAPI({ status, data, error in
            if status , let myWallet = data {
                self.arrTransactions = myWallet
                completion(true)
                return
            } else {
                completion(false)
            }
        })
    }
    
    var arrTransactions : [WalletTransactionModel] = []
   
    func setNumberOfTrasaction() -> Int {
        self.arrTransactions.count
    }
    
    func setRowData(row: Int) -> WalletTransactionModel {
        self.arrTransactions[row]
    }
}
