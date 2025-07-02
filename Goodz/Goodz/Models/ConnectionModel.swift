//
//  ConnectionModel.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import Foundation

class ConnectionModel {
    var place : String
    var device : String
    var isActive : Bool
    internal init(place: String, device: String, isActive: Bool) {
        self.place = place
        self.device = device
        self.isActive = isActive
    }
}
