//
//  FAQDetailsVM.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
class FAQDetailsVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrHelpCenter : [String] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData() {
        self.arrHelpCenter = ["How to sell on Goodz ?",
                              "How to list a product on Goodz ?",
                              "What can I sell on Goodz ?",
                              "How to set the right selling price ?",
                              "How to sell faster ?",
                              "How to sell in Bundles ?",
                              "Product managment post-purchase ?",
                              "Not available to sell my products ?",
                              "Promotional Tools",
                              "Tips to get Goodz pictures",
                              "Choose the right product size"]
    }
    
    // --------------------------------------------
    
    func setNumberOfHelpCenter() -> Int {
        self.arrHelpCenter.count
    }
    
    // --------------------------------------------
    
    func setRowData(row: Int) -> String {
        self.arrHelpCenter[row]
    }
    
    // --------------------------------------------
    
}
