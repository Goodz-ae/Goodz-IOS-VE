//
//  ProductRepo.swift
//  Goodz
//
//  Created by Akruti on 08/01/24.
//

import Foundation
import UIKit
import Alamofire
var kProductListParameter = ProductListParameter(brand: [],
                                                 condition: [],
                                                 priceMax: "",
                                                 priceMin: "",
                                                 color: [],
                                                 material: [],
                                                 mainCategory: CategoryMainModel(categoriesMainTitle: "", categoriesMainId: "", categoriesMainImage: "", isCustomizationSelected: ""),
                                                 subCategory: CategorySubModel(categoriesSubTitle: "", categoriesSubId: "", categoriesSubImage: ""),
                                                 collectionCategory: [],
                                                 dimensionsWidth: "",
                                                 dimensionsWeight: "",
                                                 dimensionsHeight: "",
                                                 dimensionsLength: "",
                                                 sortId: "",
                                                 search: "",
                                                 isGoodzDeals: "",
                                                 storeId: "", isPopular: "")
struct ProductListParameter {
    var brand : [BrandModel]
    var condition : [ConditionModel]
    var priceMax : String
    var priceMin : String
    var color : [ColorModel]
    var material : [ColorModel]
    var mainCategory : CategoryMainModel?
    var subCategory : CategorySubModel?
    var collectionCategory : [CategoryCollectionModel]?
    var dimensionsWidth : String
    var dimensionsWeight : String
    var dimensionsHeight : String
    var dimensionsLength : String
    var sortId : String
    var search : String
    var isGoodzDeals : String
    var storeId : String
    var isPopular : String
}

enum ProductRouter: RouterProtocol {
    
    case productListAPI(pageNo : Int, isGoodzDeal : String, storeId : String, categoryMainId : String, categorySubId : String, categoryCollectionId : String, brandId : String, conditionId : String, colorId : String, materialId : String, dimensionsHeight : String, dimensionsWidth : String, dimensionsLength : String, dimensionsWeight : String, maxPrice : String, minPrice : String, sortId : String, search : String)
    case filterAPI(page: Int, data: ProductListParameter)
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        return APIEndpoint.productList
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .productListAPI(pageNo: let pageNo, isGoodzDeal: let isGoodzDeal, storeId: let storeId, categoryMainId: let categoryMainId, categorySubId: let categorySubId, categoryCollectionId: let categoryCollectionId, brandId: let brandId, conditionId: let conditionId, colorId: let colorId, materialId: let materialId, dimensionsHeight: let dimensionsHeight, dimensionsWidth: let dimensionsWidth, dimensionsLength: let dimensionsLength, dimensionsWeight: let dimensionsWeight, maxPrice: let maxPrice, minPrice: let minPrice, sortId: let sortId, search: let search):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.isGoodzDeal : isGoodzDeal,
                ParameterKey.storeId : storeId,
                ParameterKey.categoriesMainId : categoryMainId,
                ParameterKey.categoriesSubId : categorySubId,
                ParameterKey.categoryCollectionId : categoryCollectionId,
                ParameterKey.brandId : brandId,
                ParameterKey.conditionId : conditionId,
                ParameterKey.colorId : colorId,
                ParameterKey.materialId : materialId,
                ParameterKey.dimensionsHeight : dimensionsHeight,
                ParameterKey.dimensionsWidth : dimensionsWidth,
                ParameterKey.dimensionsLength : dimensionsLength,
                ParameterKey.dimensionsWeight : dimensionsWeight,
                ParameterKey.maxPrice : maxPrice,
                ParameterKey.minPrice : minPrice,
                ParameterKey.sortId : sortId,
                ParameterKey.search : search
            ]
        case .filterAPI(page: let page, data: let data) :
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : page.description,
                ParameterKey.isGoodzDeal : data.isGoodzDeals,
                ParameterKey.storeId : data.storeId,
                ParameterKey.categoriesMainId : data.mainCategory?.categoriesMainId ?? "",
                ParameterKey.categoriesSubId : data.subCategory?.categoriesSubId ?? "",
                ParameterKey.categoryCollectionId : data.collectionCategory?.compactMap { $0.categoryCollectionId }.joined(separator: ","),
                ParameterKey.brandId : data.brand.compactMap { $0.brandID }.joined(separator: ","),
                ParameterKey.conditionId : data.condition.compactMap { $0.conditionID }.joined(separator: ","),
                ParameterKey.colorId : data.color.compactMap { $0.id}.joined(separator: ","),
                ParameterKey.materialId : data.material.compactMap { $0.id }.joined(separator: ","),
                ParameterKey.dimensionsHeight : data.dimensionsHeight,
                ParameterKey.dimensionsWidth : data.dimensionsWidth,
                ParameterKey.dimensionsLength : data.dimensionsLength,
                ParameterKey.dimensionsWeight : data.dimensionsWeight,
                ParameterKey.maxPrice : data.priceMax,
                ParameterKey.minPrice : data.priceMin,
                ParameterKey.sortId : data.sortId,
                ParameterKey.search : data.search,
                ParameterKey.isPopular : data.isPopular
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class ProductRepo {
    
    func productListAPI(pageNo : Int, isGoodzDeal : String, storeId : String, categoryMainId : String, categorySubId : String, categoryCollectionId : String, brandId : String, conditionId : String, colorId : String, materialId : String, dimensionsHeight : String, dimensionsWidth : String, dimensionsLength : String, dimensionsWeight : String, maxPrice : String, minPrice : String, sortId : String, search : String, _ completion: @escaping((_ status: Bool, _ data: [ProductModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ProductRouter.productListAPI(pageNo: pageNo, isGoodzDeal: isGoodzDeal, storeId: storeId, categoryMainId: categoryMainId, categorySubId: categorySubId, categoryCollectionId: categoryCollectionId, brandId: brandId, conditionId: conditionId, colorId: colorId, materialId: materialId, dimensionsHeight: dimensionsHeight, dimensionsWidth: dimensionsWidth, dimensionsLength: dimensionsLength, dimensionsWeight: dimensionsWeight, maxPrice: maxPrice, minPrice: minPrice, sortId: sortId, search: search), responseModel: [ResponseModel<ProductModel>].self) { result in
            
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
    
    func productListAPI(page: Int, data: ProductListParameter, _ completion: @escaping((_ status: Bool, _ data: [ProductModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ProductRouter.filterAPI(page: page, data: data), responseModel: [ResponseModel<ProductModel>].self) { result in
            
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
