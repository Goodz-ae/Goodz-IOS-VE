//
//  HelpCenterVM.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
class HelpCenterVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrHelpCenter : [String] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData() {
        self.arrHelpCenter = ["About us",
                              "How It works",
                              "Our Commitments",
                              "FAQ",
                              "Legal",
                              "Contact Us"]
        
    }
    
    func setNumberOfHelpCenter() -> Int {
        self.arrHelpCenter.count
    }
    
    func setRowData(row: Int) -> String {
        self.arrHelpCenter[row]
    }
    
}
