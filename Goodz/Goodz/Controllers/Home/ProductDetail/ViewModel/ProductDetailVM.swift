//
//  ProductDetailVM.swift
//  Goodz
//
//  Created by Akruti on 16/01/24.
//

import Foundation
class ProductDetailVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ProductDetailRepo()
    var productDetails : ProductDetailsModel?
    var arrSimilarProduct :[SimilarProductModel] = []
    var arrProductKpis :[ProductKpis] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(storeId: String, productId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.productDetailsAPI(storeId: storeId, productId: productId) { status, data, error in
            if status , let productDetailsData = data?.first {
                self.productDetails = productDetailsData
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
    
    func setStoreDetails() -> Product {
        self.productDetails?.product ?? Product(productName: "", description: "", categoryID: "", category: "", subCategory: "", subSubCategoryID: "", subSubCategory: "", typeOfDelivery: "", invoice: "", warranty: "", totalLike: "", isPin: "", salePrice: "", originalPrice: "", isBoosted: "", isLike: "", isHide: "", equirectangularImageUrl: "", isSold: "",brandName: "", numberOfPayment: "", amount: "", typeOfDeliveryName: "", isProductVerified: "", qty: "", isGoodzPro: "", isOfferSend: "", isOfferStatus: "")
    }
    
    // --------------------------------------------
    
    func setProductDetails() -> Store {
        self.productDetails?.store ?? Store(storeID: "", storeName: "", storeImage: "", storeRate: "", totalItems: "", saleTotalItem: "", storeOwnerID: "", storeReview: "", isPro: "", numberOfReviews: "")
    }
    
    // --------------------------------------------
    
    func setDeliveryMethods() -> [DeliveryMethod] {
        self.productDetails?.deliveryMethod ?? []
    }
    
    // --------------------------------------------
    
    func setDimension() -> [ProductDimension]? {
        self.productDetails?.productDimension ?? []
    }
    
    // --------------------------------------------
    // MARK: - Similar Products API
    // --------------------------------------------
    
    func fetchSimilarProducts(page: Int,productId : String, categoryId: String, completion: @escaping((Bool, Int) -> Void)) {
        self.repo.similarProductListAPI(page: page,productId : productId,categoryId: categoryId) { status, data, error,totalRecords  in
            if status, let products = data {
                self.arrSimilarProduct = products
                completion(true, totalRecords ?? 0)
            } else {
                self.arrSimilarProduct = []
                completion(false, 0)
                
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfSimiliarProducts() -> Int {
        self.arrSimilarProduct.count
    }
    
    // --------------------------------------------
    
    func setSimilarProducts(row: Int) -> SimilarProductModel {
        self.arrSimilarProduct[row]
    }
    
    // --------------------------------------------
    
    func deleteItem(productID: String, storeID: String, completion: @escaping((Bool) -> Void)) {
        self.repo.deleteItemAPI(productID: productID, storeID: storeID) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func hideItem(productID: String, storeID: String, isHide: String, completion: @escaping((Bool) -> Void)) {
        self.repo.hideItemAPI(productID: productID, storeID: storeID, isHide: isHide) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func numberOfProductKpis() -> Int {
        self.arrProductKpis.count
    }
    
    // --------------------------------------------
    
    func setProductKpis(row: Int) -> ProductKpis {
        self.arrProductKpis[row]
    }
    
    // --------------------------------------------
    
    func addRemoveBundle(productId: String, isAdd : String, completion: @escaping((Bool, String) -> Void)) {
        BundleProductRepo.shared.addRemoveBundleAPI(productId: productId, isAdd: isAdd) { status, error in
            if status {
                print("success fully add remove bundle")
                completion(true, "")
            } else {
                completion(false, error ?? "")
            }
        }
    }
    
    // --------------------------------------------
    
}
