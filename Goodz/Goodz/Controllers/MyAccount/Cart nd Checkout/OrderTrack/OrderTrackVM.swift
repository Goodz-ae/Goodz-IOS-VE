//
//  OrderTrackVM.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
import UIKit

class OrderTrackVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var  arrStatus : [OrderTrackModel] = []
    var fail: BindFail?
    var repo = OrderTrackRepo()
    var arrOderStatuts : [OrderTrackDataModel] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData() {
        self.arrStatus = [OrderTrackModel(data: Labels.orderPlaced, status: "09/05/23, 11:00PM", isDone: true, imgDeselct: .placedDeselect, imgSelect: .placedSelect),
                          OrderTrackModel(data: Labels.pickedUp, status: "09/05/23, 11:00PM", isDone: true, imgDeselct: .shippedDeselect, imgSelect: .shippedSelect),
                          OrderTrackModel(data: Labels.shipped, status: "09/05/23, 11:00PM", isDone: false, imgDeselct: .shippedDeselect, imgSelect: .shippedSelect),
                          OrderTrackModel(data: Labels.inTransit, status: "09/05/23, 11:00PM", isDone: false, imgDeselct: .intransitDeselect, imgSelect: .intransitSelect),
                          OrderTrackModel(data: Labels.delivery, status: "09/05/23, 11:00PM", isDone: false, imgDeselct: .deliveryDeselect, imgSelect: .deliverySelect)]
    }
    
    // --------------------------------------------
    
    func setNumberOfRows() -> Int {
        return self.arrOderStatuts.first?.status.count ?? 0
    }
    
    // --------------------------------------------
    
    func setRowData(row: Int) -> OrderStatusModel {
        return self.arrOderStatuts.first?.status[row] ?? OrderStatusModel(trackStatus: "", date: "", isActive: "")
    }
    
    // --------------------------------------------
    
    func trackOrderStatusAPI(orderID: String,_ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.trackOrderStatusAPI(orderID: orderID) { status, data, error in
            self.arrOderStatuts = data ?? []
            completion(status)
        }
    }
}
