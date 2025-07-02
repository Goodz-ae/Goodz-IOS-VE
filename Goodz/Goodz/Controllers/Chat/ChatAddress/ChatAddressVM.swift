//
//  ChatAddressVM.swift
//  Goodz
//
//  Created by Akruti on 22/02/24.
//

import Foundation
class ChatAddressVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ChatListRepo()
    var arrTimeSlot : [TimeSlotModel] = []
    
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func getPickupAddressAPI(chatId : String, toId : String, completion: @escaping((Bool, PickUpAddressModel) -> Void)) {
        self.repo.getPickupAddressAPI(chatId: chatId, toId) { status, data, error in
            if status, let res = data?.first {
                completion(status, res)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(status, PickUpAddressModel(address: PickUpAddress(addressID: "", fullName: "", mobile: "", countryCode: "", cityID: "", city: "", areaID: "", area: "", floor: "", streetAddress: ""), timeSlotID: "", timeSlot: "", pickupDate: ""))
            }
        }
    }
    
    // --------------------------------------------
    
    func setPickupAddressAPI(chatId : String, toId : String, addressId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.setPickupAddressAPI(chatId: chatId, toId: toId, addressId: addressId) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
}
