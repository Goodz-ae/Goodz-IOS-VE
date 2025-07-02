//
//  OrderRepo.swift
//  Goodz
//
//  Created by vtadmin on 29/01/24.
//

import Foundation
import UIKit
import Alamofire

enum OrderRouter: RouterProtocol {
    
    case orderListAPI(pageNo : Int, sortID: String)
    case sellListAPI(pageNo : Int, sortID: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .orderListAPI:
            return APIEndpoint.getorders
        case .sellListAPI:
            return APIEndpoint.getSellList
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .orderListAPI(let pageNo, let sortID):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.sortId : sortID
            ]
        case .sellListAPI(let pageNo, let sortID):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.sortId : sortID
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class OrderRepo {
    
    func orderListAPI(_ pageNo : Int,_ sortID : String,_ completion: @escaping((_ status: Bool, _ data: [OrderListResult]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: OrderRouter.orderListAPI(pageNo: pageNo,sortID: sortID), responseModel: [ResponseModel<OrderListResult>].self) { result in
           
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
    
    func sellListAPI(_ pageNo : Int,_ sortID : String, _ completion: @escaping((_ status: Bool, _ data: [SellListResult]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: OrderRouter.sellListAPI(pageNo: pageNo,sortID: sortID), responseModel: [ResponseModel<SellListResult>].self) { result in
           
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
