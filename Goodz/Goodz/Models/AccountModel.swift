//
//  AccountModel.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import Foundation
import UIKit

class MainAccounteModel {
    var id : Int
    var data : [AccounteModel]
    
    internal init(id: Int, data: [AccounteModel]) {
        self.id = id
        self.data = data
    }
    
}

class AccounteModel {
    
    var image : UIImage
    var title : String
    var description : String
    var rightImage : UIImage
    
    internal init(image: UIImage, title: String, description: String, rightImage: UIImage) {
        self.image = image
        self.title = title
        self.description = description
        self.rightImage = rightImage
    }
    
}

class CustomizationModel {
    var image : UIImage
    var title : String
    var description : String
    var subItems : [SubCustomizationModel]
    internal init(image: UIImage, title: String, description: String, subItems: [SubCustomizationModel]) {
        self.image = image
        self.title = title
        self.description = description
        self.subItems = subItems
    }
}

class SubCustomizationModel {
    var title : String
    var isSelect : Bool
    internal init(title: String, isSelect: Bool) {
        self.title = title
        self.isSelect = isSelect
    }
}

class DashboardSortModel {
    var title : String
    var amount : String
    internal init(title: String, amount: String) {
        self.title = title
        self.amount = amount
    }
}
