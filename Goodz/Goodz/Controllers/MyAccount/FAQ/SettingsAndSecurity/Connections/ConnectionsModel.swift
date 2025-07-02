//
//  ConnectionsModel.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 28/02/24.
//

import Foundation

// MARK: - Result
struct ConnectionsModel: Codable {
    let place, dateTime: String?
    let device: String?
    var currentLogin: String?

    enum CodingKeys: String, CodingKey {
        case place = "place"
        case dateTime = "date_time"
        case device = "device"
        case currentLogin = "current_login"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        place = try values.decodeIfPresent(String.self, forKey: .place)
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
        device = try values.decodeIfPresent(String.self, forKey: .device)
        currentLogin = decodeToString(values, key: .currentLogin)
    }
}
