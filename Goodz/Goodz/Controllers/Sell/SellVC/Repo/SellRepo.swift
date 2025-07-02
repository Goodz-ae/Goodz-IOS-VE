//
//  SellRepo.swift
//  Goodz
//
//  Created by Akruti on 10/01/24.
//

import Foundation
import UIKit
import Alamofire
import AVFoundation

enum SellRouter: RouterProtocol {
    
    case getBrandsAPI(pageNo : Int, search : String)
    case getConditionsAPI
    case deliveryMethodsListAPI
    case getDeliveryTypeAPI
    //case sellItemUploadMediaAPI(mediaType: String, productMedia: UIImage)
    case sellItemUploadVideoAPI(mediaType: String, productMedia: URL)
    case sellItemDeleteMediaAPI(mediaType: String, mediaName : String)
    case sellItemAPI(productName: String, description : String, conditionId: String, categoriesMainId: String, categoriesSubId : String, categoriesCollectionId : String, deliveryMethod : String, sellingPrice : String, brandId : String, colorsId : String, materialId : String, productHeight :String, productLength : String, productWidth : String, productWeight : String, originalPrice : String, earningPrice : String, invoice : URL?, warranty :URL?, pinProduct : String, typeOfDelivery: String, quantity : Int, productImages : String, isGoodzDeals: String, addressID : String , offer_toggle : Bool , receive_chat : Bool , quantity_type : Int , items_per_set: Int   )
    case editSellItemAPI(productID: String,productName: String, description : String, conditionId: String, categoriesMainId: String, categoriesSubId : String, categoriesCollectionId : String, deliveryMethod : String, sellingPrice : String, brandId : String, colorsId : String, materialId : String, productHeight :String, productLength : String, productWidth : String, productWeight : String, originalPrice : String, earningPrice : String, invoice : URL?, warranty : URL?, typeOfDelivery: String, quantity : Int, productImages : String, address: String, is_order_placed: String? , isGoodzDeals: String , quantity_type : Int , items_per_set: Int)
    case editProductDetails(productID: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .deliveryMethodsListAPI :
            return APIEndpoint.deliveryMethodsList
        case .getConditionsAPI :
            return APIEndpoint.getConditions
        case .getBrandsAPI :
            return APIEndpoint.getBrands
        case .getDeliveryTypeAPI :
            return APIEndpoint.deliveryType
        case .sellItemAPI:
            return APIEndpoint.sellItems
        case .editSellItemAPI:
            return APIEndpoint.editItem
        case .sellItemUploadVideoAPI:
            return APIEndpoint.sellItemUploadMedia
        case .sellItemDeleteMediaAPI:
            return APIEndpoint.sellItemDeleteMedia
        case .editProductDetails:
            return APIEndpoint.editProductDetails
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getBrandsAPI(pageNo: let pageNo, search: let search):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.search : search
            ]
        case .getConditionsAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .deliveryMethodsListAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.cartType : 0,
                ParameterKey.isCart : "0"
            ]
        case .getDeliveryTypeAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
            
        case .sellItemAPI(productName: let productName, description: let description, conditionId: let conditionId, categoriesMainId: let categoriesMainId, categoriesSubId: let categoriesSubId, categoriesCollectionId: let categoriesCollectionId, deliveryMethod: let deliveryMethod, sellingPrice: let sellingPrice, brandId: let brandId, colorsId: let colorsId, materialId: let materialId, productHeight: let productHeight, productLength: let productLength, productWidth: let productWidth, productWeight: let productWeight, originalPrice: let originalPrice, earningPrice: let earningPrice, invoice: let invoice, warranty: let warranty, pinProduct: let pinProduct, typeOfDelivery: let typeOfDelivery, quantity: let quantity, productImages: let productImages, let isGoodzDeals, let address , let offer_toggle , let receive_chat , let quantity_type  , let items_per_set ):
            
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.productTitle : productName,
                ParameterKey.description : description,
                ParameterKey.condition : conditionId,
                ParameterKey.categoriesMainId : categoriesMainId,
                ParameterKey.categoriesSubId : categoriesSubId,
                ParameterKey.categoryCollectionId : categoriesCollectionId,
                ParameterKey.deliveryMethod : deliveryMethod,
                ParameterKey.sellingPrice : sellingPrice,
                ParameterKey.brand : brandId,
                ParameterKey.colors : colorsId,
                ParameterKey.material : materialId,
                ParameterKey.productHeight : productHeight,
                ParameterKey.productLength : productLength,
                ParameterKey.productWidth : productWidth,
                ParameterKey.productWeight : productWeight,
                ParameterKey.originalPrice : originalPrice,
                ParameterKey.earningPrice : earningPrice,
                ParameterKey.pinProduct : pinProduct,
                ParameterKey.productImages : productImages,
                ParameterKey.typeOfDelivery : typeOfDelivery,
                ParameterKey.deviceType : DeviceType.iOS.rawValue,
                ParameterKey.addressId : address,
                ParameterKey.offer_toggle : offer_toggle == true ? "1" : "0"  ,
                ParameterKey.receive_chat :   receive_chat == true ? "1" : "0" ,
                
                ParameterKey.quantity: "\(quantity)",
                ParameterKey.quantity_type :  "\(quantity_type)",
                ParameterKey.items_per_set : "\(items_per_set)",
                
                ParameterKey.appVersion: appDelegate.appVersion,
                ParameterKey.userType: (appUserDefaults.getValue(.isProUser) ?? false) ? "1" : "0",
                ParameterKey.isPro: (appUserDefaults.getValue(.isProUser) ?? false) ? "1" : "0",
                ParameterKey.isGoodzDealItem : isGoodzDeals
            ]
            if let url = invoice {
                params[ParameterKey.invoice] = url
            }
            
            if let url = warranty {
                params[ParameterKey.warranty] = url
            }
            
            return params
            
        case .editSellItemAPI(productID: let productID,productName: let productName, description: let description, conditionId: let conditionId, categoriesMainId: let categoriesMainId, categoriesSubId: let categoriesSubId, categoriesCollectionId: let categoriesCollectionId, deliveryMethod: let deliveryMethod, sellingPrice: let sellingPrice, brandId: let brandId, colorsId: let colorsId, materialId: let materialId, productHeight: let productHeight, productLength: let productLength, productWidth: let productWidth, productWeight: let productWeight, originalPrice: let originalPrice, earningPrice: let earningPrice, invoice: let invoice, warranty: let warranty,typeOfDelivery: let typeOfDelivery, quantity: let quantity, productImages: let productImages, address: let address, is_order_placed: let is_order_placed, isGoodzDeals: let isGoodzDeals , let quantity_type  , let items_per_set):
            
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.productId : productID,
                ParameterKey.productTitle : productName,
                ParameterKey.description : description,
               
                ParameterKey.condition : conditionId,
                ParameterKey.categoriesMainId : categoriesMainId,
                ParameterKey.categoriesSubId : categoriesSubId,
                ParameterKey.categoryCollectionId : categoriesCollectionId,
                ParameterKey.deliveryMethod : deliveryMethod,
                ParameterKey.sellingPrice : sellingPrice,
                ParameterKey.productImages : productImages,
                ParameterKey.colors : colorsId,
                ParameterKey.material : materialId,
                ParameterKey.productHeight : productHeight,
                ParameterKey.productLength : productLength,
                ParameterKey.productWidth : productWidth,
                ParameterKey.productWeight : productWeight,
                ParameterKey.typeOfDelivery : typeOfDelivery,
                ParameterKey.originalPrice : originalPrice,
                ParameterKey.earningPrice : earningPrice,
                ParameterKey.brand : brandId,
                ParameterKey.addressId : address,
                ParameterKey.deviceType : DeviceType.iOS.rawValue,
                ParameterKey.appVersion: appDelegate.appVersion,
                ParameterKey.userType: (appUserDefaults.getValue(.isProUser) ?? false) ? "1" : "0",
                ParameterKey.isPro: (appUserDefaults.getValue(.isProUser) ?? false) ? "1" : "0",
                ParameterKey.isGoodzDealItem : isGoodzDeals,
                ParameterKey.is_order_placed : is_order_placed,
                ParameterKey.quantity: "\(quantity)",
                ParameterKey.quantity_type :  "\(quantity_type)",
                ParameterKey.items_per_set : "\(items_per_set)"
                
//                ParameterKey.invoice: invoice,
//                ParameterKey.warranty: warranty
            ]
            
            if let url = invoice {
                params[ParameterKey.invoice] = url
            }
            
            if let url = warranty {
                params[ParameterKey.warranty] = url
            }
            
            return params
        case .sellItemDeleteMediaAPI(mediaType: let mediaType, mediaName : let mediaName):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.mediaType : mediaType,
                ParameterKey.mediaName : mediaName
                ]
        case .sellItemUploadVideoAPI(mediaType: let mediaType, productMedia: let productMedia) :
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.mediaType : mediaType,
                ParameterKey.productMedia : productMedia
            ]
        case .editProductDetails(productID: let productID):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.productId : productID
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class SellRepo {
    
    func getBrandsAPI(pageNo : Int, search : String, isShowLoader: Bool = true, _ completion: @escaping((_ status: Bool, _ data: [BrandModel]?, _ error: String?, _ totalRecords : Int, _ iconUrl: String?) -> Void)) {
//        if isShowLoader {
//            notifier.showLoader()
//        }
        
        NetworkManager.dataRequest(with: SellRouter.getBrandsAPI(pageNo: pageNo, search: search), responseModel: [ResponseModel<BrandModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message, 0, response?.first?.brandIcon)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil, Int(firstResponse.totalRecords  ?? "0") ?? 0, response.first?.brandIcon)
                } else {
                    completion(false, nil, response.first?.message ?? "", 0, response.first?.brandIcon)
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message, 0, "")
            }
            
//            if isShowLoader {
//                notifier.hideLoader()
//            }
        }
    }
    
    // --------------------------------------------
    
    func getConditionsAPI(_ completion: @escaping((_ status: Bool, _ data: [ConditionModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: SellRouter.getConditionsAPI, responseModel: [ResponseModel<ConditionModel>].self) { result in
            
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
    
    // --------------------------------------------
    
    func deliveryMethodsListAPI(_ completion: @escaping((_ status: Bool, _ data: [DeliveryMethodsModel]?, _ address : DeliveryAddress?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: SellRouter.deliveryMethodsListAPI, responseModel: [ResponseModel<DeliveryMethodsModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil,nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, firstResponse.deliveryAddress, nil)
                } else {
                    completion(false, nil, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
    // --------------------------------------------
    
    func getDeliveryTypeAPI(_ completion: @escaping((_ status: Bool, _ data: [DeliveryTypeModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: SellRouter.getDeliveryTypeAPI, responseModel: [ResponseModel<DeliveryTypeModel>].self) { result in
            
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
    
    func sellItemAPI(productName: String, description : String, conditionId: String, categoriesMainId: String, categoriesSubId : String,
                            categoriesCollectionId : String, deliveryMethod : String, sellingPrice : String, brandId : String, colorsId : String,
                            materialId : String, productHeight :String, productLength : String, productWidth : String, productWeight : String,
                     originalPrice : String, earningPrice : String, invoice : URL?, warranty :URL?, pinProduct : String, typeOfDelivery:String,
                     quantity : Int, productImages : String, isGoodzDeals : String, addressID : String,   offer_toggle : Bool ,  receive_chat : Bool , quantity_type:  Int , items_per_set : Int  ,_ completion: @escaping((_ status: Bool, _ data: [SellItemMOdel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: SellRouter.sellItemAPI(productName: productName, description: description, conditionId: conditionId, categoriesMainId: categoriesMainId, categoriesSubId: categoriesSubId, categoriesCollectionId: categoriesCollectionId, deliveryMethod: deliveryMethod, sellingPrice: sellingPrice, brandId: brandId, colorsId: colorsId, materialId: materialId, productHeight: productHeight, productLength: productLength, productWidth: productWidth, productWeight: productWeight, originalPrice: originalPrice, earningPrice: earningPrice, invoice: invoice, warranty: warranty, pinProduct: pinProduct, typeOfDelivery: typeOfDelivery, quantity: quantity, productImages: productImages, isGoodzDeals: isGoodzDeals, addressID: addressID  , offer_toggle:offer_toggle , receive_chat :receive_chat , quantity_type:  quantity_type , items_per_set : items_per_set ), responseModel: [ResponseModel<SellItemMOdel>].self) { result in
            
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
    
    func editSellItemAPI(productID: String,productName: String, description : String, conditionId: String, categoriesMainId: String, categoriesSubId : String,
                            categoriesCollectionId : String, deliveryMethod : String, sellingPrice : String, brandId : String, colorsId : String,
                            materialId : String, productHeight :String, productLength : String, productWidth : String, productWeight : String,
                            originalPrice : String, earningPrice : String, invoice : URL?, warranty :URL?, typeOfDelivery: String,
                         quantity : Int, productImages : String, address : String,is_order_placed: String, isGoodzDeals: String , quantity_type:  Int , items_per_set : Int ,_ completion: @escaping((_ status: Bool, _ data: [SellItemMOdel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: SellRouter.editSellItemAPI(productID: productID,productName: productName, description: description, conditionId: conditionId, categoriesMainId: categoriesMainId, categoriesSubId: categoriesSubId, categoriesCollectionId: categoriesCollectionId, deliveryMethod: deliveryMethod, sellingPrice: sellingPrice, brandId: brandId, colorsId: colorsId, materialId: materialId, productHeight: productHeight, productLength: productLength, productWidth: productWidth, productWeight: productWeight, originalPrice: originalPrice, earningPrice: earningPrice, invoice: invoice, warranty: warranty, typeOfDelivery :typeOfDelivery , quantity: quantity, productImages: productImages, address: address, is_order_placed: is_order_placed, isGoodzDeals: isGoodzDeals , quantity_type:  quantity_type , items_per_set : quantity_type ), responseModel: [ResponseModel<SellItemMOdel>].self) { result in
            
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

    func sellItemUploadVideoAPI(mediaType: String, productMedia: URL,_ completion: @escaping((_ status: Bool, _ data: [SellItemUploadMediaModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: SellRouter.sellItemUploadVideoAPI(mediaType: mediaType, productMedia: productMedia), responseModel: [ResponseModel<SellItemUploadMediaModel>].self) { result in
            
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
    
    func sellItemDeleteMediaAPI(mediaType: String,mediaName: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: SellRouter.sellItemDeleteMediaAPI(mediaType: mediaType, mediaName: mediaName), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    // If there is data in the result property
                    completion(true, nil)
                } else {
                    // If there is no data or the count is zero
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
    func editProductDetailsAPI(productID: String, _ completion: @escaping((_ status: Bool, _ data: EditSellProductDetailsModel?, _ error: String?) -> Void)) {
        
        notifier.showLoader()
        
        NetworkManager.dataRequest(with: SellRouter.editProductDetails(productID: productID), responseModel: [ResponseModel<EditSellProductDetailsModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result?.first, nil)
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
