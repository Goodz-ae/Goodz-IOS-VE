//
//  AppDelegate+PushNotification.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 21/02/24.
//

import Foundation
import UIKit
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate{
    
    static var dictNotificationData : NSDictionary?
    
    func setupPushNotification(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .alert , .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
//                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            } else {
                print(error as Any)
            }
        }
    }
    
    func firebaseDelegateMathod() {
        
        Messaging.messaging().delegate = self
        
        //Messaging.messaging().isAutoInitEnabled = true
        
        Messaging.messaging().token { token, error in
            
            if let error = error {
                
                print("Remote FCM registration token: \(error)")
                
            } else if let token = token {
                
                print("Remote FCM registration token: \(token)")
                APP_DEL.firebaseDeviceToken = token
                
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
//        AppManager.shared.apnsDeviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token: \(deviceToken.reduce("", {$0 + String(format: "%02X", $1)}))")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Remote FCM registration token: \(fcmToken ?? "")")
        
        APP_DEL.firebaseDeviceToken = fcmToken ?? ""
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let dict = notification.request.content.userInfo as NSDictionary
        let type = NotifType(rawValue: dict["notification_type"] as? String ?? "") ?? .none
        print(dict ?? "-")
        
        if let topVC : UIViewController = UIApplication.topViewController() {
            let chatID = dict["chat_id"] as? String ?? ""
            let orderID = dict["orderID"] as? String ?? ""
            let userID = dict["user_id"] as? String ?? ""
            
            if (type == .chatDetails) && UserDefaults.userID == userID {
                if let vc = topVC as? ChatVC, topVC.isKind(of: ChatVC.self) {
                    vc.apiCalling()
                }else if let vc = topVC as? ChatDetailVC, topVC.isKind(of: ChatDetailVC.self), vc.chatId == chatID {
                    vc.refreshView()
                }else{
                    completionHandler([.list, .banner, .sound, .badge])
                }
            } else if (type == .notificationList) && UserDefaults.userID == userID {
                if let vc = topVC as? NotificationVC, topVC.isKind(of: NotificationVC.self) {
                    vc.apiCallingNotificationList()
                } else {
                    completionHandler([.list, .banner, .sound, .badge])
                }
            } else if (type == .orderDetails) && UserDefaults.userID == userID {
                if let vc = topVC as? OrderVC, topVC.isKind(of: OrderVC.self), vc.isMyOrder {
                    vc.getData()
                } else {
                    completionHandler([.list, .banner, .sound, .badge])
                }
            } else if (type == .mySalesDetails) && UserDefaults.userID == userID {
                if let vc = topVC as? OrderVC, topVC.isKind(of: OrderVC.self), vc.isMyOrder == false {
                    vc.getData()
                } else {
                    completionHandler([.list, .banner, .sound, .badge])
                }
            } else if (type == .trackOrder) && UserDefaults.userID == userID {
                if let vc = topVC as? OrderTrackVC, topVC.isKind(of: OrderTrackVC.self), vc.orderID == orderID {
                    vc.apiCalling()
                } else {
                    completionHandler([.list, .banner, .sound, .badge])
                }
            } else if (type == .myStoreDetails) && UserDefaults.userID == userID {
                if let vc = topVC as? StoreVC, topVC.isKind(of: StoreVC.self) {
                    vc.btnMystore.isSelected = true
                    vc.btnReview.isSelected = false
                    vc.btnFollowers.isSelected = false
                    vc.btnSort.isHidden = true
                    vc.apiStoreDetials()
                    vc.setTopButtons()
                } else {
                    completionHandler([.list, .banner, .sound, .badge])
                }
            } else{
                completionHandler([.list, .banner, .sound, .badge])
            }
        }else{
            completionHandler([.list, .banner, .sound, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let dict = response.notification.request.content.userInfo as NSDictionary
        
        print("didReceive:- ", dict as Any)

        if AppDelegate.dictNotificationData == nil {
            
            APP_DEL.managePushNavigation(dict: dict)
        }
        completionHandler()
    }
}
extension AppDelegate {
    
    func managePushNavigation(dict: NSDictionary? = nil) {
        
        print(dict ?? "-")
        
        AppDelegate.dictNotificationData = nil
        
        let type = NotifType(rawValue: dict?["notification_type"] as? String ?? "") ?? .none
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let topVC : UIViewController = UIApplication.topViewController() {
                
                let chatID = dict?["chat_id"] as? String ?? ""
                let orderID = dict?["orderID"] as? String ?? ""
                let userID = dict?["user_id"] as? String ?? ""
                
                if (type == .chatList) && UserDefaults.userID == userID {
                    
                    if let vc = topVC as? ChatVC, topVC.isKind(of: ChatVC.self) {
//                        vc.apiCalling()
                    } else {
                        topVC.tabBarController?.selectedIndex = 3
                    }
                    
                } else if (type == .chatDetails) && UserDefaults.userID == userID {
                    if let vc = topVC as? ChatDetailVC, topVC.isKind(of: ChatDetailVC.self), vc.chatId == chatID {
                        vc.refreshView()
                    } else {
                        self.coordinator?.navigateToChatDetail(isBlock: false, chatId: chatID, userId: userID)
                    }
                } else if (type == .uploadDoc) && UserDefaults.userID == userID {
                    if let vc = topVC as? UploadDocumentVC, topVC.isKind(of: UploadDocumentVC.self) {
                        vc.apiCalling()
                    } else {
                        self.coordinator?.navigateToUploadDocument(isPro: appUserDefaults.getValue(.isProUser) ?? false)
                    }
                } else if (type == .myStoreDetails) && UserDefaults.userID == userID {
                    if let vc = topVC as? StoreVC, topVC.isKind(of: StoreVC.self) {
                        vc.featchData()
                    } else {
                        self.coordinator?.navigateToStore()
                    }
                } else if (type == .notificationList) && UserDefaults.userID == userID {
                    if let vc = topVC as? NotificationVC, topVC.isKind(of: NotificationVC.self) {

                    } else {
                        self.coordinator?.navigateToNotification()
                    }
                } else if (type == .orderDetails) && UserDefaults.userID == userID {
                    if let vc = topVC as? OrderVC, topVC.isKind(of: OrderVC.self) {
                        vc.checkNotitficationNavigation()
                    } else {
                        self.coordinator?.navigateToMyOrder(isMyOrder: true, orderID: orderID)
                    }
                } else if (type == .mySalesDetails) && UserDefaults.userID == userID {
                    if let vc = topVC as? OrderVC, topVC.isKind(of: OrderVC.self) {
                        vc.checkNotitficationNavigation()
                    } else {
                        self.coordinator?.navigateToMyOrder(isMyOrder: false, orderID: orderID)
                    }
                } else if ((type == .myStoreReview1) || (type == .myStoreReview2) || (type == .myStoreReview3)) && UserDefaults.userID == userID {
                    if let vc = topVC as? StoreVC, topVC.isKind(of: StoreVC.self) {

                    } else {
                        self.coordinator?.navigateToStoreReview()
                    }
                } else if (type == .trackOrder) && UserDefaults.userID == userID {
                    if let vc = topVC as? OrderTrackVC, topVC.isKind(of: OrderTrackVC.self), vc.orderID == orderID {

                    } else {
                        self.coordinator?.navigateToOrderTrack(orderID: orderID)
                    }
                } else if ((type == .myStore) || (type == .myStore2)) && UserDefaults.userID == userID {
                    if let vc = topVC as? StoreVC, topVC.isKind(of: StoreVC.self) {
                        vc.featchData()
                    } else {
                        self.coordinator?.navigateToStore()
                    }
                } else if (type == .otherNotification) && UserDefaults.userID == userID {
                    
                }
            }
        }
    }
}

