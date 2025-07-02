//
//  MainCordinator.swift
//  ProjectStructure
//
//  Created by vtadmin on 12/12/22.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyBoard:AppStoryBoards) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyBoard:AppStoryBoards) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)
        
        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]
        
        // load our storyboard
        let storyboard = UIStoryboard(name: storyBoard.rawValue, bundle: Bundle.main)
        
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func popToSpecificVC<T: UIViewController>(_ viewController: T.Type, animated: Bool = true) {
        let vcs = navigationController.viewControllers
        let index = vcs.firstIndex(where: { $0.isKind(of: viewController.self) }) ?? 0
        
        if index < vcs.count {
            popVC(to: vcs[index])
        } else {
            popVC()
        }
    }
    
    func popToSellVC<T: UIViewController>(_ viewController: T.Type, animated: Bool = true, _ categoryMain: CategoryMainModel? = nil, _ categorySub: CategorySubModel? = nil, _ categoryCellection: CategoryCollectionModel? = nil) {
        let vcs = navigationController.viewControllers
        let index = vcs.firstIndex(where: { $0.isKind(of: viewController.self) }) ?? 0
        if index < vcs.count {
            if let tabBarMasterVC = vcs[index] as? TabBarMaster {
                if let sellVC = tabBarMasterVC.selectedViewController as? SellVC {
                    sellVC.categoryMain = categoryMain
                    sellVC.categorySub = categorySub
                    sellVC.categoryCollection = categoryCellection
                }
            }
            popVC(to: vcs[index])
        } else {
            popVC()
        }
    }
    
    func popVC(to vc:UIViewController? = nil) {
        if let vc {
            navigationController.popToViewController(vc, animated: true)
        } else {
            navigationController.popViewController(animated: true)
        }
    }
    
    func popVCWithOutAnimation() {
        navigationController.popViewController(animated: false)
    }
    
    func dismissVC() {
        navigationController.dismiss()
    }
    
    func popToRootVC() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func setTabbar(selectedIndex:Int = 0) {
        let tabbar = TABBAR.shared.getTabBar(selectedIndex: selectedIndex)
        navigationController.viewControllers = [tabbar]
    }
    
    func start() {
        let vc = SplashVC.instantiate(storyBoard: .main)
        navigationController.pushViewController(vc, animated: true)
    }
    func navigateToLoginVC() {
        let vc = LoginVC.instantiate(storyBoard: .auth)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToLegal() {
        let vc = FAQVC.instantiate(storyBoard: .myAccount)
        vc.isFAQ = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSignUp(fromAutoLogin: Bool) {
        let vc = SignUpVC.instantiate(storyBoard: .auth)
        vc.comeFromSocial = false
        vc.fromAutoLoginVC = fromAutoLogin
        navigationController.pushViewController(vc, animated: true)
    }
    func navigateToSocialSignUp(socialUserData: SocialLoginData, isCompany: Bool) {
        let vc = SignUpVC.instantiate(storyBoard: .auth)
        vc.comeFromSocial = true
        vc.socialUserData = socialUserData
        vc.isCompany = isCompany
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToForgotPassword() {
        let vc = ForgotPasswordVC.instantiate(storyBoard: .auth)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToNewHomeVC() {
        let vc = HomeVC.instantiate(storyBoard: .home)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToChangePassword() {
        let vc = ResetPasswordVC.instantiate(storyBoard: .auth)
        vc.isChangePassword = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToResetPassword() {
        let vc = ResetPasswordVC.instantiate(storyBoard: .auth)
        vc.isChangePassword = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToAutoLoginVC() {
        let vc = AutoLoginVC.instantiate(storyBoard: .auth)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToOTPVarification(otp: String = "",token: String = "", userID: String = "", mobile: String = "", email: String = "", isFrom: ScreenType = .defaultScreen, isProUser : Bool = false, isDocumentsSubmitted: String = "", isDocumentsValidated: String = "") {
        let vc = OTPVarification.instantiate(storyBoard: .auth)
        vc.token = token
        vc.userID = userID
        vc.mobile = mobile
        vc.email = email
        vc.screenType = isFrom
        vc.otp = otp
        vc.isProUser = isProUser
        vc.isDocumentsSubmitted = isDocumentsSubmitted
        vc.isDocumentsVerified = isDocumentsValidated
        navigationController.pushViewController(vc, animated: true)
    }
    
//    func navigateToHome() {
//        let vc = HomeVC.instantiate(storyBoard: .home)
//        navigationController.pushViewController(vc, animated: true)
//    }
    
//    func navigateToMyFavourite() {
//        let vc = MyFavouriteVC.instantiate(storyBoard: .favourite)
//        navigationController.pushViewController(vc, animated: true)
//    }
    
    func navigateToSell(productID: String, isFromEdit: Bool = false, productDetails : ProductDetailsModel?) {
        let vc = SellVC.instantiate(storyBoard: .sell)
        vc.isFromEdit = isFromEdit
        vc.productDetails = productDetails
        vc.productID = productID
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToChat() {
        let vc = ChatVC.instantiate(storyBoard: .chat)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToEditProfile(isPro: Bool,comeFromSignup: Bool = false) {
        let vc = EditProfile.instantiate(storyBoard: .myAccount)
        vc.isProUser = isPro
        vc.comeFromSignup = comeFromSignup
        navigationController.pushViewController(vc, animated: true)
    }
    
//    func navigateToMyAccount() {
//        let vc = AccountVC.instantiate(storyBoard: .myAccount)
//        navigationController.pushViewController(vc, animated: true)
//    }
    
//    func navigateToMyStore() {
//        let vc = MyStoreVC.instantiate(storyBoard: .myAccount)
//        vc.isEditable = false
//        navigationController.pushViewController(vc, animated: true)
//    }
    
    func navigateToEditStore(data : EditStoreData) {
        let vc = MyStoreVC.instantiate(storyBoard: .myAccount)
        vc.isEditable = true
        vc.editStoreData = data
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSecurity() {
        let vc = SecurityVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToNotification() {
        let vc = NotificationVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToStore() {
        let vc = StoreVC.instantiate(storyBoard: .myAccount)
        vc.storeId = (appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID) ?? "0"
        vc.isMyStore = true
        vc.isReview = false
        vc.openType = .myOrderList
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToStoreReview() {
        let vc = StoreVC.instantiate(storyBoard: .myAccount)
        vc.storeId = (appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID) ?? "0"
        vc.isMyStore = true
        vc.isReview = true
        vc.openType = .myOrderList
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToPopularStore(storeId : String) {
        let vc = StoreVC.instantiate(storyBoard: .myAccount)
        if storeId !=  (appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID) ?? "0" {
            vc.openType = .sellerBuyList
            vc.isMyStore = false
        } else {
            vc.openType = .myOrderList
            vc.isMyStore = true
        }
       
        vc.storeId = storeId
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToReply(data: StoreReviewModel, id : String) {
        let vc = ReplyVC.instantiate(storyBoard: .myAccount)
        vc.replyData = data
        vc.storeId = id
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToMyOrder(isMyOrder: Bool, orderID: String?) {
        let vc = OrderVC.instantiate(storyBoard: .myAccount)
        vc.isMyOrder = isMyOrder
        vc.orderID = orderID
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToAddAddress() {
        let vc = AddAddressVC.instantiate(storyBoard: .myAccount)
        vc.isEdit = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToEditAddress(data: MyAddressModel, id: String) {
        let vc = AddAddressVC.instantiate(storyBoard: .myAccount)
        vc.isEdit = true
        vc.editData = data
        vc.addressId = id
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToMyAddress() {
        let vc = MyAddressVC.instantiate(storyBoard: .myAccount)
        vc.isSelectType = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSelectAddress(addressID : String = "" ,completion : @escaping((MyAddressModel) -> Void)) {
        let vc = MyAddressVC.instantiate(storyBoard: .myAccount)
        vc.isSelectType = true
        vc.completion = { address in
            completion(address)
        }
        vc.addressId = addressID
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSettings() {
        let vc = SettingsVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToReport(orderDetailsModel : OrderDetailsResult?) {
        let vc = ReportVC.instantiate(storyBoard: .myAccount)
        vc.orderDetails = orderDetailsModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSearch() {
        let vc = SearchVC.instantiate(storyBoard: .home)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSimilarProductList(productId : String, cateID : String) {
        let vc = SimilarProductVC.instantiate(storyBoard: .home)
        vc.productId = productId
        vc.categoryId = cateID
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToProductList(title: String, isGoodzDeal : String = "", storeId : String = "", categoryMain : CategoryMainModel? = nil, categorySub : CategorySubModel? = nil, categoryCollection : [CategoryCollectionModel]? = nil, brandId : String = "", conditionId : String = "", colorId : String = "", materialId : String = "", isPopular : String = "") {
        let vc = ProductListVC.instantiate(storyBoard: .home)
        vc.titleText = title
        vc.filterData?.isGoodzDeals = isGoodzDeal
        vc.filterData?.storeId = storeId
        vc.filterData?.mainCategory = categoryMain
        vc.filterData?.subCategory = categorySub
        vc.filterData?.collectionCategory = categoryCollection
        vc.filterData?.isPopular = isPopular
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToProductList(title: String, latestArrivalArr : [ProductList] , islatest :Bool) {
        let vc = ProductListVC.instantiate(storyBoard: .home)
        vc.titleText = title
        vc.islatest = islatest
        vc.viewModel.arrProducts = latestArrivalArr.map{ ProductModel(productID: $0.productID, productName: $0.name, price: $0.price, newPrice: $0.discountedPrice  ,productImg:$0.imgProduct )
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    
    func navigateToSearchProductList(search : String, completion: @escaping((Bool) -> Void)) {
        let vc = SearchProductVC.instantiate(storyBoard: .home)
        vc.filterData?.search = search
        vc.completionClear = { isClear in
            completion(isClear)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSuperCategoryList(selectedData: [CategoryCollectionModel] = [] ,openType : OpenTypeCategory,title: String, completion: ((CategoryMainModel?, CategorySubModel?, CategoryCollectionModel?) -> ())?) {
        let vc = SuperCategoryVC.instantiate(storyBoard: .home)
        vc.titleText = title
        vc.opeonType = openType
        vc.selectedData = selectedData
        vc.completion = completion
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSubCategory(selectedData: [CategoryCollectionModel] = [], openType : OpenTypeCategory,title: String, categoryMain: CategoryMainModel? = nil, customizationModel: CustomizationModels? = nil, completion: ((CategoryMainModel?, CategorySubModel?, CategoryCollectionModel?) -> ())?) {
        let vc = SubCategoryVC.instantiate(storyBoard: .home)
        vc.titleText = title
        vc.categoryMain = categoryMain
        vc.opeonType = openType
        vc.selectedData = selectedData
        vc.completion = completion
        vc.customizationModel = customizationModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToCustomCategory(openType : OpenTypeCategory, selectedData: [CategoryCollectionModel],title: String, categoryMain: CategoryMainModel? = nil, categorySub : CategorySubModel? = nil, completion : @escaping(([CategoryCollectionModel]) -> Void)) {
        let vc = CategoryListVC.instantiate(storyBoard: .home)
        vc.titleText = title
        vc.openType = openType
        vc.categorySub = categorySub
        vc.categoryMain = categoryMain
        vc.arrSelectedCategory = selectedData
        vc.didSelectSubCategories = { data in
            completion(data)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToCategory(selectedData: [CategoryCollectionModel] = [],openType : OpenTypeCategory,title: String, categoryMain: CategoryMainModel? = nil, subCategory : CategorySubModel? = nil, customizationModels: CustomizationModels? = nil, completion: ((CategoryMainModel?, CategorySubModel?, CategoryCollectionModel?) -> ())?) {
        let vc = CategoryListVC.instantiate(storyBoard: .home)
        vc.titleText = title
        vc.openType = openType
        vc.categorySub = subCategory
        vc.categoryMain = categoryMain
        vc.arrSelectedCategory = selectedData
        vc.customizationModels = customizationModels
        vc.completion = completion
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToOrderDetailsDelivered(orderListResultModel: OrderListResult?) {
        let vc = OrderDetailsVC.instantiate(storyBoard: .myAccount)
        vc.openType = .inTransit
        vc.isFromOrderList = true
        vc.viewModel.orderListResultModel = orderListResultModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSalesDetailsDelivered(sellListResultModel: SellListResult?) {
        let vc = OrderDetailsVC.instantiate(storyBoard: .myAccount)
        vc.openType = .salesDelivered
        vc.isFromOrderList = false
        vc.viewModel.sellListResultModel = sellListResultModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSalesDetailsInTransit() {
        let vc = OrderDetailsVC.instantiate(storyBoard: .myAccount)
        vc.openType = .salesInTransit
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToWallet() {
        let vc = WalletVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToTransaction() {
        let vc = TransactionVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToAddBankDetails(bankDetail: WalletSetupModel? = nil) {
        let vc = AddBankDetailsVC.instantiate(storyBoard: .myAccount)
        vc.viewModel.bankDetail = bankDetail
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToWithdrawPopup() {
        let vc = WithdrawPopupVC.instantiate(storyBoard: .myAccount)
        vc.modalPresentationStyle = .overFullScreen
        navigationController.present(vc, animated: false)
    }
    
    func navigateToPaymentOption() {
        let vc = PaymentOptionVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToMyAds(store :Bool = false) {
        let vc = MyAdsVC.instantiate(storyBoard: .myAccount)
        vc.isStore = store
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToBoostItemDetails(isBoosted : Bool , productID : String, myAdsModel: MyAdsModel? = nil) {
        let vc = BoostItemDetailsVC.instantiate(storyBoard: .myAccount)
        vc.productID = productID
        vc.isBoosted = isBoosted
        vc.viewModel.myAdsModel = myAdsModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToBundlingProducts() {
        let vc = BuildingProductVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToReviewPopup(data : StoreReviewModel) {
        let vc = ReviewPopupVC.instantiate(storyBoard: .myAccount)
        vc.modalPresentationStyle = .overFullScreen
        vc.data = data
        navigationController.present(vc, animated: false)
    }
    
    func navigateToCart(productDetails : ProductDetailsModel? = nil) {
        let vc = CartVC.instantiate(storyBoard: .myAccount)
        vc.productDetails = productDetails
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToAddReview(orderID: String, toStoreID: String, saller_name: String) {
        let vc = AddReviewVC.instantiate(storyBoard: .myAccount)
        vc.orderID = orderID
        vc.toStoreID = toStoreID
        vc.saller_name = saller_name
        navigationController.pushViewController(vc, animated: true)
    }

    func navigateToBundleCart(bundleId : String, address : MyAddressModel,priceDetails: BundleProductCartModel? = nil, storeId: String) {
    let vc = BundleCartVC.instantiate(storyBoard: .myAccount)
    vc.priceDetails = priceDetails
    vc.storeId = storeId
    vc.address = address
        vc.bundleId = bundleId
    navigationController.pushViewController(vc, animated: true)
  }

    func navigateToOrderCompletePopup(paymentType : TelrPaymentType = .other,cartData : [AddOrderModel] = [], data : [PaymentModel] = [], orderID : String = "",storeId: String, productId: String,type: OrderCompleteType) {
        let vc = OrderCompleteVC.instantiate(storyBoard: .myAccount)
        vc.type = type
        vc.storeId = storeId
        vc.productID = productId
        vc.orderID = orderID
        vc.data = data
        vc.cartData = cartData
        vc.paymentType = paymentType
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToHelpCenter() {
        let vc = HelpCenterVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToFAQ() {
        let vc = FAQVC.instantiate(storyBoard: .myAccount)
        vc.isFAQ = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToCMS(title: String, description: String = "") {
        let vc = WebViewVC.instantiate(storyBoard: .myAccount)
        vc.strTitle = title
        vc.strDescription = description
        vc.comeFrom = .faq
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToWebView(urlStr: String) {
        let vc = WebViewVC.instantiate(storyBoard: .myAccount)
        vc.strTitle = Labels.uRL360Degree
        vc.productURl = urlStr
        vc.comeFrom = .productDetails
        navigationController.pushViewController(vc, animated: true)
    }
    func navigateToWebView(id: Int) {
        let vc = WebViewVC.instantiate(storyBoard: .myAccount)
        vc.id = id
        vc.comeFrom = .cms
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToFAQDetails(title : String,data:  [SubFAQModel]) {
        let vc = FAQDetailsVC.instantiate(storyBoard: .myAccount)
        vc.arrData = data
        vc.strTitle = title
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToContactus() {
        let vc = ContactUsVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentSort(data: [SortModel],completion: @escaping (SortModel) -> Void) {
        let vc = SortVC.instantiate(storyBoard: .home)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.selectedSort = { sort in
            completion(sort)
        }
        vc.arrSort = data
        navigationController.present(vc, animated: true)
    }
    
    func navigateToDocumentHelpCenter(isPro: Bool) {
        let vc = DocHelpCenterViewCont.instantiate(storyBoard: .myAccount)
        vc.isProUser = isPro
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToUploadDocument(isPro : Bool, comeFromSignup: Bool = false) {
        let vc = UploadDocumentVC.instantiate(storyBoard: .myAccount)
        vc.isProUser = isPro
        vc.comeFromSignup = comeFromSignup
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToOrderDetailsInTransit() {
        let vc = OrderDetailsVC.instantiate(storyBoard: .myAccount)
        vc.openType = .inTransit
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToTradeLicence() {
        let vc = TradeLicenceVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToBankLetter() {
        let vc = BankLetterUploadVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToBankDetailsVC() {
        let vc = BankDetailsUploadVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToDocsPendingVC(fromSellVC: Bool) {
        let vc = DocsPendingVC.instantiate(storyBoard: .sell)
        vc.fromSellVc = fromSellVC
        if fromSellVC {
            navigationController.pushViewController(vc, animated: true)
        } else {
            vc.modalPresentationStyle = .overFullScreen
            navigationController.present(vc, animated: true)
        }
    }
    
    func navigateToOurCommitments() {
        let vc = OurCommitmentsVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToPopularStoreVC() {
        let vc = PopularStoreVC.instantiate(storyBoard: .home)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToBundleProductListVC(storeId : String) {
        let vc = BundleProductListVC.instantiate(storyBoard: .home)
        vc.storeId = storeId
        navigationController.pushViewController(vc, animated: true)
    }
    
  func navigateToBundleProductCartVC(storeId: String = "") {
        let vc = BundleProductCartVC.instantiate(storyBoard: .home)
    vc.storeId = storeId
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentMakeAnOffer(data: MakeAnOfferModel, parentvc : BaseVC?, price : String) {
        let vc = MakeAnOfferPopupVC.instantiate(storyBoard: .home)
        vc.modalPresentationStyle = .overFullScreen
        vc.data = data
        vc.parentVC = parentvc
        vc.price = price
        navigationController.present(vc, animated: true)
        
    }
    
    func navigateToSecurityEmail() {
        let vc = SecurityEmailVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToTwoStepVerification() {
        let vc = TwoStepVerificationVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToConnections() {
        let vc = ConnectionsVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToNotificationList() {
        let vc = NotificationListVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToOrderTrack(orderID: String) {
        let vc = OrderTrackVC.instantiate(storyBoard: .myAccount)
        vc.orderID = orderID
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToProSplash(isComeFromSignup : Bool = false) {
        let vc = ProSplashVC.instantiate(storyBoard: .sell)
        vc.isComeFromSignup = isComeFromSignup
        navigationController.pushViewController(vc, animated: false)
    }
    
    func navigateToProBenefitList(comeFormSignup : Bool = false) {
        let vc = GoodzProListVC.instantiate(storyBoard: .sell)
        vc.comeFromSignup = comeFormSignup
        navigationController.pushViewController(vc, animated: false)
    }
    
  func navigateToProductDetail(productId: String, type: ProductDetailType, isAddedToBundle: Bool = false) {
        let vc = ProductDetailVC.instantiate(storyBoard: .home)
        vc.productDetailType = type
        vc.productID = productId
        vc.isAddedToBundle = isAddedToBundle
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToPriorityContact() {
        let vc = PriorityContactVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToCustomization(categoryMain: CategoryMainModel) {
        let vc = CustomizationItemVC.instantiate(storyBoard: .myAccount)
        vc.categoryMain = categoryMain
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToCustomization() {
        let vc = CustomizationVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentToCalender(chatId: String, toId : String, isSelectPickupAddress: String) {
        let vc = SelectDateAndTimeVC.instantiate(storyBoard: .chat)
        vc.modalPresentationStyle = .overFullScreen
        vc.chatId = chatId
        vc.toID = toId
        vc.isSelectPickupAddress = isSelectPickupAddress
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToChatAddressVC(chatId: String, toId : String) {
        let vc = ChatAddressVC.instantiate(storyBoard: .chat)
        vc.modalPresentationStyle = .overFullScreen
        vc.chatId = chatId
        vc.toID = toId
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToDashboard() {
        let vc = DashboardVC.instantiate(storyBoard: .myAccount)
        navigationController.pushViewController(vc, animated: true)
    }
   
    func navigateToFilter(filerData : ProductListParameter,
                          completion: @escaping (ProductListParameter) -> Void) {
        let vc = FilterVC.instantiate(storyBoard: .home)
        vc.completionFilter = { data in
            completion(data)
        }
        vc.filterData = filerData
        navigationController.pushViewController(vc, animated: true )
    }
    
    func qantityViewController(seletedQunatityIndex : Int? , completion: ((Int?) -> ())?){
         
        let vc = QantityViewController.instantiate(storyBoard: .sell)
        vc.completion = completion
        vc.seletedIndex = seletedQunatityIndex
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func navigateToBrands(selectedBrands : [BrandModel], isMultipleSelection : Bool, id : String, isFromCustomization: Bool = false, customizationModel: CustomizationModels? = nil, completion: (([BrandModel]?) -> ())?) {
        let vc = BrandsVC.instantiate(storyBoard: .sell)
        vc.completion = completion
        vc.isMultipleSelection = isMultipleSelection
        vc.arrSelectBrands = selectedBrands
        vc.selectedID = id
        vc.isFromCustomization = isFromCustomization
        vc.customizationModel = customizationModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToPrice(maxPrice : String, minPrice : String , isPrice : Bool ,completion: @escaping((String, String) -> Void)) {
        let vc = PriceVC.instantiate(storyBoard: .sell)
        vc.isPrice = isPrice
        vc.selectedPrice.minPrice = minPrice
        vc.selectedPrice.maxPrice = maxPrice
        vc.completionPrice = { max, min in
            completion(max,min)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToDimension(width : String, weigth : String ,heigth : String, length : String , isPrice : Bool ,completion: @escaping((String, String, String, String) -> Void)) {
        let vc = PriceVC.instantiate(storyBoard: .sell)
        vc.isPrice = isPrice
        vc.selectedDeminsion.width = width
        vc.selectedDeminsion.heigth = heigth
        vc.selectedDeminsion.weight = weigth
        vc.selectedDeminsion.length = length
        vc.completionDeminsions = { kwidth, kweigth, kheigth, klength in
            completion(kwidth, kweigth, kheigth, klength)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToColor(selectedColor : [ColorModel], isMultipleSelection : Bool,id : String ,completion: @escaping(([ColorModel]?) -> Void)) {
        let vc = ColorsVC.instantiate(storyBoard: .sell)
        vc.completion = { data in
            completion(data)
        }
        vc.isColor = true
        vc.selectedID = id
        vc.isMultipleSelection = isMultipleSelection
        vc.arrSelect = selectedColor
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToMaterial(selectedMaterial : [ColorModel], isMultipleSelection : Bool, id : String ,completion: @escaping(([ColorModel]?) -> Void)) {
        let vc = ColorsVC.instantiate(storyBoard: .sell)
        vc.completion = { data in
            completion(data)
        }
        vc.isColor = false
        vc.selectedID = id
        vc.isMultipleSelection = isMultipleSelection
        vc.arrSelect = selectedMaterial
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToCondition(selectedConditions : [ConditionModel], isMultipleSelection : Bool,id : String , completion: @escaping(([ConditionModel]?) -> Void)) {
        let vc = ConditionVC.instantiate(storyBoard: .sell)
        vc.completion = { selectCondition in
            completion(selectCondition)
        }
        vc.isMultipleSelection = isMultipleSelection
        vc.arrSelectCondition = selectedConditions
        vc.selectedID = id
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showPopUp(title: String, description: String,storeId : String ,productId : String ,isHide : String, type : OpenPopup, completion: @escaping((Bool) -> Void)) {
        let vc = HideDeletePopUpVC.instantiate(storyBoard: .sell)
        vc.titleText = title
        vc.titleDescription = description
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.productId = productId
        vc.storeId = storeId
        vc.isHide = isHide
        vc.type = type
        vc.completion = { status in
            completion(status)
        }
        navigationController.present(vc)
    }
    
    func showChatPopUp(title: String, description: String,chatID : String = "",toID : String = "", isBlock : String = "", type : OpenPopup, completion: @escaping((Bool) -> Void)) {
        let vc = HideDeletePopUpVC.instantiate(storyBoard: .sell)
        vc.titleText = title
        vc.titleDescription = description
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.toID = toID
        vc.chatId = chatID
        vc.type = type
        vc.isBlock = isBlock
        vc.completion = { status in
            completion(status)
        }
        navigationController.present(vc)
    }
    
    func navigateToSellProductDetail(storeId : String, productId : String ,type: ProductDetailType, productStatus : String = Status.one.rawValue) {
        let vc = SellProductDetailVC.instantiate(storyBoard: .sell)
        vc.productDetailType = type
        vc.storeId = storeId
        vc.productID = productId
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToChatDetail(isBlock : Bool ,chatId : String, userId: String) {
        let vc = ChatDetailVC.instantiate(storyBoard: .chat)
        vc.chatId = chatId
        vc.sellerID = userId
//        vc.userName = userName
        vc.isBlocked = isBlock
        navigationController.pushViewController(vc, animated: false)
    }
    
    func navigateToChatDetailSeller() {
        let vc = ChatDetailSellerVC.instantiate(storyBoard: .chat)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToTelrPayment(storeID : String = "",type : TelrPaymentType,data: [PaymentModel] = [], cartData : [AddOrderModel] = []) {
        let vc = TelrPaymentVC.instantiate(storyBoard: .myAccount)
        vc.boostdata = data
        vc.cartData = cartData
        vc.openTypeTelrPayment = type
        vc.storeID = storeID
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToContactUsVC(chatId : String, bundleId : String ,productId : String) {
        let vc = ChatContactUsVC.instantiate(storyBoard: .chat)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.chatId = chatId
        vc.productId = productId
        vc.bundleId = bundleId
        navigationController.present(vc)
    }
    
    func slotBookingViewController(_slotOptions  : [OptionsSlotBooking]? , slot_message_id  : String?, completion: @escaping((slotBookingModel?) -> Void) ){
        
        let vc = SlotBookingViewController.instantiate(storyBoard: .chat)
        vc.slots = _slotOptions
        vc.slot_message_id = slot_message_id
        vc.completion =  { val in
            completion(val)
        }
        navigationController.present(vc)
    }
    
    func reportProblemViewController(_msgDate : MessageModel?, completion: @escaping((Bool?) -> Void) ){
        
        let vc = ReportProblemViewController.instantiate(storyBoard: .chat)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.msgDate =  _msgDate
        vc.completion =  { [weak self] val in
            completion(val)
        }
        navigationController.present(vc)
    }
    
    
    
    
    func showMakeOfferPopUp(data : MakeAnOfferModel, price : Int, completion: @escaping (Bool) -> Void) {
        let vc = MakeAnOfferVC.instantiate(storyBoard: .chat)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.data = data
        vc.price = price
        vc.completion = { status in
            completion(status)
        }
        navigationController.present(vc)
    }
    
    func showReportPopup(toID : String, chatId : String) {
        let vc = ReportPopupVC.instantiate(storyBoard: .chat)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.toID = toID
        vc.chatId = chatId
        navigationController.present(vc)
    }
    
    func showSlotChangePopup( pickup_slots : [Pickup_slots]? , selectedPickupSlots : Pickup_slots? , completion: @escaping (Pickup_slots?) -> Void) {
        let vc = SlotChangeViewController.instantiate(storyBoard: .chat)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.pickup_slots = pickup_slots
        vc.selectedPickupSlots = selectedPickupSlots
        vc.completion = { status in
            completion(status )
        }
        navigationController.present(vc)
    }
    
    func showChatDropDown(userId: String, chatId : String, userName: String, isBlock : String, isSelf: Bool) {
        let vc = ChatDropDownVC.instantiate(storyBoard: .chat)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.userId = userId
        vc.chatId = chatId
        vc.userName = userName
        vc.isBlock = isBlock
        vc.isSelf = isSelf
        navigationController.present(vc)
    }
    
    func coutryCodePopup(completion: @escaping (String) -> Void) {
        let vc = SelectCountryVC.instantiate(storyBoard: .auth)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.onCountrySelected = { countryCode in
            completion(countryCode)
        }
        navigationController.present(vc, animated: true)
    }
    
    func navigateToOpenMedia(type: ContentType, url : URL) {
        let vc = OpenMediaVC.instantiate(storyBoard: .chat)
        vc.contentType = type
        vc.contentURL = url
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToChatBundleList(isSeller: Bool, productList: [ChatProductModel]) {
        let vc = ChatBundleListVC.instantiate(storyBoard: .chat)
        vc.isSeller = isSeller
        vc.productList = productList
        navigationController.pushViewController(vc, animated: true)
    }
}
