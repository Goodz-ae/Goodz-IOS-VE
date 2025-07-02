//
//  CustomizationModels.swift
//  Goodz
//
//  Created by Akruti on 16/01/24.
//

import Foundation

// MARK: - SaveCustomizationModel
struct SaveCustomizationModel: Codable {
    let userID, token: String?
    var result: [CustomizationModels]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token
        case result
    }
}

// MARK: - CustomizationModels
struct CustomizationModels: Codable {
    let title, type, id: String?
    var selectedItemsList: [SelectedItemsList]?

    enum CodingKeys: String, CodingKey {
        case title, type, id
        case selectedItemsList = "selected_items_list"
    }
}

// MARK: - SelectedItemsList
struct SelectedItemsList: Codable {
    let id, name: String?
    var selectedSubItemsList: [SelectedSubItemsList]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case selectedSubItemsList = "selected_sub_items_list"
    }
}

struct SelectedSubItemsList: Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}


