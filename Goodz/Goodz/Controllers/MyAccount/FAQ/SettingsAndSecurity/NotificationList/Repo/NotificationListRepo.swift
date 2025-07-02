//
//  NotificationListRepo.swift
//  Goodz
//
//  Created by Akruti on 23/02/24.
//

import Foundation
import UIKit
import Alamofire

enum NotificationListRouter: RouterProtocol {
    
    case getNotificationStatusList
    case updateNotificationStatusAPI(notificationId: String, status: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .getNotificationStatusList :
            return APIEndpoint.getNotificationStatusList
        case .updateNotificationStatusAPI :
            return APIEndpoint.updateNotificationStatus
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getNotificationStatusList:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .updateNotificationStatusAPI(notificationId: let notificationId, status: let status):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.notificationId : notificationId,
                ParameterKey.status : status
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class NotificationListRepo {
    
    func getNotificationStatusList(_ completion: @escaping((_ status: Bool, _ data: [NotificationListModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: NotificationListRouter.getNotificationStatusList, responseModel: [ResponseModel<NotificationListModel>].self) { result in
            
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
    
    func updateNotificationStatusAPI(notificationId: String,status: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: NotificationListRouter.updateNotificationStatusAPI(notificationId: notificationId, status: status), responseModel: [ResponseModelOne].self) { result in
            
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
}
