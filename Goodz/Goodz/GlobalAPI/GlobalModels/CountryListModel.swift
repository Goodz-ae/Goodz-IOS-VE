//
//  CountryListModel.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import Foundation
struct CountryListModel: Codable {
    let id, countryCode, countryName, phoneNumberLength: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case countryCode = "country_code"
        case countryName = "country_name"
        case phoneNumberLength = "phone_number_length"
    }
}
