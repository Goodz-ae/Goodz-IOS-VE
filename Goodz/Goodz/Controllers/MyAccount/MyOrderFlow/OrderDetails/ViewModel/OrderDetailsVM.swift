//
//  OrderDetailsVM.swift
//  Goodz
//
//  Created by Akruti on 30/01/24.
//

import Foundation
class OrderDetailsVM {
    

    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = OrderDetailsRepo()
    var orderDetails : OrderDetailsResult?
    var orderListResultModel: OrderListResult?
    var sellListResultModel: SellListResult?
    var arrOrderItemList = [OrderItem]()
    var arrChat : [MessageModel]?
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetch(orderId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.confirmReceptionAPI(orderId: orderId) { status, error in
            completion(status)
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
        }
    }
    
    // --------------------------------------------
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchOrderDetails(orderId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.orderDetailsAPI(orderId: orderId) { status, data, error in
            if status , let orderDetailsData = data?.first {
                self.orderDetails = orderDetailsData
                self.updateChat()
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func updateChat(){
        
        arrChat?.removeAll()
        
        let isSeller = (self.orderDetails?.itemToConfirm?.owner_id ?? "") ==  UserDefaults.userID ? "1" : "0"
        
        self.arrChat =  [(MessageModel(productDetails:self.orderDetails?.itemToConfirm  , is_seller : isSeller  , delivery_method:orderDetails?.itemToConfirm?.delivery_method ?? ""  , buyerName :self.orderDetails?.itemToConfirm?.byuer_name   , slotOptions : self.orderDetails?.slotOptions , slot_message_id : self.orderDetails?.itemToConfirm?.slot_message_id ))]
        
    }
    
    func fetchSellDetails(sellId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.sellDetailsAPI(sellId: sellId) { status, data, error in
            if status , let orderDetailsData = data?.first {
                self.orderDetails = orderDetailsData
                self.updateChat()
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // Function to download the pdf
    func downloadAndSavePDF(from url: URL, completion: @escaping((Bool) -> Void)) {
        let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
            guard let tempURL = tempURL, error == nil else {
                print("Download error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            do {
                let fileManager = FileManager.default
                let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                
                // Remove existing file if it already exists
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                
                // Move downloaded file to Documents directory
                try fileManager.moveItem(at: tempURL, to: destinationURL)
                print("File saved at: \(destinationURL)")
                
                // Optionally, show an alert to confirm the file is downloaded
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Error saving file: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    func chat_update_pickup_availability(messageData : ConfirAvailbelity,_ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.chat_update_pickup_availability(messageData: messageData) { status, error in
            if !status {
                notifier.showToast(message: appLANG.retrive(label: error ?? "4r"))
            }
            completion(status)
        }
    }
    
    func chat_confirm_pickup_slot(messageData : ConfirPickSlotModel,_ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.chat_confirm_pickup_slot(messageData: messageData) { status, error in
            if !status {
                notifier.showToast(message: appLANG.retrive(label: error ?? "4r"))
            }
              
            completion(status)
        }
    }
    
    
    func confrimReception(param : ConfrimReception ,_ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.confrimReception(param: param) { status, error in
            if !status {
                notifier.showToast(message: appLANG.retrive(label: error ?? "4r"))
            }
            completion(status)
        }
    }
    
    func chat_add_pickup_slots(param : slotBookingModel ,_ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.chat_add_pickup_slots(param: param) { status, error in
            if !status {
                notifier.showToast(message: appLANG.retrive(label: error ?? "4r"))
            }
            completion(status)
        }
    }
    
    

}
