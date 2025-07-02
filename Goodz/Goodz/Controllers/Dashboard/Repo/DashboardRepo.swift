//
//  DashboardRepo.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 20/02/24.
//

import Foundation
import Alamofire

enum DashboardRouter: RouterProtocol {

    case totalSaleAPI(sortTotalSales: String)
    case myFiguresStoreAPI(sortSalesByCategory: String)
    case salesByCategoryAPI(sortSalesByCategory: String)
    case storeViewsAPI(sortStoreViews: String)
    case myInvoicesAPI(sortId: String, pageNo: Int)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .totalSaleAPI :
            return APIEndpoint.totalSales
        case .salesByCategoryAPI :
            return APIEndpoint.salesByCategory
        case .myFiguresStoreAPI:
            return APIEndpoint.myFiguresStore
        case .storeViewsAPI :
            return APIEndpoint.storeViews
        case .myInvoicesAPI :
            return APIEndpoint.myInvoices
        }
       
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .totalSaleAPI(sortTotalSales: let sortTotalSales):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.sortTotalSales : sortTotalSales
            ]
        case .myFiguresStoreAPI(sortSalesByCategory: let sortSalesByCategory):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.sortSalesByCategory : sortSalesByCategory
            ]
        case .storeViewsAPI(sortStoreViews: let sortStoreViews):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.sortStoreViews : sortStoreViews
            ]
        case .myInvoicesAPI(sortId: let sortId, pageNo: let pageNo):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.sortId : sortId,
                ParameterKey.pageNo : pageNo
            ]
        case .salesByCategoryAPI(sortSalesByCategory: let sortSalesByCategory):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.sortSalesByCategory : sortSalesByCategory
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}
class DashboardRepo {
    
    func totalSaleAPI(sortTotalSales : String, _ completion: @escaping((_ status: Bool, _ data: [TotalSalesModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: DashboardRouter.totalSaleAPI(sortTotalSales: sortTotalSales), responseModel: [ResponseModel<TotalSalesModel>].self) { result in
            
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
    
    func storeViewsAPI(sortStoreViews : String, _ completion: @escaping((_ status: Bool, _ data: [StoreViewsModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: DashboardRouter.storeViewsAPI(sortStoreViews: sortStoreViews), responseModel: [ResponseModel<StoreViewsModel>].self) { result in
            
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
    
    func myFiguresStoreAPI(sortSalesByCategory : String, _ completion: @escaping((_ status: Bool, _ data: [MyFiguresStoreModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: DashboardRouter.myFiguresStoreAPI(sortSalesByCategory: sortSalesByCategory), responseModel: [ResponseModel<MyFiguresStoreModel>].self) { result in
            
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
    
    func myInvoicesAPI(sortId : String, pageNo : Int, isShowLoader: Bool, _ completion: @escaping((_ status: Bool, _ data: [MyInvoiceModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        if isShowLoader {
            notifier.showLoader()
        }
        NetworkManager.dataRequest(with: DashboardRouter.myInvoicesAPI(sortId: sortId, pageNo: pageNo), responseModel: [ResponseModel<MyInvoiceModel>].self) { result in
            
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
            if isShowLoader {
                notifier.hideLoader()
            }
        }
    }
    
    func salesByCategoryeAPI(sortSalesByCategory : String, _ completion: @escaping((_ status: Bool, _ data: [SalesByCategoryeModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: DashboardRouter.salesByCategoryAPI(sortSalesByCategory: sortSalesByCategory), responseModel: [ResponseModel<SalesByCategoryeModel>].self) { result in
            
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
