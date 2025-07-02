//
//  ProductDetailVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit

class ProductDetailVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwInvoice: UIStackView!
    @IBOutlet weak var vwWarranty: UIStackView!
    
    @IBOutlet weak var vwHeaderBG: UIView!
    @IBOutlet weak var constScrollTop: NSLayoutConstraint!
    
    @IBOutlet weak var heightSimilarProduct: NSLayoutConstraint!
    @IBOutlet weak var vwMain: UIStackView!
    @IBOutlet weak var clvProductImages: UICollectionView!
    @IBOutlet weak var clvProducts: UICollectionView!
    @IBOutlet weak var viewOffer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnMakeOffer: UIButton!
    
    /// Description
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDescriptionContent: UILabel!
    
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblTitleCondition: UILabel!
    @IBOutlet weak var lblConditionDetail: UILabel!
    
    @IBOutlet weak var lblDimensions: UILabel!
    @IBOutlet weak var lblDimensionsDetail: UILabel!
    
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblColorDetail: UILabel!
    
    /// Resource saving
    @IBOutlet weak var lblResouceSavingTitle: UILabel!
    @IBOutlet weak var tblProductKpis: UITableView!
    @IBOutlet weak var tblProductKpisHT: NSLayoutConstraint!
    
    /// Product Detail Info
    @IBOutlet weak var viewSellerRating: UIView!
    @IBOutlet weak var viewProductInfo: UIView!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var btnRemoveBundle: UIButton!
    @IBOutlet weak var btnAddToBundle: UIButton!
    // @IBOutlet weak var viewBuyAction: UIView!
    
    /// **Follow view
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var lblContactSeller: UILabel!
    @IBOutlet weak var lblSaleItems: UILabel!
    
    /// Product Detail
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    @IBOutlet weak var lblScalpPay: UILabel!
    @IBOutlet weak var lblpayDescription: UILabel!
    
    /// Small View
    @IBOutlet weak var lblProductNameS: UILabel!
    @IBOutlet weak var lblOfferPriceS: UILabel!
    @IBOutlet weak var lblMrpPriceS: UILabel!
    @IBOutlet weak var btnBuyNowS: UIButton!
    @IBOutlet weak var btnMakeAnOfferS: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var vwLike: UIView!
    @IBOutlet weak var totalLike: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var vwCondition: UIStackView!
    @IBOutlet weak var vwDimension: UIStackView!
    @IBOutlet weak var vwColor: UIStackView!
    @IBOutlet weak var btnURLDegree: ThemeGreenButton!
    
    @IBOutlet weak var vwBottomButton: UIView!
    @IBOutlet weak var imgPro: UIImageView!
    
    @IBOutlet weak var vwMaterial: UIStackView!
    @IBOutlet weak var lblMaterial: UILabel!
    @IBOutlet weak var lblMaterialDetails: UILabel!
    
    
    @IBOutlet weak var vwDeliveryType: UIView!
    @IBOutlet weak var lblDeliveryType: UILabel!
    @IBOutlet weak var lblDeliveryTypeDetails: UILabel!
    @IBOutlet weak var vwDimensions: UIView!
    @IBOutlet weak var lblTitleDimensions: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblHeightValue: UILabel!
    @IBOutlet weak var lblWidth: UILabel!
    @IBOutlet weak var lblWidthValue: UILabel!
    @IBOutlet weak var lblLength: UILabel!
    @IBOutlet weak var lblLengthValue: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblWeightValue: UILabel!
    
     @IBOutlet weak var lblCategory: UILabel!
     @IBOutlet weak var lblCategoryValue: UILabel!
     
     @IBOutlet weak var lblSubACtegory: UILabel!
     @IBOutlet weak var lblSubACtegoryValue: UILabel!
     
     @IBOutlet weak var lblSubSubCat: UILabel!
     @IBOutlet weak var lblSubSubCatValue: UILabel!
     
     @IBOutlet weak var lblInvoice: UILabel!
     @IBOutlet weak var lblInvoiceValue: UILabel!
     
     @IBOutlet weak var lblWarranty: UILabel!
     @IBOutlet weak var lblWarrantyValue: UILabel!
     
    @IBOutlet weak var vwProductDes: UIView!
    @IBOutlet weak var vwKPIs: UIView!
    
    @IBOutlet weak var headerTitle: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    lazy var productDetailType: ProductDetailType = .goodsDefault
    var productID : String = ""
    var viewModel : ProductDetailVM = ProductDetailVM()
    var storeId : String = ""
    var viewModelMakeAnOffer : MakeAnOfferVM = MakeAnOfferVM()
    var isAddedToBundle: Bool = false
    var comefromOrder : Bool = false
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.setLikeView()
        self.imgStore.image = .avatarStore
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clvProducts.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.clvProducts.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    private func setData() {
        
        self.clvProducts.reloadData()
        self.clvProductImages.reloadData()
        self.pageControl.numberOfPages = self.viewModel.numberOfProductImages()
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.themeLightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.themeGreen
        
        let data = self.viewModel.productDetails
        let productData = self.viewModel.productDetails?.product
        
        self.setView(isHide: (productData?.isSold ?? "0") == Status.one.rawValue)
        
        self.vwBottomButton.isHidden = productData?.isSold == Status.one.rawValue
        if let url = productData?.equirectangularImageUrl, !(url.isEmpty) {
            self.btnURLDegree.isHidden = false
        }
        
        self.lblDeliveryTypeDetails.text = data?.deliveryMethod?.filter { $0.name != "Delivery" }.map { $0.name ?? "" }.joined(separator: "\n")
            
        self.totalLike.text = data?.product?.totalLike?.description ?? Status.zero.rawValue
        self.imgLike.image =  (data?.product?.isLike ?? Status.zero.rawValue) == Status.one.rawValue ? .icHeartFill : .icHeart
        if let img = data?.store?.storeImage, let url = URL(string: img) {
            self.imgStore.sd_setImage(with: url, placeholderImage: .avatarStore)
            self.imgStore.contentMode = .scaleAspectFill
        } else {
            self.imgStore.image = .avatarStore
        }
        self.lblSellerName.text = data?.store?.storeName
        if (data?.store?.storeRate ?? "").isEmpty {
            self.lblRating.text =  Status.five.rawValue
        } else {
            self.lblRating.text = (data?.store?.storeRate ?? Status.five.rawValue)
        }
        if (data?.store?.numberOfReviews ?? "").isEmpty || (data?.store?.numberOfReviews ?? "") == "0" {
            self.lblItemCount.text = ""
        } else {
            let review = (data?.store?.numberOfReviews?.description == "0" || data?.store?.numberOfReviews?.description == "1") ? Labels.review : Labels.reviews
            self.lblItemCount.text = "(" + (data?.store?.numberOfReviews?.description ?? Status.zero.rawValue) + " " +
            review + ")"
        }
        let str = (Int(data?.store?.saleTotalItem ?? "0") ?? 0) > 1 ? Labels.itemsForSale : Labels.itemForSale
        self.lblSaleItems.text = (data?.store?.saleTotalItem?.description ?? Status.zero.rawValue) + " " + str
        self.lblProductName.text = productData?.productName?.capitalizeFirstLetter()
        self.lblStoreName.text = productData?.brandName?.capitalizeFirstLetter()
        self.lblDescriptionContent.text = productData?.description?.capitalizeFirstLetter()

        let numberOfPayment = productData?.numberOfPayment ?? ""
        
        let amountString = String(format: "%.2f", Double(productData?.amount ?? "0") ?? 0.0)
        let formattedAmount = amountString.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
        self.lblpayDescription.text = Labels.oR.lowercased() + " " + numberOfPayment + " " + Labels.paymentOf + " " + formattedAmount + " " + kCurrency

        if let img = data?.productImgs?.first?.productImg, let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.lblProductNameS.text = productData?.productName
        self.imgPro.isHidden = productData?.isGoodzPro != "2"
        self.headerTitle.text = productData?.productName
        self.vwCondition.isHidden = true
        self.vwColor.isHidden = true
        self.vwMaterial.isHidden = true
        self.vwDimension.isHidden = true
        let dimensions = self.viewModel.productDetails?.productDimension?.first
        let data1 = (dimensions?.height ?? "").isEmpty ? "" : (dimensions?.height ?? "") + " " + "cm"
        let data2 = (dimensions?.width ?? "").isEmpty ? "" : (dimensions?.width ?? "") + " " + "cm"
        let data3 = (dimensions?.length ?? "").isEmpty ? "" : (dimensions?.length ?? "") + " " + "cm"
        let data4 = (dimensions?.weight ?? "").isEmpty ? "" : (dimensions?.weight ?? "") + " " + "kg"
        
        self.lblHeightValue.superview?.isHidden = data1.isEmpty
        self.lblWidthValue.superview?.isHidden = data2.isEmpty
        self.lblLengthValue.superview?.isHidden = data3.isEmpty
        self.lblWeightValue.superview?.isHidden = data4.isEmpty
        
        self.lblHeightValue.text = data1
        self.lblWidthValue.text = data2
        self.lblLengthValue.text = data3
        self.lblWeightValue.text = data4

        self.vwDimensions.superview?.isHidden = data1.isEmpty && data2.isEmpty && data3.isEmpty && data4.isEmpty
        self.vwDimension.isHidden = true
        let descriptionsData = self.viewModel.setDescriptionsData()
        switch descriptionsData.count {
        case 3:
            self.lblCondition.text = descriptionsData[0].title
            self.lblTitleCondition.text = descriptionsData[0].title_condition ?? ""
            self.lblConditionDetail.text = descriptionsData[0].description
            self.lblMaterial.text = descriptionsData[2].title
            self.lblMaterialDetails.text = descriptionsData[2].description
            self.lblColor.text = descriptionsData[1].title
            self.lblColorDetail.text = descriptionsData[1].description
            self.vwCondition.isHidden = false
            self.vwColor.isHidden = false

            self.vwMaterial.isHidden = false

            if (descriptionsData[0].description ?? "").isEmpty {
                self.vwCondition.isHidden = true
            }
            
            if (descriptionsData[1].description ?? "").isEmpty {
                self.vwColor.isHidden = true
            }
            if (descriptionsData[2].description ?? "").isEmpty {
                self.vwMaterial.isHidden = true
            }
        case 2:
            
            self.lblCondition.text = descriptionsData[0].title
            self.lblTitleCondition.text = descriptionsData[0].title_condition ?? ""
            self.lblConditionDetail.text = descriptionsData[0].description
            self.lblColor.text = descriptionsData[1].title
            self.lblColorDetail.text = descriptionsData[1].description
            self.vwCondition.isHidden = false
            self.vwColor.isHidden = false
            self.vwMaterial.isHidden = true
            if (descriptionsData[0].description ?? "").isEmpty {
                self.vwCondition.isHidden = true
            }
            
            if (descriptionsData[1].description ?? "").isEmpty {
                self.vwColor.isHidden = true
            }
        case 1:
            
            self.lblCondition.text = descriptionsData[0].title
            self.lblTitleCondition.text = descriptionsData[0].title_condition ?? ""
            self.lblConditionDetail.text = descriptionsData[0].description
            self.vwCondition.isHidden = false
            self.vwColor.isHidden = true
            self.vwMaterial.isHidden = true
            if (descriptionsData[0].description ?? "").isEmpty {
                self.vwCondition.isHidden = true
            }
        default:
            break
        }
        
        self.lblCategoryValue.text = productData?.category
        self.lblSubACtegoryValue.text = productData?.subCategory
        self.lblSubSubCatValue.text = productData?.subSubCategory
        self.lblWarrantyValue.text = (productData?.warranty ?? "").isEmpty ? "No" : "Yes"
        self.lblInvoiceValue.text = (productData?.invoice ?? "").isEmpty ? "No" : "Yes"
        
        self.vwInvoice.isHidden = (productData?.warranty ?? "").isEmpty
        self.vwWarranty.isHidden = (productData?.invoice ?? "").isEmpty
        
        self.viewModel.arrProductKpis = data?.productKpis ?? []
        self.lblResouceSavingTitle.superview?.isHidden = viewModel.arrProductKpis.count == 0
        self.tblProductKpis.reloadData()
        
        self.lblMrp.setStrikethrough(text: kCurrency + (productData?.originalPrice?.description ?? Status.zero.rawValue))
//        self.lblOfferPriceS.text = productData?.salePrice?.description
//        self.lblMrpPriceS.setStrikethrough(text: productData?.originalPrice?.description ?? "")
        self.lblOfferPrice.text = kCurrency + (productData?.salePrice?.description ?? Status.zero.rawValue)
        
        if let np = Double(productData?.salePrice ?? Status.zero.rawValue) , np > 0 {
            self.lblOfferPrice.text = kCurrency + (productData?.salePrice ?? Status.zero.rawValue)
        } else {
            self.lblOfferPrice.text = ""
        }
        if let price = Double(productData?.originalPrice ?? Status.zero.rawValue), price > 0 {
            self.lblMrp.attributedText = (kCurrency + (productData?.originalPrice ?? Status.zero.rawValue)).strikeThrough()
        } else {
            self.lblMrp.isHidden = true
        }
        
        if Double(productData?.salePrice ?? Status.zero.rawValue) == Double(productData?.originalPrice ?? Status.zero.rawValue) {
            self.lblMrp.isHidden = true
        }
//        self.btnMakeOffer.isHidden = productData?.isOfferSend == Status.one.rawValue
//        self.btnMakeOffer.isHidden = productData?.isOfferSend == Status.one.rawValue
    }
    
    func setView(isHide: Bool) {
        self.vwLike.isHidden = isHide
        self.btnSend.isHidden = isHide
        self.vwBottomButton.isHidden = isHide
        self.lblContactSeller.isHidden = isHide
    }
    func setLikeView() {
            self.vwLike.addTapGesture {
                if UserDefaults.isGuestUser {
                    appDelegate.setLogin()
                } else {
                    self.viewModel.addRemoveFavourite(isFav: (self.viewModel.productDetails?.product?.isLike == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue), productId: self.productID) { isDone in
                        if isDone {
                            self.apiCalling()
                        }
                    }
                }
            }
        
        self.viewSellerRating.addTapGesture {
            self.coordinator?.navigateToPopularStore(storeId: self.viewModel.productDetails?.store?.storeID ?? "")
        }
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let tbl = object as? UITableView {
            
            if tbl == tblProductKpis {
                tblProductKpisHT.constant = tblProductKpis.contentSize.height
            }
        }else if let clv = object as? UICollectionView {
            if clv == clvProducts {
                heightSimilarProduct.constant = clvProducts.contentSize.height
            }
        }
        
        UIView.animate(withDuration: 0.1) { }
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchData(storeId: "", productId: self.productID) { isDone in
            if isDone {
                self.clvProducts.delegate = self
                self.clvProducts.dataSource = self
                self.vwMain.isHidden = false

                self.setData()
            }
        }
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        self.vwMain.isHidden = true
        self.lblScalpPay.text = Labels.telr
        self.imgPro.isHidden = true
        [self.btnAddToCart, self.btnMakeOffer, self.btnBuyNow].forEach {
            $0.font(font: .semibold, size: .size16)
        }
        
        self.btnBuyNowS.font(font: .medium, size: .size12)
        self.btnMakeAnOfferS.font(font: .medium, size: .size12)
        
        /// ** Description
        self.lblDescription.font(font: .semibold, size: .size16)
        self.lblDeliveryType.font(font: .semibold, size: .size16)
        self.lblDeliveryType.color(color: .themeBlack)
        self.lblDeliveryTypeDetails.color(color: .themeBlack)
        self.lblCondition.font(font: .medium, size: .size14)
        self.lblDeliveryTypeDetails.font(font: .regular, size: .size14)
        self.lblConditionDetail.font(font: .regular, size: .size14)
        self.lblTitleCondition.font(font: .medium, size: .size14)
        self.lblMaterial.font(font: .medium, size: .size14)
        self.lblMaterialDetails.font(font: .medium, size: .size14)
        self.lblDimensions.font(font: .medium, size: .size14)
        self.lblDimensionsDetail.font(font: .regular, size: .size14)
        self.lblColor.font(font: .medium, size: .size14)
        self.lblColorDetail.font(font: .regular, size: .size14)
        self.lblColorDetail.textAlignment = .left
        self.lblResouceSavingTitle.font(font: .semibold, size: .size16)
        self.btnRemoveBundle.font(font: .semibold, size: .size16)
        self.btnAddToBundle.font(font: .semibold, size: .size16)
        
        
        self.lblCategory.font(font: .medium, size: .size14)
        self.lblCategoryValue.font(font: .regular, size: .size14)
        self.lblSubACtegory.font(font: .medium, size: .size14)
        self.lblSubACtegoryValue.font(font: .regular, size: .size14)
        self.lblSubSubCat.font(font: .medium, size: .size14)
        self.lblSubSubCatValue.font(font: .regular, size: .size14)
        self.lblInvoice.font(font: .medium, size: .size14)
        self.lblInvoiceValue.font(font: .regular, size: .size14)
        self.lblWarranty.font(font: .medium, size: .size14)
        self.lblWarrantyValue.font(font: .regular, size: .size14)
        
        /// ** Follow Cell **
        self.lblSaleItems.font(font: .regular, size: .size12)
        self.lblSellerName.font(font: .medium, size: .size14)
        [self.lblRating, self.lblItemCount, self.lblContactSeller].forEach {
            $0.font(font: .medium, size: .size12)
        }
        [self.lblHeight,
         self.lblWidth,
         self.lblLength,
         self.lblWeight].forEach {
            $0.font(font: .regular, size: .size14)
            $0.color(color: .themeGray)
            $0.superview?.isHidden = true
        }
        [self.lblHeightValue,
         self.lblWidthValue,
         self.lblLengthValue,
         self.lblWeightValue].forEach {
            $0.font(font: .medium, size: .size14)
            $0.color(color: .themeBlack)
        }
        [self.vwProductDes, self.vwDeliveryType, self.vwDimensions, self.vwKPIs].forEach {
            $0?.cornerRadius(cornerRadius: 4.0)
            $0?.border(borderWidth: 1, borderColor: .themeBorder)
        }
        
        self.lblTitleDimensions.font(font: .semibold, size: .size16)
        self.lblTitleDimensions.color(color: .themeBlack)
        
        
        /// ** Product Detail **
        self.lblProductName.font(font: .semibold, size: .size16)
        self.lblOfferPrice.font(font: .semibold, size: .size16)
        self.lblStoreName.font(font: .regular, size: .size16)
        self.lblMrp.font(font: .regular, size: .size16)
        self.lblpayDescription.font(font: .medium, size: .size14)
        self.lblScalpPay.font(font: .medium, size: .size14)
        self.lblDescriptionContent.font(font: .regular, size: .size14)
        self.lblDescriptionContent.color(color: .themeGray)
        /// ** Small View **
        self.lblProductNameS.font(font: .semibold, size: .size16)
        self.lblMrpPriceS.font(font: .regular, size: .size12)
        self.lblOfferPriceS.font(font: .semibold, size: .size12)
        self.setLabels()
        self.setView(isHide: true)
        self.btnURLDegree.isHidden = true
        self.vwBottomButton.isHidden = true
        self.vwDimensions.superview?.isHidden = true
        self.headerTitle.textColor = .clear
        self.headerTitle.font(font: .medium, size: .size16)
        self.lblResouceSavingTitle.text = Labels.aSecondLifeToThisItemsContributesToSave
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.btnURLDegree.setTitle(Labels.uRL360Degree, for: .normal)
        self.lblColor.text = Labels.condition
        self.lblDimensions.text = Labels.dimensions
        self.lblCondition.text = Labels.condition
        self.lblDescription.text = Labels.description
        self.btnAddToCart.title(title: Labels.addToCart)
        self.btnMakeOffer.title(title: Labels.makeAnOffer)
        self.btnBuyNow.title(title: Labels.buyNow)
        self.btnBuyNow.title(title: Labels.buyNow)
        self.btnMakeOffer.title(title: Labels.makeAnOffer)
        self.lblDeliveryType.text = Labels.deliveryType
        self.lblTitleDimensions.text = Labels.dimensions
        self.lblHeight.text = Labels.height
        self.lblWidth.text = Labels.width
        self.lblWeight.text = Labels.weight
        self.lblLength.text = Labels.length
        self.lblCategory.text = Labels.category
        self.lblSubACtegory.text = Labels.subCategory
        self.lblSubSubCat.text = Labels.subSubcategory
        self.lblWarranty.text = Labels.warranty
        self.lblInvoice.text = Labels.invoice
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.registerCollection()
        self.manageRedirection()
        self.scrollView.delegate = self
        self.setUpTableView()
    }
    
    // --------------------------------------------
    
    private func manageRedirection() {
        switch productDetailType {
        case .goodsDefault:
            viewSellerRating.isHidden = false
            viewCard.isHidden = false
            btnAddToBundle.isHidden = true
            btnRemoveBundle.isHidden = true
            viewSeparator.isHidden = false
        case .bundle:
            viewSellerRating.isHidden = true
            viewCard.isHidden = true
            viewSeparator.isHidden = true
            btnAddToBundle.isHidden = isAddedToBundle
            btnRemoveBundle.isHidden = !isAddedToBundle
        default: break
        }
            self.lblContactSeller.addTapGesture {
                if UserDefaults.isGuestUser {
                    appDelegate.setLogin()
                } else {
                    self.viewModelMakeAnOffer.fetchMakeAnOfferAPI(offerType: "1", productId: self.productID, bundleId: "", amount: "", storeId: "") { status,data,error   in
                        if status {
                            self.coordinator?.navigateToChatDetail(isBlock: false, chatId: data, userId: "")
                        } else {
                            notifier.showToast(message: appLANG.retrive(label: error))
                        }
                    }
                }
        }
        
    }
    
    // --------------------------------------------
    
    private func registerCollection() {
        
        self.clvProductImages.delegate = self
        self.clvProductImages.dataSource = self
        self.clvProductImages.register(ProductImagesCell.nib, forCellWithReuseIdentifier: ProductImagesCell.reuseIdentifier)
        self.clvProducts.register(ProductViewCell.nib, forCellWithReuseIdentifier: ProductViewCell.reuseIdentifier)
    }
    
    // --------------------------------------------
    
    func setUpTableView() {
        
        self.tblProductKpis.delegate = self
        self.tblProductKpis.dataSource = self
        self.tblProductKpis.register(ProductDetailsKpisTableCell.nib, forCellReuseIdentifier: ProductDetailsKpisTableCell.identifier)
        self.tblProductKpis.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionBack(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
    @IBAction func actionAddToBundle(_ sender: Any) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            self.viewModel.addRemoveBundle(productId: self.productID, isAdd: "1") { isDone, error in
                if isDone {
                    self.btnRemoveBundle.isHidden = false
                    self.btnAddToBundle.isHidden = true
                }else if error != "" {
                    notifier.showToast(message: appLANG.retrive(label: error))
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionRemoveBundle(_ sender: Any) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            self.viewModel.addRemoveBundle(productId: self.productID, isAdd: "0") { isDone, error in
                if isDone {
                    self.btnRemoveBundle.isHidden = true
                    self.btnAddToBundle.isHidden = false
                }else if error != "" {
                    notifier.showToast(message: appLANG.retrive(label: error))
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionShare(_ sender: Any) {
        let productLink = self.viewModel.productDetails?.deeplink
        guard let url = URL(string: productLink ?? "") else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // --------------------------------------------
    
    @IBAction func btnAddCartTapped(_ sender: Any) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            GlobalRepo.shared.addtoCartAPI(self.productID) { status, error in
                if !status {
                    if let errorMsg = error {
                        notifier.showToast(message: appLANG.retrive(label: errorMsg))
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnMakeAnOfferTapped(_ sender: UIButton) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            if self.viewModel.productDetails?.product?.isOfferStatus == Status.one.rawValue {
                notifier.showToast(message: Labels.offerAlreadyAccepted)
            }else{
                self.coordinator?.presentMakeAnOffer(data: MakeAnOfferModel(offerType: "1", productId: self.productID, bundleId: "", amount: "0"), parentvc: self, price: (self.viewModel.productDetails?.product?.salePrice ?? "0"))
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnSmallMakeAnOfferTapped(_ sender: Any) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            self.coordinator?.presentMakeAnOffer(data: MakeAnOfferModel(offerType: "1", productId: self.productID, bundleId: "", amount: "0"), parentvc: self, price: (self.viewModel.productDetails?.product?.salePrice ?? "0"))
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnBuyNowTapped(_ sender: Any) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            GlobalRepo.shared.addtoCartAPI(self.productID) { status, error in
                
                    if let errorMsg = error {
                        notifier.showToast(message: appLANG.retrive(label: errorMsg))
                    } else {
                        self.coordinator?.navigateToCart(productDetails: self.viewModel.productDetails)
                    }
                
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnURLDegree(_ sender: Any) {
        self.coordinator?.navigateToWebView(urlStr: self.viewModel.productDetails?.product?.equirectangularImageUrl ?? "")
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UIScrollView Delegate methods
// --------------------------------------------

extension ProductDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        // You can adjust the threshold value based on your needs
        let threshold: CGFloat = scrollView.frame.size.height / 1.5
        
        if offset > threshold {
            viewOffer.isHidden = true
            self.vwHeader.backgroundColor = .themeWhite
            self.vwHeaderBG.backgroundColor = .themeWhite
            self.headerTitle.textColor = .themeBlack
            
            //constScrollTop.constant = 60
        } else {
            self.vwHeader.backgroundColor = .clear
            self.vwHeaderBG.backgroundColor = .clear
            self.headerTitle.textColor = .clear
            viewOffer.isHidden = true
            //  constScrollTop.constant = 0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = currentPage
    }
}
