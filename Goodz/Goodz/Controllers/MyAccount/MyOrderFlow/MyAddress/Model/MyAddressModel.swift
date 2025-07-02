//
//  MyAddressModel.swift
//  Goodz
//
//  Created by Akruti on 05/01/24.
//

import Foundation
struct MyAddressModel: Codable {
    
    var fullName, addressId, countryCode, mobile, city, area, streetAddress, floor, isDefault, countryCodes, phoneNumber : String?
   
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case addressId = "address_id"
        case countryCode = "country_code"
        case mobile = "mobile"
        case city = "city"
        case area = "area"
        case streetAddress = "street_address"
        case floor = "floor"
        case isDefault = "is_default"
        case countryCodes = "country_Code"
    }
}
 
struct AddressListModel: Codable {
    let address: [MyAddressModel]?
}
