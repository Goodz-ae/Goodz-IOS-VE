//
//  SettingsVM.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import Foundation
class SettingsVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrSettings : [SettingMenuOptions] = SettingMenuOptions.allCases
    var fail: BindFail?
    var repo = SettingsRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    // --------------------------------------------
    
    func setNumberOfSettings() -> Int {
        self.arrSettings.count
    }
    
    // --------------------------------------------
    
    func setRowData(row: Int) -> SettingMenuOptions {
        self.arrSettings[row]
    }
    
    // --------------------------------------------
    
    func deleteAccount(completion: @escaping((Bool) -> Void)) {
        self.repo.deleteAccountAPI { status, error in
            if status {
                completion(true)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func logoutAccount(completion: @escaping((Bool) -> Void)) {
        self.repo.logoutAccountAPI { status, error in
            if status {
                completion(true)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
}
