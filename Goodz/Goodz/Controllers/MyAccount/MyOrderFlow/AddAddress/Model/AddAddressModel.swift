//
//  AddAddressModel.swift
//  Goodz
//
//  Created by Akruti on 05/01/24.
//

import Foundation
struct CitiesModel: Codable, Equatable {
    let cityName : String?
    let cityId: Int?

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case cityId = "city_id"
    }
}
struct AreaModel: Codable, Equatable {
    let areaName : String?
    let areaId: Int?

    enum CodingKeys: String, CodingKey {
        case areaName = "area_name"
        case areaId = "area_id"
    }
}
struct AddEditAddressModel : Codable {
    let addressId : String
    enum CodingKeys : String, CodingKey {
        case addressId = "address_id"
    }
}
