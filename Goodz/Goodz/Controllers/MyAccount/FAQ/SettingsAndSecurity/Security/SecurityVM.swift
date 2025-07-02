//
//  SecurityVM.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import Foundation
import UIKit
class SecurityVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrSeurity : [AccounteModel] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    let currentUser = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)
    
    func setData() {
        self.arrSeurity = [AccounteModel(image: UIImage(), title: Labels.email, description: Labels.verifyYourEmailAddress, rightImage: .iconRight)]
        
        if currentUser?.socialType == ""{
            self.arrSeurity.append(AccounteModel(image: UIImage(), title: Labels.password, description: Labels.protectYourAccountWithAAafePassword, rightImage: .iconRight))
        }
        
        self.arrSeurity.append(contentsOf: [ AccounteModel(image: UIImage(), title: Labels.twoStepsVerification, description: Labels.confirmTheNewConnection, rightImage: .iconRight),
                                             AccounteModel(image: UIImage(), title: Labels.connections, description: Labels.viewConnectedDevices, rightImage: .iconRight)])
    }
    
    // --------------------------------------------
    
    func setNumberOfSeurity() -> Int {
        self.arrSeurity.count
    }
    
    // --------------------------------------------
    
    func setRowDataOfSeurity(row: Int) -> AccounteModel {
        self.arrSeurity[row]
    }
    
}
