//
//  ReportProbVM.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 29/05/25.
//
import Foundation
import Alamofire
import AVFoundation

class ReportProbVM {
    
     
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
     
    var repo = ChatListRepo()
    
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func reportProblemt(tell_us : String , img :UIImage?, _ completion: @escaping ((_ status: Bool) -> Void)){
          
        self.repo.reportProblem(user_id: UserDefaults.userID, tell_us: tell_us, img: img ) { [weak self] status, error in
            if !status {
                notifier.showToast(message: appLANG.retrive(label: error ?? "4r"))
            }else {
                notifier.showToast(message: "Reported problem successfully")
            }
            completion(status)
        }
    }
    
    /*
    func fetchChatDetails(isShowLoader : Bool,page: Int, chatId: String, _ completion: @escaping ((_ status: Bool) -> Void)) {
        self.repo.getChatDetailsAPI(isShowLoader : isShowLoader, pageNo: page, chatId: chatId) { status, data, mainres, error, totalRecords in
            self.totalRecords = totalRecords
            if let chat = data {
                if page == 1, let msg = chat.first?.messages {
                    self.chatDetails = chat
                    self.arrChat = msg
                    let detailsChat = self.chatDetails.first
                    self.productList = self.chatDetails.first?.products
                    if let pList = detailsChat?.itemToConfirm {
                        
                            self.arrChat = self.arrChat?.reversed()
                            
                        self.arrChat!.append(MessageModel(productDetails:pList  , is_seller :mainres.isSeller  , delivery_method:mainres.deliveryMethod , buyerName :chat.first?.name ?? ""   , slotOptions : detailsChat?.slotOptions ))
                            self.arrChat = self.arrChat?.reversed()
                        
                    }
                } else if let newMessages = chat.first?.messages {
                    //                    if !self.chatDetails.isEmpty {
                    //                        if let existingMessages = self.chatDetails[0].messages {
                    //                            self.chatDetails[0].messages = (existingMessages ) + newMessages
                    //                        } else {
                    //                            self.chatDetails[0].messages = newMessages
                    //                        }
                    //                    }
                    
//                    let arr = self.chatDetails[0].messages
//
//                    var newArr = newMessages
//                    newArr.append(contentsOf: (self.chatDetails[0].messages ?? []))
//                    self.chatDetails[0].messages?.append(contentsOf: newMessages)
                    self.arrChat?.append(contentsOf: newMessages)
                    
                }
                self.dataChatMainResponse = mainres
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func setChatMessage() -> Int {
        self.arrChat?.count ?? 0 //chatDetails.first?.messages?.count ?? 0
    }
    
    // --------------------------------------------
    
    func setChatRow(row: Int) -> MessageModel {
        self.arrChat?.reversed()[row] ?? MessageModel(id: "", messageText: "", messageType: "", messageURL: "", sendByMe: "", messageDateTime: "", address: DefaultAddressModel(addressID: "", fullName: "", phoneNumber: "", countryCode: "", cityID: "", cityName: "", areaID: "", areaName: "", floor: "", streetAddress: ""))
    }
    
    // --------------------------------------------
    
    func setProductChat() -> Int {
        self.chatDetails.first?.products?.count ?? 0
    }
    
    // --------------------------------------------
    
    func setProductRow(row: Int) -> ChatProductModel {
        
        if (self.chatDetails.first?.products?.count ?? 0) > 0 {
            return self.chatDetails.first?.products?[row] ?? ChatProductModel(productID: 0, productName: "", discountedPrice: 0, orignialPrice: 0, brand: "", brandID: 0, productImg: "", isOwner: "", newOfferPrice: 0, sellingFee: "", forYouPrice: 0)
        }else {
            return ChatProductModel(productID: 0, productName: "", discountedPrice: 0, orignialPrice: 0, brand: "", brandID: 0, productImg: "", isOwner: "", newOfferPrice: 0, sellingFee: "", forYouPrice: 0)
        }

    }
    
    // --------------------------------------------
    
    func sendMessageAPI(messageData : SendMessage,_ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.sendMessageAPI(messageData: messageData) { status, error in
            if !status {
                notifier.showToast(message: appLANG.retrive(label: error ?? "4r"))
            }
            completion(status)
        }
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
    
    
    
    
    
    
    // --------------------------------------------
    
    //    func sendImage(image : UIImage ,messageData : SendMessage,_ completion: @escaping((_ status: Bool) -> Void)) {
    //        self.repo.sendMessageImageAPI(image: image, messageData: messageData) { status, error in
    //            completion(status)
    //        }
    //    }
    
    // --------------------------------------------
    //    func sendPdf(url : URL ,messageData : SendMessage,_ completion: @escaping((_ status: Bool) -> Void)) {
    //        self.repo.sendMessagePDFAPI(url: url, messageData: messageData) { status, error in
    //            completion(status)
    //        }
    //    }
    //
    // --------------------------------------------
    
    func offerAcceptDeclineAPI(chatId : String, acceptStatus : String, sellerId : String,_ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.offerAcceptDeclineAPI(chatId: chatId, acceptStatus: acceptStatus, sellerId: sellerId) { status, error in
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func proceedToCheckoutAPI(chatId : String, toId: String, productId: String = "", bundleId: String = "", isFromBundle : String,_ completion: @escaping((_ status: Bool, _ address:[MyAddressModel]? ) -> Void)) {
        self.repo.proceedToCheckoutAPI(chatId: chatId, toId: toId, productId: productId, bundleId: bundleId, isFromBundle: isFromBundle) { status, data, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false, data)
            } else {
                completion(true, data)
            }
        }
    }
    func proceedToCheckoutAPI1(chatId : String, toId: String, productId: String = "", bundleId: String = "", isFromBundle : String,_ completion: @escaping((_ status: Bool?) -> Void)) {
        self.repo.proceedToCheckoutAPI1(chatId: chatId, toId: toId, productId: productId, bundleId: bundleId, isFromBundle: isFromBundle) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false)
            } else {
                completion(true)
            }
        }
    }*/
}
