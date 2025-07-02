//
//  AccountVM.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import Foundation
class AccountVM {
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    var arrAccount : [[AccountMenuOptions]] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData() {
        
        if UserDefaults.isGuestUser {
            self.arrAccount = [
                [.profile],
                [],
                [.helpCenter],
                [.version]
            ]
        } else {
            if appUserDefaults.getValue(.isProUser) ?? false {
                self.arrAccount = [
                    [.profile],
                    [.goodzPro],
//                    [.myStore,.myOrders,.myWallet,.myAds,.bundles,.customization,.notifications,.helpCenter,.settings],
                    [.myStore,.myOrders,.myWallet,.myAds,.bundles,.uploadYourDocuments,.notifications,.helpCenter,.settings],
                    [.version]
                ]
            } else {
                self.arrAccount = [
                    [.profile],
                    [],
//                    [.myStore,.myOrders,.myWallet,.myAds,.bundles,.customization,.notifications,.helpCenter,.settings],
                    [.myStore,.myOrders,.myWallet,.myAds,.bundles,.uploadYourDocuments,.notifications,.helpCenter,.settings],
                    [.version]
                ]
            }
        }
    }
    /*
     case uploadYourDocuments
     case .uploadYourDocuments:
         return Labels.uploadYourDocument
     case .uploadYourDocuments:
         return .iconUploadBig
     case  .uploadYourDocuments,*/
    
    // --------------------------------------------
    
    func numberOfsection() -> Int {
        self.arrAccount.count
    }
    
    // --------------------------------------------
    
    func numberOfCell(section: Int) -> Int {
        self.arrAccount[section].count
    }
    
    // --------------------------------------------
    
    func setRowData(section: Int, row: Int) -> AccountMenuOptions {
        self.arrAccount[section][row]
    }
    
    // --------------------------------------------
    
}
