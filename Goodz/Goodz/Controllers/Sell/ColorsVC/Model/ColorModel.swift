//
//  ColorModel.swift
//  Goodz
//
//  Created by Akruti on 19/01/24.
//

import Foundation
class ColorModel: Codable {
    let id, title: String?
    init(id: String?, title: String?) {
        self.id = id
        self.title = title
    }
}
class MaterialModel: Codable {
    let id, title: String?
    init(id: String?, title: String?) {
        self.id = id
        self.title = title
    }
}
