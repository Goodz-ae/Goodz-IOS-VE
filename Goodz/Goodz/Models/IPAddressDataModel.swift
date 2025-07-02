//
//  IPAddressDataModel.swift
//  Goodz
//
//  Created by vtadmin on 06/03/24.
//

import Foundation

// MARK: - IPAddressDataModel
struct IPAddressDataModel: Codable {
    let ip, city, region, country: String?
    let loc, org, postal, timezone: String?
    let readme: String?
}
