//
//  SellProductDetailVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit

class SellProductDetailVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwInvoice: UIStackView!
    @IBOutlet weak var vwWarranty: UIStackView!
    
    @IBOutlet weak var vwHeaderBG: UIView!
    @IBOutlet weak var clvProductImages: UICollectionView!
    
    @IBOutlet weak var vwMain: UIScrollView!
    /// Item Detail
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var btnBoost: UIButton!
    
    /// Description
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDescriptionContent: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblCategoryDetail: UILabel!
    
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblSubCategoryDetail: UILabel!
    
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblConditionDetail: UILabel!
    
    @IBOutlet weak var lblDimensions: UILabel!
    @IBOutlet weak var lblDimensionsDetail: UILabel!
    
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblColorDetail: UILabel!
    
    /// Address
    @IBOutlet weak var lblPickUpAddress: UILabel!
    @IBOutlet weak var lblAddressName: UILabel!
    @IBOutlet weak var lblAddressLine: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    
    /// Type Of Delivery
    @IBOutlet weak var lblTypeOfDelivery: UILabel!
    @IBOutlet weak var lblDeliveryType: UILabel!
    
    @IBOutlet weak var lblDeliveryMethod: UILabel!
    @IBOutlet weak var lblDeliveryMethodType: UILabel!
    
    /// Action buttons
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnHide: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnPinProduct: UIButton!
    @IBOutlet weak var btnUnpinProduct: UIButton!
    
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnURLDegree: ThemeGreenButton!
    @IBOutlet weak var vwButtons: UIStackView!
    
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblQtyValue: UILabel!
    
    @IBOutlet weak var lblMaterial: UILabel!
    @IBOutlet weak var lblMaterialDetails: UILabel!
    
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
    
    @IBOutlet weak var vwProductDes: UIView!
    @IBOutlet weak var vwAddess: UIView!
    @IBOutlet weak var vwDeliveryType: UIView!
    @IBOutlet weak var vwDeliveryMethods: UIView!
    
    @IBOutlet weak var lblSubSubCat: UILabel!
    @IBOutlet weak var lblSubSubCatVAl: UILabel!
    
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var lblInvoiceValue: UILabel!
    
    @IBOutlet weak var lblWarranty: UILabel!
    @IBOutlet weak var lblWarrantyValue: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : SellProductDetailVM = SellProductDetailVM()
    lazy var arrImages: [UIImage] = [.ivInterior, .ivChair, .ivInterior]
    lazy var productDetailType: ProductDetailType = .goodsPro
    var storeId : String = ""
    var productID : String = ""
    // var productStatus : String = ""
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCalling()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.registerCollection()
        self.manageRedirection()
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        self.vwMain.isHidden = true
        self.clvProductImages.isPagingEnabled = true
        if !(appUserDefaults.getValue(.isProUser) ?? false) {
            self.btnPinProduct.isHidden = true
            self.btnUnpinProduct.isHidden = true
        }
        /// ** Item Detail
        self.lblItemName.font(font: .semibold, size: .size16)
        self.lblStoreName.font(font: .regular, size: .size14)
        self.lblOfferPrice.font(font: .semibold, size: .size18)
        self.lblMrp.font(font: .regular, size: .size16)
        self.lblMrp.setStrikethrough(text: "AED 400")
        self.btnBoost.font(font: .semibold, size: .size16)
        
        /// ** Description
        self.lblDescription.font(font: .semibold, size: .size16)
        self.lblDescriptionContent.font(font: .regular, size: .size14)
        
        self.lblCategory.font(font: .medium, size: .size14)
        self.lblSubCategory.font(font: .medium, size: .size14)
        self.lblCondition.font(font: .medium, size: .size14)
        self.lblConditionDetail.font(font: .regular, size: .size14)
        self.lblDimensions.font(font: .medium, size: .size14)
        
        self.lblDimensionsDetail.font(font: .regular, size: .size14)
        
        self.lblColor.font(font: .medium, size: .size14)
        
        self.lblColorDetail.font(font: .regular, size: .size14)
        
        /// Address
        self.lblPickUpAddress.font(font: .semibold, size: .size16)
        self.lblAddressName.font(font: .medium, size: .size14)
        self.lblAddressLine.font(font: .regular, size: .size14)
        self.lblContact.font(font: .regular, size: .size14)
        
        /// Type Of Delivery
        self.lblTypeOfDelivery.font(font: .semibold, size: .size16)
        self.lblDeliveryType.font(font: .regular, size: .size14)
        
        self.lblDeliveryMethod.font(font: .semibold, size: .size16)
        self.lblDeliveryMethodType.font(font: .regular, size: .size14)
        
        self.lblSubSubCat.font(font: .medium, size: .size14)
        self.lblSubSubCatVAl.font(font: .regular, size: .size14)
        
        self.lblInvoice.font(font: .medium, size: .size14)
        self.lblInvoiceValue.font(font: .regular, size: .size14)
        
        self.lblWarranty.font(font: .medium, size: .size14)
        self.lblWarrantyValue.font(font: .regular, size: .size14)
        
        /// Buttons
        self.btnEdit.font(font: .semibold, size: .size16)
        self.btnHide.font(font: .semibold, size: .size16)
        self.btnDelete.font(font: .semibold, size: .size16)
        self.btnPinProduct.font(font: .semibold, size: .size16)
        self.btnUnpinProduct.font(font: .semibold, size: .size16)
        self.btnURLDegree.setTitle(Labels.uRL360Degree, for: .normal)
        self.btnURLDegree.isHidden = true
        self.scrollView.delegate = self
        self.btnBoost.superview?.isHidden = true
        self.vwButtons.isHidden = true
        self.setLabels()
        self.lblQty.superview?.isHidden =  !(appUserDefaults.getValue(.isProUser) ?? false)
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
        [self.vwDimensions,
         self.vwProductDes,
         self.vwAddess,
         self.vwDeliveryType,
         self.vwDeliveryMethods].forEach {
            $0.cornerRadius(cornerRadius: 4.0)
            $0.border(borderWidth: 1, borderColor: .themeBorder)
        }
        self.lblTitleDimensions.font(font: .semibold, size: .size16)
        self.lblTitleDimensions.color(color: .themeBlack)
        self.headerTitle.textColor = .clear
        self.headerTitle.font(font: .medium, size: .size16)
        self.vwDimensions.superview?.isHidden = true
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.lblColor.text = Labels.color
        self.lblCategory.text = Labels.category
        self.lblSubCategory.text = Labels.subCategory
        self.lblCondition.text = Labels.condition
        self.lblDimensions.text = Labels.dimensions
        self.lblTitleDimensions.text = Labels.dimensions
        self.lblSubSubCat.text = Labels.subSubcategory
        self.lblWarranty.text = Labels.warranty
        self.lblInvoice.text = Labels.invoice
        self.lblHeight.text = Labels.height
        self.lblWidth.text = Labels.width
        self.lblWeight.text = Labels.weight
        self.lblLength.text = Labels.length
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchData(storeId: self.storeId, productId: self.productID) { isDone in
            if isDone {
                self.vwMain.isHidden = false
            }
            self.setData()
        }
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.clvProductImages.reloadData()
        self.pageControl.numberOfPages = self.viewModel.numberOfProductImages()
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.themeLightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.themeGreen
        let address = self.viewModel.setAddress()
        let productData = self.viewModel.setProductDetails()
        if let url = productData.equirectangularImageUrl, !(url.isEmpty) {
            self.btnURLDegree.isHidden = false
        }
        let deliveryMethod = self.viewModel.setDeliveryMethods()
        let dimensions = self.viewModel.productDetails?.productDimension?.first
        let data1 = (dimensions?.height ?? "").isEmpty ? "" : (dimensions?.height ?? "") + "cm"
        let data2 = (dimensions?.width ?? "").isEmpty ? "" : (dimensions?.width ?? "") + "cm"
        let data3 = (dimensions?.length ?? "").isEmpty ? "" : (dimensions?.length ?? "") + "cm"
        let data4 = (dimensions?.weight ?? "").isEmpty ? "" : (dimensions?.weight ?? "") + "kg"
        self.lblDimensionsDetail.isHidden = true
        self.lblDimensionsDetail.superview?.isHidden = true
        
        self.vwDimensions.superview?.isHidden = data1.isEmpty && data2.isEmpty && data3.isEmpty && data4.isEmpty
        self.lblHeightValue.superview?.isHidden = data1.isEmpty
        self.lblWidthValue.superview?.isHidden = data2.isEmpty
        self.lblLengthValue.superview?.isHidden = data3.isEmpty
        self.lblWeightValue.superview?.isHidden = data4.isEmpty
        
        self.lblHeightValue.text = data1
        self.lblWidthValue.text = data2
        self.lblLengthValue.text = data3
        self.lblWeightValue.text = data4
        let des = self.viewModel.setDescriptionsData()
        self.headerTitle.text = productData.productName
        self.lblItemName.text = productData.productName
        self.lblStoreName.text = productData.brandName
        self.lblDescriptionContent.text = productData.description
        self.lblAddressName.text = setString(str: address.fullName ?? "")
        self.lblAddressLine.text = setString(str: (address.floor ?? "")) + ", " + (address.streetAddress ?? "") + ",\n" + (address.area ?? "") + ", " + (address.city ?? "")
        self.lblContact.text = "(" + (address.countryCode ?? "") + ") " + (address.mobile ?? "")
        self.btnHide.setTitle((productData.isHide == Status.one.rawValue) ? Labels.unhide : Labels.hide, for: .normal)
        self.lblDeliveryType.text = self.viewModel.productDetails?.product?.typeOfDeliveryName ?? ""
        let methodNames = deliveryMethod.filter { $0.name != "Delivery" }.map { $0.name ?? "" }.joined(separator: ", ")//deliveryMethod.compactMap { $0.name }.joined(separator: ", ")
        self.lblDeliveryMethodType.text = methodNames
        self.lblCategoryDetail.text = productData.category ?? ""
        self.lblSubCategoryDetail.text = productData.subCategory ?? ""
        self.lblQtyValue.text = productData.qty
        self.lblSubSubCatVAl.text = productData.subSubCategory
        self.lblWarrantyValue.text = (productData.warranty ?? "").isEmpty ? "No" : "Yes"
        self.lblInvoiceValue.text = (productData.invoice ?? "").isEmpty ? "No" : "Yes"
        
        self.vwInvoice.isHidden = (productData.warranty ?? "").isEmpty
        self.vwWarranty.isHidden = (productData.invoice ?? "").isEmpty
        
        var text : [String] = [String]()
        for i in des {
            if i.title == "Color" {
                text.append(i.description ?? "")
            } else if i.title == "Condition" {
                
                self.lblConditionDetail.superview?.isHidden = (i.description ?? "").isEmpty
                self.lblCondition.text = i.title
                self.lblConditionDetail.text = i.description
            } else if i.title == "Material" {
                
                self.lblMaterialDetails.superview?.isHidden = (i.description ?? "").isEmpty
                self.lblMaterial.text = i.title
                self.lblMaterialDetails.text = i.description
            } else {}
        }
        self.lblColorDetail.text = text.joined(separator: ", ")
        self.lblColorDetail.superview?.isHidden = text.joined(separator: ", ").isEmpty
        
        self.btnUnpinProduct.isHidden = productData.isPin != Status.one.rawValue
        self.btnPinProduct.isHidden = productData.isPin == Status.one.rawValue
        
        if productData.isBoosted == Status.one.rawValue {
            self.btnBoost.setTitle(Labels.boosted, for: .normal)
            self.btnBoost.border(borderWidth: 1.5, borderColor: .themeGreen)
            self.btnBoost.backgroundColor = .white
        } else {
            self.btnBoost.setTitle(Labels.boost, for: .normal)
            self.btnBoost.backgroundColor = .themeGreen
        }
        
        
        self.btnBoost.superview?.isHidden = (productData.isProductVerified != Status.one.rawValue)
        self.vwButtons.isHidden = (productData.isProductVerified != Status.one.rawValue)

        self.lblOfferPrice.text = kCurrency + (productData.salePrice ?? "0")
        self.lblMrp.text = kCurrency + (productData.originalPrice ?? "0")
        
        if let np = Double(productData.salePrice ?? Status.zero.rawValue) , np > 0 {
            self.lblOfferPrice.text = kCurrency + (productData.salePrice ?? Status.zero.rawValue)
        } else {
            self.lblOfferPrice.text = ""
        }
        if let price = Double(productData.originalPrice ?? Status.zero.rawValue), price > 0 {
            self.lblMrp.attributedText = (kCurrency + (productData.originalPrice ?? Status.zero.rawValue)).strikeThrough()
        } else {
            self.lblMrp.isHidden = true
        }
        
        if Double(productData.salePrice ?? Status.zero.rawValue) == Double(productData.originalPrice ?? Status.zero.rawValue) {
            self.lblMrp.isHidden = true
        }
    
    }
    
    // --------------------------------------------
    
    func setString(str: String) -> String {
        return String(str.prefix(1)).uppercased() + String(str.dropFirst())
    }
    
    // --------------------------------------------
    
    func manageRedirection() {
        var isPro = !(appUserDefaults.getValue(.isProUser) ?? false)
        self.btnPinProduct.isHidden = isPro
        self.btnUnpinProduct.isHidden = isPro
    }
    
    // --------------------------------------------
    
    private func registerCollection() {
        self.clvProductImages.delegate = self
        self.clvProductImages.dataSource = self
        self.clvProductImages.register(ProductImagesCell.nib, forCellWithReuseIdentifier: ProductImagesCell.reuseIdentifier)
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionBack(_ sender: Any) {
        
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
    @IBAction func actionUnpinProduct(_ sender: Any) {
        let id  = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID ?? ""
        self.viewModel.fetchPinUnpinItemAPI(storeId: id, productId: self.productID, isPinUnpin: "0") { status in
            if status {
                self.btnUnpinProduct.isHidden = true
                self.btnPinProduct.isHidden = false
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionDelete(_ sender: Any) {
        self.coordinator?.showPopUp(title: Labels.delete + " ", description: Labels.areYouSureWantToDeleteproduct, storeId: self.viewModel.productDetails?.store?.storeID ?? "", productId: self.productID, isHide: "", type: .delete) { status in
            if status {
                self.coordinator?.popVCWithOutAnimation()
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionHide(_ sender: Any) {
        let des : String = (self.viewModel.productDetails?.product?.isHide == Status.zero.rawValue) ? Labels.areYouSureWantToHideProduct : Labels.areYouSureWantToUnHideProduct
        self.coordinator?.showPopUp(title: Labels.hide, description: des, storeId: self.viewModel.productDetails?.store?.storeID ?? "", productId: self.productID, isHide: (self.viewModel.productDetails?.product?.isHide == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue), type: .hide) { stauts in
            if stauts {
                self.apiCalling()
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionEdit(_ sender: Any) {
        self.coordinator?.navigateToSell(productID: productID, isFromEdit: true,productDetails: viewModel.productDetails)
        
    }
    
    // --------------------------------------------
    
    @IBAction func actionPinProduct(_ sender: Any) {
        let id  = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID ?? ""
        self.viewModel.fetchPinUnpinItemAPI(storeId: id, productId: self.productID, isPinUnpin: "1") { status in
            if status {
                self.btnUnpinProduct.isHidden = false
                self.btnPinProduct.isHidden = true
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnURLDegreeTapped(_ sender: Any) {
        self.coordinator?.navigateToWebView(urlStr: self.viewModel.productDetails?.product?.equirectangularImageUrl ?? "")
    }
    
    // --------------------------------------------
    
    @IBAction func btnShareTapped(_ sender: Any) {
        
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
    
    
    @IBAction func btnBoosteTapped(_ sender: Any) {
        self.coordinator?.navigateToBoostItemDetails(isBoosted: (self.viewModel.productDetails?.product?.isBoosted == "1") ? true : false, productID: self.productID)
        
    }
    
}
extension SellProductDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        // You can adjust the threshold value based on your needs
        let threshold: CGFloat = scrollView.frame.size.height / 1.5
        
        if offset > threshold {
            self.vwHeader.backgroundColor = .themeWhite
            self.vwHeaderBG.backgroundColor = .themeWhite
            self.headerTitle.textColor = .themeBlack
        } else {
            self.vwHeader.backgroundColor = .clear
            self.vwHeaderBG.backgroundColor = .clear
            self.headerTitle.textColor = .clear
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = currentPage
    }
}
