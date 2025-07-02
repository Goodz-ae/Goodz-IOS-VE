//
//  FilterDataModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

struct FilterDataModel {
    let title: String
    var description: String?
    
    static func listOfFilter() -> [FilterDataModel] {
        return [
            FilterDataModel(title: Labels.category, description: nil),
            FilterDataModel(title: Labels.brands, description: nil),
            FilterDataModel(title: Labels.condition, description: nil),
            FilterDataModel(title: Labels.price, description: nil),
            FilterDataModel(title: Labels.color, description: nil),
            FilterDataModel(title: Labels.material, description: nil),
            FilterDataModel(title: Labels.dimensions, description: nil)
        ]
    }
}
