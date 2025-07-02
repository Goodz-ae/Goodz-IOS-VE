//
//  HomeRepo.swift
//  Goodz
//
//  Created by Akruti on 24/01/24.
//

import Foundation
import UIKit
import Alamofire

enum HomeRouter: RouterProtocol {
    
    case homeAPI(pageNo : Int)
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .homeAPI:
            return APIEndpoint.home
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .homeAPI(pageNo: let pageNo):
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


class HomeRepo {
    func homeAPI(pageNo : Int,_ completion: @escaping((_ status: Bool, _ data: [HomeModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: HomeRouter.homeAPI(pageNo: pageNo), responseModel: [HomeModel].self) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message, 0)
                    return
                }
                completion(true, response, nil, Int(response.first?.totalRecords ?? "0") ?? 0)
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message, 0)
            }
            notifier.hideLoader()
        }
    }
}
