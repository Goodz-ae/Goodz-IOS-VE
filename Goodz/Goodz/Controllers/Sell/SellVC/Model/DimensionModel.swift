//
//  DimensionModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 15/12/23.
//

import UIKit

/// Dimension Model
struct DimensionModel {
    let dimension: String
    let dimensionMeter: String
    
    static func listOfDimensions() -> [DimensionModel] {
        return [
            DimensionModel(dimension: "30 cm", dimensionMeter: "Height(cm)"),
            DimensionModel(dimension: "50 Cm", dimensionMeter: "Length(cm)"),
            DimensionModel(dimension: "80 Cm", dimensionMeter: "Width(cm)"),
            DimensionModel(dimension: "20 Kg", dimensionMeter: "Weight(kg)")
        ]
    }
}

/// Delivery Methods Model
struct DeliveryMethodModel {
    var isCheck: Bool
    let method: String
    
    static func listOfMethod() -> [DeliveryMethodModel] {
        return [
        DeliveryMethodModel(isCheck: true, method: "Delivery"),
        DeliveryMethodModel(isCheck: false, method: "Pick-up from my home by the buyer"),
        DeliveryMethodModel(isCheck: false, method: "My product needs to be assembly")
        
        ]
    }
}

/// Type of delivery Model
struct TypeOfDelivery {
    var isSelected: Bool
    let ivDeliveryType: UIImage
    let deliveryType: String
        
}

/// Upload Image Model
struct ImageModel {
    
    enum DocType {
        case image
        case video
        case addImage
    }
    
    var attachmentName: String?
    var image: UIImage?
    var imageUrl = String()
    var videoUrl =  String()
    var type = DocType.image
}
