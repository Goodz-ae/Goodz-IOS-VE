//
//  Enum.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//

import UIKit

enum SellItemType {
    case goodsPro
    case goodsDefault
}

enum ProductDetailType {
    case goodsDefault
    case bundle
    case sell
    case goodsPro
    case orderDetails
    case saleDetails
}

enum AttachType : String {
    case camera = "Camera"
    case phoneLibrary = "Phone Library"
    case video = "Video"
    case file = "File"
    case multpleSelection = "Mulltiple Photos"
}

enum FontName : String {
    case black = "Poppins-Black"
    case bold = "Poppins-Bold"
    case extraBold = "Poppins-ExtraBold"
    case extraLight = "Poppins-ExtraLight"
    case italic = "Poppins-Italic"
    case light = "Poppins-Light"
    case medium = "Poppins-Medium"
    case regular = "Poppins-Regular"
    case semibold = "Poppins-SemiBold"
    case thin = "Poppins-Thin"
    
}

/// User Type : `Buyer` `Seller`
enum UserType {
    case buyer
    case seller
}

enum FontSize : CGFloat {
    case size8 = 8.0
    case size10 = 10.0
    case size12 = 12.0
    case size13 = 13.0
    case size14 = 14.0
    case size16 = 16.0
    case size17 = 17.0
    case size18 = 18.0
    case size20 = 20.0
    case size22 = 22.0
    case size24 = 24.0
    case size26 = 26.0
    case size28 = 28.0
    case size30 = 30.0
    case size32 = 32.0
    case size52 = 52.0
}

enum TxtType: Int {
    case normal = 0
    case password = 1
    case phoneNumber = 2
    case dropDown = 3
    case noTitle = 4
    case dropDownWithoutImage = 5
    case normalWithoutImage = 6
    case rightButton = 7
}

enum AppStoryBoards : String {
    case main       = "Main"
    case auth       = "Authentication"
    case home       = "Home"
    case myAccount  = "MyAccount"
    case chat       = "Chat"
    case sell       = "Sell"
    case favourite  = "Favourite"
    var load : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

enum CmsType : String {
    
    case aAboutUs = "1"
    case aPrivacyPolicy = "3"
    case aTermsConditions = "2"
    case aTermsConditionsBusiness = "4"
    case aHelp = "5"
    case aHowToUseThisApp = "6"
    case aCopyright = "7"
    case aContactUs = "8"
}

enum UploadType: String {
    
    case profilePhoto = "1"
    
}

enum UploadFileType: String {
    
    case none = ""
    
    case image = "1"
    case document = "2"
}

enum BoolType : String {
    case strTrue = "1"
    case strFalse = "0"
}

enum UploadMedia : String {
    /// sell items
    case image = "1"
    case video = "2"
}

enum OrderDetialsType {
    case deliver
    case inTransit
    case salesDelivered
    case salesInTransit
    case orderSummary
}

enum OrderDetials {
    case myOrderList
    case sellerBuyList
}

enum ScreenType {
    case defaultScreen
    case forgotPassword
    case changeEmail
    case changeMobile
}

enum NodataType {
    
    case nothingHere, myAdsEmptyData, inBoxEmptyData, productEmptyData, noReview, noFollowers, nothingHereOrder, noNotificationHere
    
    var title: String {
        switch self {
        case .nothingHere, .nothingHereOrder:
            return Labels.nothingHere
        case .noNotificationHere:
            return Labels.no_notification_found
        case .myAdsEmptyData:
            return Labels.toUseAdsFeaturesYouShouldHaveAtLeastOneProductUploadedInYourStore
        case .inBoxEmptyData:
            return Labels.noMessagesYet
        case .productEmptyData:
            return Labels.noResultFound
        case .noReview:
            return Labels.noReviewsYet
        case .noFollowers:
            return Labels.noFollowers
        }
    }
    
    var image: UIImage {
        switch self {
        case .nothingHere:
            return UIImage.nothingHere
        case .myAdsEmptyData:
            return UIImage.myAdsEmptyData
        case .inBoxEmptyData:
            return UIImage.imgInboxEmpty
        case .noNotificationHere:
            return UIImage.imgInboxEmpty
        case .productEmptyData:
            return UIImage.imgProductEmptydata
        case .noReview:
            return UIImage.noReviews
        case .noFollowers:
            return UIImage.noFollower
        case .nothingHereOrder:
            return UIImage.noOrder
        }
    }
    
    var shouldAllowScroll: Bool {
//        switch self {
//        case .nothingHere, .myAdsEmptyData, .inBoxEmptyData, .productEmptyData, noReview, noFollowers:
            return false
            
        
//        }
    }
}

enum HomeDataTitle : String {
    case goodzDeals = "Goodz Deals"
    case popularProducts = "Popular products"
    case popularStore = "Popular Stores"
    
}

enum SortType  {
    case productList, review, order, sales, transaction
    
    var title: String {
        switch self {
        case .productList:
            return "product_list"
        case .review:
            return "review"
        case .order:
            return "order"
        case .sales:
            return "sales"
        case .transaction:
            return "transaction"
        }
    }
}
enum OrderCompleteType {
    case confirmation, completion, subscription, boostStore, boostItem, sellAnItem, paymentFail
}

enum TelrPaymentType {
   case boostStore, boostItem, cart, bundle, other
}
enum OpenStyle {
    case similar
    case other
    case popularProduct
    case popularStore
    case goodzDeals
    case popularStoresProducts
}

enum LoginType : String {
    case none = "none"
    case loginwithemail = "loginwithemail"
    case apple = "3"
    case facebook = "2"
    case google = "1"
}
 

enum AccountMenuOptions: CaseIterable {
    
    case profile
    case goodzPro
    case myStore
    case myOrders
    case myWallet
    case myAds
    case bundles
    case uploadYourDocuments
    case customization
    case notifications
    case helpCenter
    case settings
    case version
    
    var title: String {
        
        switch self {
            
        case .profile:
            return ""
        case .goodzPro:
            return Labels.goodzPro
        case .myStore:
            return Labels.myStore
        case .myOrders:
            return Labels.myOrders
        case .myWallet:
            return Labels.myWallet
        case .myAds:
            return Labels.myAds
        case .bundles:
            return "My Bundles"
        case .uploadYourDocuments:
            return "My Documents"
        case .customization:
            return Labels.customization
        case .notifications:
            return Labels.notifications
        case .helpCenter:
            return Labels.helpCenter
        case .settings:
            return Labels.settings
        case .version:
            return Labels.version
        }
        
    }
    
    var icon: UIImage?  {
        switch self {
        case .profile:
            return .profile
        case .goodzPro:
            return .iconGoodz
        case .myStore:
            return .iconStore
        case .myOrders:
            return .iconOrders
        case .myWallet:
            return .iconWallet
        case .myAds:
            return .iconAds
        case .bundles:
            return .iconBundles
        case .uploadYourDocuments:
            return .iconUploadBig
        case .customization:
            return .iconCustomization
        case .notifications:
            return .iconNotification
        case .helpCenter:
            return .iconHelpcenter
        case .settings:
            return .iconSetting
        case .version:
            return .iconHelpcenter
        }
    }
    
    var rightIcon: UIImage? {
        switch self {
        case .profile:
            return .iconEdit
        case .goodzPro, .myStore, .myOrders, .myWallet, .myAds, .bundles,  .uploadYourDocuments ,.customization, .notifications, .helpCenter, .settings, .version:
            return .iconRight
        }
    }
    
}

enum SettingMenuOptions: CaseIterable {
    
   // case uploadYourDocuments
    case security
//    case payment
    case notifications
    case myAddress
    case logout
    case deleteAccount
    var title: String {
        
        switch self {
            
      //  case .uploadYourDocuments:
          //  return Labels.uploadYourDocument
        case .security:
            return Labels.security
//        case .payment:
//            return Labels.payment
        case .notifications:
            return Labels.notificationSettings
        case .myAddress:
            return Labels.myAddress
        case .logout:
            return Labels.logout
        case .deleteAccount:
            return Labels.deleteAccount
        }
        
    }
    
    var icon: UIImage?  {
        switch self {
            
      //  case .uploadYourDocuments:
         //   return .iconUploadBig
        case .security:
            return .iconShield
//        case .payment:
//            return .iconPayment
        case .notifications:
            return .iconNotification
        case .myAddress:
            return .iconMap
        case .logout:
            return .iconLogout
        case .deleteAccount:
            return .iconLogout
        }
    }
    
    var rightIcon: UIImage? {
        switch self {
            
      //  case  .uploadYourDocuments
        case .security,.notifications,.myAddress,.logout, .deleteAccount:
            return .iconRight
        }
    }
    
}

enum OrderStatus: String, CaseIterable {
    case orderPlaced = "Order Placed"
    case pickedUp = "Picked Up"
    case shipped = "Shipped"
    case inTransit = "In Transit"
    case delivery = "Delivery"

    var orderStatusID: String {
        switch self {
        case .orderPlaced:
            return "1"
        case .pickedUp:
            return "2"
        case .shipped:
            return "3"
        case .inTransit:
            return "4"
        case .delivery:
            return "5"
        }
    }
}

enum OpenPopup {
    case delete
    case hide
    case chatDelete
    case chatReport
    case chatBlock
    case appUpadate
    case forceUpdate
}

enum TextFieldMaxLenth {
    
    case contactNumberMaxLenth
    case contactNumberMinLenth
    case observationHashLength
    case productTitleMaxLength
    case dimentionLenght
    case storeNameMaxLength
    case priorityContactNameMaxLength
    case profileNameMaxLength
    case streetAddressMaxLength
    case floorMaxLength
    
    var length : Int {
        switch self {
        case .productTitleMaxLength:
            return 32
        case .dimentionLenght:
            return 10
        case .storeNameMaxLength:
            return 40
        case .contactNumberMaxLenth:
            return 15
        case .contactNumberMinLenth:
            return 8
        case .observationHashLength:
            return 5
        case .priorityContactNameMaxLength:
            return 50
        case .profileNameMaxLength:
            return 50
        case .streetAddressMaxLength:
            return 50
        case .floorMaxLength:
            return 50
        }
    }
}

enum DeviceType: String {
    case iOS = "0"
    case android = "2"
    
}

enum SellVCUploadBtnType {
    case invoice
    case warranty
}

enum CustomizationType: String {
    
    case brands
    case categories
    
    var id: String {
        switch self {
        case .brands:
            return "1"
        case .categories:
            return "2"
        }
    }
    
    var title: String {
        switch self {
        case .brands:
            return Labels.brands
        case .categories:
            return Labels.categories
        }
    }
}

enum SellVCProductInfoType: CaseIterable {
    
    case brand
    case condition
    case category
    
    var title: String {
        switch self {
        case .brand:
            return Labels.brandStar
        case .condition:
            return Labels.conditionStar
        case .category:
            return Labels.categoryStar
        }
    }
    
    var forwardArrow: Bool {
        switch self {
        case .brand:
            return true
        case .condition:
            return true
        case .category:
            return true
        }
    }
    
    var image: UIImage? {
        switch self {
        case .brand:
            return nil
        case .condition:
            return nil
        case .category:
            return nil
        }
    }
}

enum ContentType {
    case image
    case video
    case pdf
}
enum Status : String {
    case one = "1"
    case zero = "0"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
}

enum OpenWebView {
    case productDetails
    case cms
    case faq
}

enum NotifType : String {
    case uploadDoc = "1"
    case myStoreDetails = "2"
    case orderDetails = "3"
    case mySalesDetails = "4"
    case chatDetails = "5"
    case chatList = "6"
    case trackOrder = "7"
    case myStoreReview1 = "8"
    case myStoreReview2 = "9"
    case myStoreReview3 = "10"
    case notificationList = "11"
    case myStore = "12"
    case myStore2 = "13"
    case otherNotification = "14"
}
