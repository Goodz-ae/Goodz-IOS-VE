//
//  SortModel.swift
//  Goodz
//
//  Created by Akruti on 11/01/24.
//

import Foundation
struct SortModel: Codable {
    
    let sortTitle, sortId: String?
    
    enum CodingKeys: String, CodingKey {
        case sortTitle = "sort_title"
        case sortId = "sort_id"
        
    }
}
