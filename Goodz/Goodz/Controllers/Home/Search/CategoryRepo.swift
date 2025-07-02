//
//  CategoryRepo.swift
//  Goodz
//
//  Created by Akruti on 03/01/24.
//

import Foundation
import UIKit
import Alamofire

enum CategoryRouter: RouterProtocol {
    
    case categoryMainAPI(pageNo : Int)
    case categorySubAPI(pageNo : Int, categoryMainId : String, searchText: String)
    case categoryCollectionAPI(pageNo : Int, categorySubId : String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .categoryMainAPI:
            return APIEndpoint.categoriesMain
        case .categorySubAPI:
            return APIEndpoint.categoriesSub
        case .categoryCollectionAPI:
            return APIEndpoint.categoryCollection
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .categoryMainAPI(let pageNo):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description
            ]
        case .categorySubAPI(let pageNo, let categoriesMainId, let searchText):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.categoriesMainId : categoriesMainId,
                ParameterKey.search : searchText,
                ParameterKey.pageNo : pageNo.description
            ]
        case .categoryCollectionAPI(let pageNo, let categorySubId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.subCategoryId : categorySubId,
                ParameterKey.pageNo : pageNo.description
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
}

class CategoryRepo {
    
    func categoryMainAPI(showLoader : Bool = true,_ pageNo : Int,_ completion: @escaping((_ status: Bool, _ data: [CategoryMainModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        if showLoader {
            notifier.showLoader()
        }
        NetworkManager.dataRequest(with: CategoryRouter.categoryMainAPI(pageNo: pageNo), responseModel: [ResponseModel<CategoryMainModel>].self) { result in
            
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
            if showLoader {
                notifier.hideLoader()
            }
        }
    }
    
    func categoryCollectionAPI(_ pageNo : Int,categoriesSubId : String, _ completion: @escaping((_ status: Bool, _ data: [CategoryCollectionModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: CategoryRouter.categoryCollectionAPI(pageNo: pageNo, categorySubId: categoriesSubId), responseModel: [ResponseModel<CategoryCollectionModel>].self) { result in
            
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
    
    func categorySubAPI(_ pageNo : Int, categoriesMainId : String, searchText: String = "", _ completion: @escaping((_ status: Bool, _ data: [CategorySubModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        // notifier.showLoader()
        NetworkManager.dataRequest(with: CategoryRouter.categorySubAPI(pageNo: pageNo, categoryMainId: categoriesMainId, searchText: searchText), responseModel: [ResponseModel<CategorySubModel>].self) { result in
            
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
            //             notifier.hideLoader()
        }
    }
    
}
