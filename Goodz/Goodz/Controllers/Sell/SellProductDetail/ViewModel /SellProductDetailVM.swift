//
//  SellProductDetailVM.swift
//  Goodz
//
//  Created by Akruti on 16/01/24.
//

import Foundation
class SellProductDetailVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ProductDetailRepo()
    var productDetails : ProductDetailsModel?
    var repoPin = MyStoreRepo()
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(storeId: String, productId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.productDetailsAPI(storeId: storeId, productId: productId) { status, data, error in
            if status {
                if let productDetailsData = data?.first {
                    self.productDetails = productDetailsData
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func addRemoveFavourite(isFav: String, productId : String, completion: @escaping((Bool) -> Void)) {
        GlobalRepo.shared.addFavRemoveFavAPI(isFav, productId) { status, fromFav,error in
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func numberOfProductImages() -> Int {
        self.productDetails?.productImgs?.count ?? 0
    }
    
    // --------------------------------------------
    
    func setProductImages(row: Int) -> ProductImg {
        self.productDetails?.productImgs?[row] ?? ProductImg(productImg: "", mediaType: "")
    }
    
    // --------------------------------------------
    
    func setAddress() -> MyAddressModel {
        self.productDetails?.pickupAddress ?? MyAddressModel(fullName: "", addressId: "", countryCode: "", mobile: "", city: "", area: "", streetAddress: "", floor: "", isDefault: "", countryCodes: "")
    }
    
    // --------------------------------------------
    
    func setDescriptionsData() -> [Description] {
        self.productDetails?.description ?? []
    }
    
    // --------------------------------------------
    
    func setProductDetails() -> Product {
        self.productDetails?.product ?? Product(productName: "", description: "", categoryID: "", category: "", subCategory: "", subSubCategoryID: "", subSubCategory: "", typeOfDelivery: "", invoice: "", warranty: "", totalLike: "", isPin: "", salePrice: "", originalPrice: "", isBoosted: "", isLike: "", isHide: "", equirectangularImageUrl: "", isSold: "", brandName: "", numberOfPayment: "", amount: "", typeOfDeliveryName: "", isProductVerified: "", qty: "", isGoodzPro: "", isOfferSend: "", isOfferStatus: "")
    }
    
    // --------------------------------------------
    
    func setStoreDetails() -> Store {
        self.productDetails?.store ?? Store(storeID: "", storeName: "", storeImage: "", storeRate: "", totalItems: "", saleTotalItem: "", storeOwnerID: "", storeReview: "", isPro: "", numberOfReviews: "")
    }
    
    // --------------------------------------------
    
    func setDeliveryMethods() -> [DeliveryMethod] {
        self.productDetails?.deliveryMethod ?? []
    }
    
    // --------------------------------------------
    
    func setDimension() -> [ProductDimension] {
        self.productDetails?.productDimension ?? []
    }
    
    // --------------------------------------------
    
    func fetchPinUnpinItemAPI(storeId: String, productId : String, isPinUnpin : String, completion: @escaping((Bool) -> Void)) {
        self.repoPin.pinUnpinItemAPI(storeId: storeId, productId: productId, isPinUnpin: isPinUnpin) { status, error in
            completion(status)
        }
    }
    
}
