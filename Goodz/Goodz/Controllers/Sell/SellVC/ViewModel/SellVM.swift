//
//  SellVM.swift
//  Goodz
//
//  Created by Akruti on 10/01/24.
//

import Foundation
import UIKit
import AVFoundation

class SellVM {
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = SellRepo()
    var arrDeliveryType : [DeliveryTypeModel] = [DeliveryTypeModel]()
    var arrDeliveryMethods : [DeliveryMethodsModel] = [DeliveryMethodsModel]()
    var editSellProductDetails: EditSellProductDetailsModel?
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    // My Product need to be assembly,  Pick-up from my home by the buyer
    func fetchConditionsData(completion: @escaping((Bool, DeliveryAddress?) -> Void)) {
        self.repo.deliveryMethodsListAPI() { status, data, address,error in
            if status, let list = data {
                self.arrDeliveryMethods = list
                completion(true, address)
                return
            } else {
                completion(false, address)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrDeliveryMethods.count
    }
    
    // --------------------------------------------
    
    func setCondition(row: Int) -> DeliveryMethodsModel {
        self.arrDeliveryMethods[row]
    }
    
    // --------------------------------------------
    // car , truck
    func fetchDeliveryType(completion: @escaping((Bool) -> Void)) {
        self.repo.getDeliveryTypeAPI { status, data, error in
            if status, let types = data {
                self.arrDeliveryType = types
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfDeliveryType() -> Int {
        self.arrDeliveryType.count
    }
    
    // --------------------------------------------
    
    func setDeliveryType(row: Int) -> DeliveryTypeModel {
        self.arrDeliveryType[row]
    }
    
    // --------------------------------------------
     
    
    func sellItemAPI(productName: String, description : String, conditionId: String, categoriesMainId: String, categoriesSubId : String,
                     categoriesCollectionId : String, deliveryMethod : String, sellingPrice : String, brandId : String, colorsId : String,
                     materialId : String, productHeight :String, productLength : String, productWidth : String, productWeight : String,
                     originalPrice : String, earningPrice : String, invoice : URL?, warranty :URL?, pinProduct : String, typeOfDelivery:String,
                     quantity : Int, productImages : String,isGoodzDeals : String, addressID : String , offer_toggle : Bool , receive_chat : Bool ,quantity_type : Int ,items_per_set : Int, completion: @escaping((_ status: Bool, _ data: [SellItemMOdel]?) -> Void)) {
        self.repo.sellItemAPI(productName: productName, description: description, conditionId: conditionId, categoriesMainId: categoriesMainId, categoriesSubId: categoriesSubId, categoriesCollectionId: categoriesCollectionId, deliveryMethod: deliveryMethod, sellingPrice: sellingPrice, brandId: brandId, colorsId: colorsId, materialId: materialId, productHeight: productHeight, productLength: productLength, productWidth: productWidth, productWeight: productWeight, originalPrice: originalPrice, earningPrice: earningPrice, invoice: invoice, warranty: warranty, pinProduct: pinProduct, typeOfDelivery: typeOfDelivery, quantity: quantity, productImages: productImages, isGoodzDeals: isGoodzDeals, addressID: addressID, offer_toggle : offer_toggle , receive_chat : receive_chat, quantity_type : quantity_type , items_per_set: items_per_set) { status, data, error in
            if status {
                completion(true, data)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false, nil)
            }
        }
    }
    
    // --------------------------------------------
    
    func editSellItemAPI(productID: String,productName: String, description : String, conditionId: String, categoriesMainId: String, categoriesSubId : String,
                     categoriesCollectionId : String, deliveryMethod : String, sellingPrice : String, brandId : String, colorsId : String,
                     materialId : String, productHeight :String, productLength : String, productWidth : String, productWeight : String,
                     originalPrice : String, earningPrice : String, invoice : URL?, warranty :URL?, pinProduct : String, typeOfDelivery:String,
                         quantity : Int, productImages : String, address: String, is_order_placed:String , isGoodzDeals: String,quantity_type : Int ,items_per_set : Int, completion: @escaping((_ status: Bool, _ data: [SellItemMOdel]?) -> Void)) {
        
        self.repo.editSellItemAPI(productID: productID, productName: productName, description: description, conditionId: conditionId, categoriesMainId: categoriesMainId, categoriesSubId: categoriesSubId, categoriesCollectionId: categoriesCollectionId, deliveryMethod: deliveryMethod, sellingPrice: sellingPrice, brandId: brandId, colorsId: colorsId, materialId: materialId, productHeight: productHeight, productLength: productLength, productWidth: productWidth, productWeight: productWeight, originalPrice: originalPrice, earningPrice: earningPrice, invoice: invoice, warranty: warranty, typeOfDelivery: typeOfDelivery, quantity: quantity, productImages: productImages, address: address, is_order_placed: is_order_placed, isGoodzDeals: isGoodzDeals , quantity_type : quantity_type , items_per_set: items_per_set) { status, data, error in
            
            if status {
                completion(true, data)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false, nil)
            }
        }
    }
    
    func checkSellNowData(productImages : [SellItemUploadMediaModel], title: String, description : String, brand: String, condition: String, category : String, productHeight: String, productDepth: String, productWidth: String, productWeight: String, address : String, deliveryMethod : String,brandNewPrice : String , sellingPrice : String, priceForYou : String, termsAndCondtion : Bool,quantity : Int?, completion: (Bool) -> Void) {
        if productImages.count < 2 {
            notifier.showToast(message: Labels.pleaseAddPhotoOrVideoOfYourItem)
            completion(false)
        } else if title.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterProductTitle)
            completion(false)
        } else if description.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterDescription)
            completion(false)
        } else if brand.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectBrand)
            completion(false)
        } else if condition.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectCondition)
            completion(false)
        } else if category.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectCategory)
            completion(false)
        } else if productHeight.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterHeight)
            completion(false)
        } else if productDepth.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterDepth)
            completion(false)
        } else if productWidth.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterWidth)
            completion(false)
        } else if productWeight.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterWeight)
            completion(false)
        } else if address.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectPickupAddress)
            completion(false)
        } else if deliveryMethod.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectDeliveryMethod)
            completion(false)
        } 
//        else if brandNewPrice.isEmpty {
//            notifier.showToast(message: Labels.pleaseEnterbrandnewPrice)
//            completion(false)
//        } else if ["0", "0.0", "0.00", "0.", "."].contains(brandNewPrice){
//            notifier.showToast(message: Labels.pleaseEnterValidbrandnewPrice)
//            completion(false)
//        }
        else if sellingPrice.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterSellingPrice)
            completion(false)
        } else if ["0", "0.0", "0.00", "0.", "."].contains(sellingPrice){
            notifier.showToast(message: Labels.pleaseEnterValidSellingPrice)
            completion(false)
        }
//        else if sellingPrice.toDouble() > brandNewPrice.toDouble() {
//            notifier.showToast(message: Labels.priceValidation)
//            completion(false)
//        } 
        else if priceForYou.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterSellingPriceForYou)
            completion(false)
        } else if ["0", "0.0", "0.00", "0.", "."].contains(priceForYou){
            notifier.showToast(message: Labels.pleaseEnterValidSellingPriceForYou)
            completion(false)
        }
        else if  quantity == 0{
            notifier.showToast(message: "Please select quantity")
            completion(false)
        }
        else if !termsAndCondtion {
            notifier.showToast(message: Labels.pleaseAgreeWithTermsAndCondition)
            completion(false)
        } else {
            completion(true)
        }
    }
    
    // --------------------------------------------
    
    func sellItemDeleteMediaAPI(mediaType : String, mediaName : String, completion: @escaping((Bool) -> Void)) {
        self.repo.sellItemDeleteMediaAPI(mediaType: mediaType, mediaName: mediaName) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func sellItemUploadVideoAPI(mediaType : String, productMedia : URL, completion: @escaping((Bool, SellItemUploadMediaModel) -> Void)) {
        self.repo.sellItemUploadVideoAPI(mediaType: mediaType, productMedia: productMedia) { status, data, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            if let uploadDoc = data?.first {
                completion(status,uploadDoc)
            } else {
                completion(status, SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: ""))
            }
            
        }
    }
    
    func editProductDetailsAPI(productID : String, completion: @escaping((Bool) -> Void)) {
        self.repo.editProductDetailsAPI(productID: productID) { status, data, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            self.editSellProductDetails = data
            completion(status)
        }
    }
}
