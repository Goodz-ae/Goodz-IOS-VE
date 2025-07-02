//
//  LabelListModel.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import Foundation

// MARK: - Label List Model

struct LabelListModel: Codable {
    let code: Int?
    let message, updatedDate: String?
    let result: [LabelList]?

    enum CodingKeys: String, CodingKey {
        case code, message
        case updatedDate = "updated_date"
        case result
    }
}

// MARK: - Result
struct LabelList: Codable {
    let key, value: String?
}
