//
//  ChatDetailModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit

struct ChatModel {
    var chat: String
    var chatTime: String
    var image: UIImage?
    var chatType: ChatType
    
    static func chatList() -> [ChatModel] {
        return [
            ChatModel(chat: "Ok please send me an offer", chatTime: "11:11 AM", chatType: .receiver),
            ChatModel(chat: "Ok please send me an offer. Ok please send me an offer. Ok please send me an offer", chatTime: "11:11 AM", chatType: .sender),
            ChatModel(chat: "Ok please send me an offer. Ok please send me an offer. Ok please send me an offer", chatTime: "11:11 AM", chatType: .receiver),
            ChatModel(chat: "", chatTime: "11:11 AM", image: .ivChair, chatType: .receiveAttachment),
            ChatModel(chat: "Ok please send me an offer", chatTime: "11:11 AM", chatType: .receiver),
            ChatModel(chat: "", chatTime: "", chatType: .offerView)
            //            ChatModel(chat: "", chatTime: "", chatType: .selectedDateView)
        ]
    }
    
    static func chatListBuyer() -> [ChatModel] {
        return [
            ChatModel(chat: "Ok please send me an offer", chatTime: "11:11 AM", chatType: .receiver),
            ChatModel(chat: "Ok please send me an offer. Ok please send me an offer. Ok please send me an offer", chatTime: "11:11 AM", chatType: .sender),
            ChatModel(chat: "Ok please send me an offer. Ok please send me an offer. Ok please send me an offer", chatTime: "11:11 AM", chatType: .receiver),
            ChatModel(chat: "", chatTime: "11:11 AM", image: .ivAdvertise, chatType: .receiveAttachment),
            ChatModel(chat: "Ok please send me an offer", chatTime: "11:11 AM", chatType: .receiver),
            ChatModel(chat: "", chatTime: "", chatType: .offerView)
            
        ]
    }
    
}

enum ChatType {
    case sender
    case receiver
    case sendAttachment
    case receiveAttachment
    case other /// Default message of action
    case checkOut /// `Contact Us` & `Choose a Pickup Date`
    case suggestion /// Suggestion footer view
    case offerView /// Make an offer view : footer view
    case selectedDateView
}
