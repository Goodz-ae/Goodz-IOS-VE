//
//  ChatDropDownModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 20/12/23.
//

import UIKit

struct ChatDropDownModel {
    let image: UIImage
    let title: String
    
    static func listDropDown() -> [ChatDropDownModel] {
        return [
            ChatDropDownModel(image: .icBlockUser, title: Labels.block + "Alexandre"),
            ChatDropDownModel(image: .icReportUser, title: Labels.report + "Alexandre"),
            ChatDropDownModel(image: .icDelete, title: Labels.delete)
        ]
    }
    
}
