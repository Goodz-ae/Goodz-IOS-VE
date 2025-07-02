//
//  NotificationRepo.swift
//  Goodz
//
//  Created by vtadmin on 20/02/24.
//

import Foundation
import UIKit
import Alamofire

enum NotificationRouter: RouterProtocol {
    
    case notificationListAPI(pageNo : Int)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .notificationListAPI :
            return APIEndpoint.getPushNotificationList
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .notificationListAPI(pageNo: let pageNo):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description
                
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class NotificationRepo {
    
    func notificationListAPI(pageNo : Int, _ completion: @escaping((_ status: Bool, _ data: [NotificationListResult]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: NotificationRouter.notificationListAPI(pageNo: pageNo), responseModel: [ResponseModel<NotificationListResult>].self) { result in
            
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
            notifier.hideLoader()
        }
    }
}
