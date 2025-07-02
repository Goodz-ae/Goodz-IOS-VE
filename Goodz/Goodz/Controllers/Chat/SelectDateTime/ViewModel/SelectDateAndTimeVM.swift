//
//  SelectDateAndTimeVM.swift
//  Goodz
//
//  Created by Akruti on 19/02/24.
//

import Foundation
class SelectDateAndTimeVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ChatListRepo()
    var arrTimeSlot : [TimeSlotModel] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func getTimeSlots(completion: @escaping((Bool) -> Void)) {
        self.repo.getTimeSlotsAPI { status, data, error in
            if status, let arr = data {
                self.arrTimeSlot = arr
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func setDateAndTime(chatId : String, date: String, timeSlotId: String, toId : String,isSelectPickupAddress : String, completion: @escaping((Bool) -> Void)) {
        self.repo.setPickupDateTimeAPI(chatId: chatId, date: date, timeSlotId: timeSlotId, toId: toId, isSelectPickupAddress: isSelectPickupAddress) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func numberOfTimeSlots() -> Int {
        self.arrTimeSlot.count
    }
    
    // --------------------------------------------
    
    func setTimeSlots(row : Int) -> TimeSlotModel {
        self.arrTimeSlot[row]
    }
    
    // --------------------------------------------
    
}
