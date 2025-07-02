//
//  ChatListRepo.swift
//  Goodz
//
//  Created by Akruti on 05/02/24.
//

import Foundation
import UIKit
import Alamofire

enum ChatListRouter: RouterProtocol {
    
    case getChatListAPI(search : String,pageNo : Int)
    case getChatDetailsAPI(pageNo : Int, chatId: String)
    case sendMessageAPI(messageData : SendMessage)
    
    case offerAcceptDeclineAPI(chatId : String, acceptStatus : String, sellerId : String)
    case contactUsChatAPI(chatId : String, message: String, bundleId : String, productId : String)
    case getTimeSlotsAPI
    case setPickupDateTimeAPI(chatId : String, date: String, timeSlotId: String, toId : String, isSelectPickupAddress: String)
    case getPickupAddressAPI(chatId : String, toId : String)
    case setPickupAddressAPI(chatId : String, toId : String, addressId : String)
    case proceedToCheckoutAPI(chatId : String, toId : String, productId : String = "", bundleId : String = "", isFromBundle : String = "")
    case chat_update_pickup_availability(messageData : ConfirAvailbelity)
    case chat_confirm_pickup_slot(messageData : ConfirPickSlotModel)
    case confrimReception(param : ConfrimReception)
    case chat_add_pickup_slots(param : slotBookingModel)
    case chat_add_pickup_slots2
    case reportProblem(user_id : String, tell_us : String,  img : UIImage?)
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .getChatListAPI :
            return APIEndpoint.getChatList
        case .getChatDetailsAPI :
            return APIEndpoint.getChatDetails
        case .sendMessageAPI :
            return APIEndpoint.sendMessage
        case .offerAcceptDeclineAPI :
            return APIEndpoint.offerAcceptDecline
        case .contactUsChatAPI :
            return APIEndpoint.contactUsChat
        case .getTimeSlotsAPI :
            return APIEndpoint.getTimeSlots
        case .setPickupDateTimeAPI :
            return APIEndpoint.setPickupDateTime
        case .getPickupAddressAPI :
            return APIEndpoint.getPickupAddress
        case .setPickupAddressAPI :
            return APIEndpoint.setPickupAddress
        case .proceedToCheckoutAPI :
            return APIEndpoint.proceedToCheckout
        case .chat_update_pickup_availability :
            return APIEndpoint.chat_update_pickup_availability
        case .chat_confirm_pickup_slot :
            return APIEndpoint.chat_confirm_pickup_slot
            
        case .confrimReception :
            return APIEndpoint.confirm_reception
            
        case  .chat_add_pickup_slots :
            return APIEndpoint.chat_add_pickup_slots
        case  .chat_add_pickup_slots2 :
            return APIEndpoint.chat_add_pickup_slots
        case .reportProblem :
            return APIEndpoint.reportProblem
        }
        
    }
    
     
    
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getChatListAPI(let search, let pageNo):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.search : search
            ]
        case .getChatDetailsAPI(pageNo: let pageNo, chatId: let chatId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.chatId : chatId
            ]
        case .offerAcceptDeclineAPI(chatId: let chatId, acceptStatus: let acceptStatus, sellerId: let sellerId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.chatId : chatId,
                ParameterKey.acceptStatus : acceptStatus,
                ParameterKey.toId : sellerId
            ]
        case .contactUsChatAPI(chatId: let chatId, message: let message, bundleId: let bundleId, productId: let productId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.chatId : chatId,
                ParameterKey.message : message,
                ParameterKey.bundleId : bundleId,
                ParameterKey.productId : productId
            ]
        case .getTimeSlotsAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .setPickupDateTimeAPI(chatId: let chatId, date: let date, timeSlotId: let timeSlotId, toId: let toId, isSelectPickupAddress : let isSelectPickupAddress):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.chatId : chatId,
                ParameterKey.toId : toId,
                ParameterKey.date : date,
                ParameterKey.timeSlotId : timeSlotId,
                ParameterKey.isSelectPickupAddress : isSelectPickupAddress
            ]
        case .getPickupAddressAPI(chatId: let chatId, toId: let toId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.toId : toId,
                ParameterKey.chatId : chatId
            ]
        case .setPickupAddressAPI(chatId: let chatId, toId: let toId, let addressId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.toId : toId,
                ParameterKey.chatId : chatId,
                ParameterKey.addressId : addressId
            ]
        case .proceedToCheckoutAPI(chatId: let chatId, toId: let toId, productId: let productId, bundleId: let bundleId, isFromBundle : let isFromBundle):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.toId : toId,
                ParameterKey.chatId : chatId,
                ParameterKey.productId : productId,
                ParameterKey.bundleId : bundleId,
                ParameterKey.isFromBundle : isFromBundle
            ]
        case .sendMessageAPI(messageData: let messageData):
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.chatId : messageData.chatId,
                ParameterKey.toId : messageData.toId,
                ParameterKey.messageType : messageData.messageType,
                ParameterKey.message : messageData.message,
                ParameterKey.name : messageData.name
            ]
            if let url = messageData.url {
                params[ParameterKey.file] = url
            }
            
            return params
        case .chat_update_pickup_availability(messageData: let availblity) :
            let params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.chatId : availblity.chat_id,
                ParameterKey.availableVal  : availblity.available,
                ParameterKey.deliveryMethod  : availblity.deliveryMethod
                
                
            ]
            return params
            
        case .chat_confirm_pickup_slot(messageData: let availblity) :
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.chatId_ : availblity.chat_id,
                ParameterKey.choosen_pickup_time  : availblity.choosen_pickup_time,
                ParameterKey.choosen_pickup_date : availblity.choosen_pickup_date
                
            ]
            
            if let _messageId = availblity.messageId , _messageId != "" {
                params[ParameterKey.messageId] =  _messageId
            }
            return params
            
        case .confrimReception(param : let  availblity):
            
            let params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.order_id : availblity.order_id,
                ParameterKey.token : UserDefaults.accessToken
            ]
            return params
            
        case .chat_add_pickup_slots(param : let  availblity):
            
            let params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.pickup_chat_id : availblity.pickup_chat_id,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.selected_slots : availblity.selected_slots,
                ParameterKey.message_id : ""
            ]
            return params
        case .chat_add_pickup_slots2 :
            
            let params: [String: Any] = [ :
                                            
            ]
            return params
            
        case .reportProblem(user_id : let user_id, tell_us : let tell_us ,  img : let img) :
            
            var params: [String: Any] = [
                ParameterKey.user_id : user_id,
                ParameterKey.tell_us : tell_us,
                ParameterKey.token : UserDefaults.accessToken,
               
            ]
            if let _img =   img   {
                params[ParameterKey.attachment ] =  _img
            }
            
            return params
            
        }
    }
    
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class ChatListRepo {
    static let shared : ChatListRepo = ChatListRepo()
    
    func getChatListAPI(search : String,_ pageNo : Int,_ completion: @escaping((_ status: Bool, _ data: [ChatListModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        NetworkManager.dataRequest(with: ChatListRouter.getChatListAPI(search: search, pageNo: pageNo), responseModel: [ResponseModel<ChatListModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message, 0)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil, Int(firstResponse.totalRecords  ?? "0") ?? 0)
                } else {
                    completion(false, nil, response.first?.message ?? "", 0)
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message, 0)
            }
        }
    }
    
    func getChatDetailsAPI(isShowLoader : Bool,pageNo : Int, chatId: String ,_ completion: @escaping((_ status: Bool, _ data: [ChatDetailModel]?,_  maiData : ChatMainResponse, _ error: String?, _ totalRecords : Int) -> Void)) {
        if !isShowLoader {
            notifier.showLoader()
        }
        NetworkManager.dataRequest(with: ChatListRouter.getChatDetailsAPI(pageNo: pageNo, chatId: chatId), responseModel: [ResponseModel<ChatDetailModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, ChatMainResponse(isBundleChat: "", isSeller: "", offerReceived: "", paymentDone: "", offerAccepted: "",isSelectPickupDate: "", isSelectPickupAddress: "", deliveryMethod: "", bundleId: "", bundleSellingPrice: "",  bundleOriginalPrice: "",  bundleForYouPrice: "", isOfferSend: ""), LocalErrors.nullResponse.message, 0)
                
                    
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    let dataChatMainResponse = ChatMainResponse(isBundleChat: firstResponse.isBundleChat ?? "", isSeller: firstResponse.isSeller ?? "", offerReceived: firstResponse.offerReceived ?? "", paymentDone: firstResponse.paymentDone ?? "", offerAccepted: firstResponse.offerAccepted ?? "",isSelectPickupDate: firstResponse.isSelectPickupDate ??  "", isSelectPickupAddress: firstResponse.isSelectPickupAddress ?? "", deliveryMethod: firstResponse.deliveryMethod ??  "", bundleId: firstResponse.bundleId ??  "", bundleSellingPrice: firstResponse.bundleSellingPrice ??  "",  bundleOriginalPrice: firstResponse.bundleOriginalPrice ??  "",  bundleForYouPrice: firstResponse.bundleForYouPrice ??  "", isOfferSend: firstResponse.isOfferSend ??  "")
                    completion(true, firstResponse.result, dataChatMainResponse,nil, Int(firstResponse.totalRecords  ?? "0") ?? 0)
                } else {
                    completion(false, nil,ChatMainResponse(isBundleChat: "", isSeller: "", offerReceived: "", paymentDone: "", offerAccepted: "",isSelectPickupDate: "", isSelectPickupAddress: "", deliveryMethod: "", bundleId: "",  bundleSellingPrice: "", bundleOriginalPrice: "",  bundleForYouPrice: "", isOfferSend: ""), response.first?.message ?? "", 0)
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil,ChatMainResponse(isBundleChat: "", isSeller: "", offerReceived: "", paymentDone: "", offerAccepted: "",isSelectPickupDate: "", isSelectPickupAddress: "", deliveryMethod: "", bundleId: "",  bundleSellingPrice: "", bundleOriginalPrice: "",  bundleForYouPrice: "", isOfferSend: ""), LocalErrors.serverError(error.errorMessage()).message, 0)
            }
            if !isShowLoader {
                notifier.hideLoader()
            }
        }
    }
    
    func sendMessageAPI(messageData : SendMessage,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: ChatListRouter.sendMessageAPI(messageData: messageData), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
 
    func reportProblem(user_id : String, tell_us : String,  img : UIImage?,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
        
        NetworkManager.multiFormDataRequest(with: ChatListRouter.reportProblem(user_id: user_id, tell_us: tell_us, img: img), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
    func chat_add_pickup_slots(param : slotBookingModel,_   completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
        let jsonDataStr = param.getJsonString
        let rawData = jsonDataStr?.data(using: .utf8)
        
        NetworkManager.rawDataRequest(with: ChatListRouter.chat_add_pickup_slots2, rawData: rawData, responseModel: [ResponseModelOne].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
               
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
    func chat_update_pickup_availability(messageData : ConfirAvailbelity,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)){
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: ChatListRouter.chat_update_pickup_availability(messageData: messageData), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func confrimReception(param : ConfrimReception,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)){
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: ChatListRouter.confrimReception(param: param), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func chat_confirm_pickup_slot(messageData : ConfirPickSlotModel,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)){
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: ChatListRouter.chat_confirm_pickup_slot(messageData: messageData), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func offerAcceptDeclineAPI(chatId : String, acceptStatus : String, sellerId : String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.offerAcceptDeclineAPI(chatId: chatId, acceptStatus: acceptStatus, sellerId: sellerId), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func contactUsChatAPI(chatId : String, message: String, bundleId : String, productId : String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.contactUsChatAPI(chatId: chatId, message: message, bundleId: bundleId, productId: productId), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func setPickupDateTimeAPI(chatId : String, date: String, timeSlotId: String, toId : String, isSelectPickupAddress: String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.setPickupDateTimeAPI(chatId: chatId, date: date, timeSlotId: timeSlotId, toId: toId, isSelectPickupAddress: isSelectPickupAddress), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func getTimeSlotsAPI(_ completion: @escaping((_ status: Bool, _ data: [TimeSlotModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.getTimeSlotsAPI, responseModel: [ResponseModel<TimeSlotModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil)
                } else {
                    completion(false, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func setPickupAddressAPI(chatId : String, toId : String, addressId : String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.setPickupAddressAPI(chatId: chatId, toId: toId, addressId: addressId), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func proceedToCheckoutAPI(chatId : String, toId : String, productId: String = "", bundleId: String = "", isFromBundle: String, _ completion: @escaping((_ status: Bool, _ data: [MyAddressModel]? , _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.proceedToCheckoutAPI(chatId: chatId, toId: toId, productId: productId, bundleId: bundleId, isFromBundle: isFromBundle), responseModel: [ResponseModel<AddressListModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, (Int(firstResponse.code ?? "0") ?? 0) > 0 {
                    completion(true, firstResponse.result?.first?.address, nil)
                } else {
                    completion(false, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func proceedToCheckoutAPI1(chatId : String, toId : String, productId: String = "", bundleId: String = "", isFromBundle: String, _ completion: @escaping((_ status: Bool , _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.proceedToCheckoutAPI(chatId: chatId, toId: toId, productId: productId, bundleId: bundleId, isFromBundle: isFromBundle), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, (Int(firstResponse.code ?? "0") ?? 0) > 0 {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func getPickupAddressAPI(chatId : String,_ toId : String,_ completion: @escaping((_ status: Bool, _ data: [PickUpAddressModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.getPickupAddressAPI(chatId: chatId, toId: toId), responseModel: [ResponseModel<PickUpAddressModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil)
                } else {
                    completion(false, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
}


struct ChatMainResponse {
    let isBundleChat : String
    let isSeller : String
    let offerReceived : String
    let paymentDone : String
    let offerAccepted : String
    let isSelectPickupDate : String
    let isSelectPickupAddress : String
    let deliveryMethod : String
    let bundleId :String
    let bundleSellingPrice: String
    let bundleOriginalPrice: String
    let bundleForYouPrice: String
    let isOfferSend: String
}
