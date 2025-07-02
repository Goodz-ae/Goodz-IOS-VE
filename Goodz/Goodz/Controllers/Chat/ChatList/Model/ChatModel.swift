//
//  ChatModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

struct ChatListModel: Codable {
    let userID, name, profileImage, chatID: String?
    let unreadMessageCount, lastMessage, lastMessageDateTime, isBlocked: String?
    let isBuyerSeller, messageType, productName: String?
    
    enum CodingKeys: String, CodingKey {
        
        case userID = "user_id"
        case name
        case profileImage = "profile_image"
        case chatID = "chat_id"
        case unreadMessageCount = "unread_message_count"
        case lastMessage = "last_message"
        case lastMessageDateTime = "last_message_date_time"
        case isBlocked = "is_blocked"
        case isBuyerSeller = "is_buyer_seller"
        case messageType = "message_type"
        case productName = "product_name"
    }
}

// MARK: - Welcome
struct ChatDetailModel: Codable {
    var userID, name: String?
    var profileImage: String?
    var chatID, isBlocked, storeID, blockedUserID: String?
    var messages: [MessageModel]?
    var products: [ChatProductModel]?
    var itemToConfirm: ItemToConfirm?
   // var is_seller , delivery_method: String?
    var slot_message_id : String?
    var slotOptions  : [OptionsSlotBooking]?
    
    enum CodingKeys: String, CodingKey {
       // case delivery_method = "delivery_method"
       // case is_seller = "is_seller"
        case slot_message_id = "slot_message_id"
        case itemToConfirm = "itemToConfirm"
        case slotOptions = "slotOptions"
        case userID = "user_id"
        case name
        case profileImage = "profile_image"
        case chatID = "chat_id"
        case isBlocked = "is_blocked"
        case messages, products
        case storeID = "store_id"
        case blockedUserID = "blocked_user_id"
    }
}

// MARK: - Message
struct MessageModel: Codable {
    var id, messageText, messageType, messageURL: String?
    var sendByMe, messageDateTime: String?
    var address: DefaultAddressModel?
    var productDetails : ItemToConfirm?
    var is_seller , delivery_method: String?
    var buyerName : String?
    var slotOptions  : [OptionsSlotBooking]?
    var slot_message_id : String?
    enum CodingKeys: String, CodingKey {
        case slot_message_id = "slot_message_id"
        case id
        case messageText = "message_text"
        case messageType = "message_type"
        case messageURL = "message_url"
        case sendByMe = "send_by_me"
        case messageDateTime = "message_date_time"
        case address
    }
}

struct OptionsSlotBooking : Codable {
    
    var id : Int
    var time_slot : String
    enum CodingKeys: String, CodingKey {
        case id
        case time_slot = "time_slot"
        
    }
    
}
 

struct AddressPickUpModel : Codable {
    
    var floor : String?
    var street_address : String?
    var city : String
    var area : String
    enum CodingKeys: String, CodingKey {
        case floor = "floor"
        case street_address = "street_address"
        case city = "city"
        case area = "area"
    }
    
}



struct DefaultAddressModel: Codable {
    let addressID, fullName, phoneNumber, countryCode: String?
    let cityID, cityName, areaID, areaName: String?
    let floor, streetAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case countryCode = "country_code"
        case cityID = "city_id"
        case cityName = "city_name"
        case areaID = "area_id"
        case areaName = "area_name"
        case floor
        case streetAddress = "street_address"
    }
}


// MARK: - Product
struct ChatProductModel: Codable {
    let productID: Int?
    let productName: String?
    let discountedPrice, orignialPrice: Double?
    let brand: String?
    let brandID: Int?
    let productImg: String?
    let isOwner: String?
    let newOfferPrice: Double?
    let sellingFee: String?
    let forYouPrice: Double?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case discountedPrice = "discounted_price"
        case orignialPrice = "original_price"
        case brand
        case brandID = "brand_id"
        case productImg = "product_img"
        case isOwner = "is_owner"
        case newOfferPrice = "new_offer_price"
        case sellingFee = "selling_fee"
        case forYouPrice = "for_you_price"
    }
}

// send message

struct SendMessage {
    var chatId : String
    var toId : String
    var messageType : MessageType.RawValue
    var message : String
    var url : URL?
    var name : String
}


struct ConfirAvailbelity  {
    //var token : String
    var chat_id : String
    var deliveryMethod : String
    var available : String
    var user_id : String
}


struct ConfrimReception {
    var order_id : String
    var user_id : String
    var token : String
}

struct selected_slotsModel : Codable {
    
    
    var date : String?
    var time_slot_ids : [String]?
    
    
}


struct SlotsDateModel  {
    
    let day: String
    let dateVal : Int
    let date : String
    var optionsSlots : [OptionsSlotBooking]?
    
    
}


struct slotBookingModel : Codable {
    
    var token : String
    var selected_slots : [selected_slotsModel]
    var pickup_chat_id : String
    var message_id : String
    var user_id : String
    
    
}

struct reportProb : Codable {
    var  user_id : String
    var  tell_us : String
    var  attachment : String?
     
    
}

struct slotBookingModelStr  {
    
    var token : String
    var selected_slots : String
    var pickup_chat_id : String
    var message_id : String
    var user_id : String
    
    
}
//[{"date":"2025-05-06","time_slot_ids":["2","4","5"]},{"date":"2025-05-10","time_slot_ids":["2","5"]}]

struct ConfirPickSlotModel  {
    //var token : String
    var chat_id : String
    var choosen_pickup_date : String
    var choosen_pickup_time : String
    var user_id : String
    var messageId : String?
}
  

enum MessageType : String {
    case message = "1"
    case image = "2"
    case video = "3"
    case doc = "4"
    
}
struct TimeSlotModel: Codable {
    let timeSlotID, timeSlot: String?
    
    enum CodingKeys: String, CodingKey {
        case timeSlotID = "time_slot_id"
        case timeSlot = "time_slot"
    }
}
struct PickUpAddressModel: Codable {
    let address: PickUpAddress?
    let timeSlotID, timeSlot, pickupDate: String?
    
    enum CodingKeys: String, CodingKey {
        case address
        case timeSlotID = "time_slot_id"
        case timeSlot = "time_slot"
        case pickupDate = "pickup_date"
    }
}
struct PickUpAddress: Codable {
    let addressID, fullName, mobile, countryCode: String?
    let cityID, city, areaID, area: String?
    let floor, streetAddress: String?

    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case fullName = "full_name"
        case mobile
        case countryCode = "country_Code"
        case cityID = "city_id"
        case city
        case areaID = "area_id"
        case area, floor
        case streetAddress = "street_address"
    }
}
import Foundation
struct ItemToConfirm : Codable {
    let id : String?
    let owner_id : String?
    let order_id : String?
    let date : String
    let name : String?
    let image : String?
    let selling_price : String?
    let new_price : String?
    let type : String?
    let availability_confirmed : Int?
    var slot_message_id : String?
    let pickup_slots : [Pickup_slots]?
    let choosen_pickup_slot : Choosen_pickup_slot?
    let addressPickUpModel : AddressPickUpModel?
    let pickupConfirmed  :  Int?
    
    let owner_name : String?
    let byuer_name : String?
    
    let chat_id         : String?
    let is_seller       : String?
    let is_buyer        : String?
    let delivery_method : String?
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case chat_id = "chat_id"
        case is_seller = "is_seller"
        case is_buyer = "is_buyer"
        case delivery_method = "delivery_method"
        
        case owner_name =  "owner_name"
        case byuer_name  = "byuer_name"
        
        case pickupConfirmed = "pickupConfirmed"
        case date
        case slot_message_id = "slot_message_id"
        case order_id = "order_id"
        case addressPickUpModel = "owner_address"
        case id = "id"
        case owner_id = "owner_id"
        case name = "name"
        case image = "image"
        case selling_price = "selling_price"
        case new_price = "new_price"
        case type = "type"
        case availability_confirmed = "availability_confirmed"
        case pickup_slots = "pickup_slots"
        case choosen_pickup_slot = "choosen_pickup_slot"
    }
 
}
 
 
import Foundation
struct Pickup_slots : Codable {
    let date : String?
    let time_slot : String?
    let id : Int?

    enum CodingKeys: String, CodingKey {
        case id
        case date = "date"
        case time_slot = "time_slot"
    }

}

import Foundation
struct Choosen_pickup_slot : Codable {
    let choosen_pickup_time : String?
    let choosen_pickup_date : String?
    var choosen_slot_id : Int?
    
    enum CodingKeys: String, CodingKey {
        case choosen_slot_id = "choosen_slot_id"
        case choosen_pickup_time = "choosen_pickup_time"
        case choosen_pickup_date = "choosen_pickup_date"
    }
    
    
}


/*
 },
                      {
                          "date": "2025-05-22",
                          "time_slot": "6 pm to 9 pm"
                      }
                  ],
                  "choosen_pickup_slot": {
                      "choosen_pickup_time": "8 am to 11 am",
                      "choosen_pickup_date": "2025-05-19"
                  }

import Foundation

struct Json4Swift_Base : Codable {
    let code : String?
    let message : String?
    let total_records : String?
    let is_bundle_chat : String?
    let bundle_id : String?
    let is_seller : String?
    let payment_done : String?
    let delivery_method : String?
    let offer_received : String?
    let offer_accepted : String?
    let is_select_pickup_date : String?
    let is_select_pickup_address : String?
    let bundle_selling_price : String?
    let bundle_original_price : String?
    let bundle_for_you_price : String?
    let is_offer_send : String?
    let result : [Result]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case total_records = "total_records"
        case is_bundle_chat = "is_bundle_chat"
        case bundle_id = "bundle_id"
        case is_seller = "is_seller"
        case payment_done = "payment_done"
        case delivery_method = "delivery_method"
        case offer_received = "offer_received"
        case offer_accepted = "offer_accepted"
        case is_select_pickup_date = "is_select_pickup_date"
        case is_select_pickup_address = "is_select_pickup_address"
        case bundle_selling_price = "bundle_selling_price"
        case bundle_original_price = "bundle_original_price"
        case bundle_for_you_price = "bundle_for_you_price"
        case is_offer_send = "is_offer_send"
        case result = "result"
    }
}

import Foundation
struct Result : Codable {
    let user_id : String?
    let store_id : String?
    let store_name : String?
    let name : String?
    let is_goodz_pro : String?
    let profile_image : String?
    let chat_id : String?
    let is_blocked : String?
    let blocked_user_id : String?
    let send_by_me : String?
    let messages : [Messages]?
    let products : [Products]?
    let itemToConfirm : ItemToConfirm?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case store_id = "store_id"
        case store_name = "store_name"
        case name = "name"
        case is_goodz_pro = "is_goodz_pro"
        case profile_image = "profile_image"
        case chat_id = "chat_id"
        case is_blocked = "is_blocked"
        case blocked_user_id = "blocked_user_id"
        case send_by_me = "send_by_me"
        case messages = "messages"
        case products = "products"
        case itemToConfirm = "itemToConfirm"
    }
}

import Foundation
struct Messages : Codable {
    let id : String?
    let message_text : String?
    let message_type : String?
    let message_url : String?
    let send_by_me : String?
    let message_date_time : String?
    let newAvailability : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case message_text = "message_text"
        case message_type = "message_type"
        case message_url = "message_url"
        case send_by_me = "send_by_me"
        case message_date_time = "message_date_time"
        case newAvailability = "newAvailability"
    }

}

import Foundation
struct Products : Codable {
    let product_id : Int?
    let product_name : String?
    let discounted_price : Int?
    let original_price : Int?
    let brand : String?
    let brand_id : Int?
    let product_img : String?
    let is_owner : String?
    let new_offer_price : String?
    let selling_fee : String?
    let for_you_price : Int?

    enum CodingKeys: String, CodingKey {

        case product_id = "product_id"
        case product_name = "product_name"
        case discounted_price = "discounted_price"
        case original_price = "original_price"
        case brand = "brand"
        case brand_id = "brand_id"
        case product_img = "product_img"
        case is_owner = "is_owner"
        case new_offer_price = "new_offer_price"
        case selling_fee = "selling_fee"
        case for_you_price = "for_you_price"
    }
}
*/
