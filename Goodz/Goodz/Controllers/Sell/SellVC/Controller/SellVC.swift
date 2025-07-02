//
//  SellVC.swift
//  Goodz

//
//  Created by Akruti on 01/12/23.
//

import Foundation
import UIKit
import AVFoundation

class SellVC : BaseVC, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    @IBOutlet weak var headerView: AppStatusView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblsell1: UILabel!
    @IBOutlet weak var lblSell2: UILabel!
    
    /// Quantity
    
    var quantity = 0
    var quantitySet = 1
    var seletedQunatityIndex :  Int?
    @IBOutlet weak var lblNum       : UILabel!
    @IBOutlet weak var lblNumSet    : UILabel!
    @IBOutlet weak var lblResult    : UILabel!
    @IBOutlet weak var lblq1        : UILabel!
    @IBOutlet weak var lblq2        : UILabel!
    
    
    @IBOutlet weak var numView        : UIView!
    @IBOutlet weak var setView        : UIView!
    
    
    @IBOutlet weak var btnSetMin    : UIButton!
    @IBOutlet weak var btnSetPlus   : UIButton!
    @IBOutlet weak var btnNumMin    : UIButton!
    @IBOutlet weak var btnNumPlus   : UIButton!
    
    
    
    
    /// Tips
    @IBOutlet weak var tipView : UIView!
    @IBOutlet weak var hideButton : UIButton!
    @IBOutlet weak var hidetitle : UILabel!
    @IBOutlet weak var hideImg : UIImageView!
    
    /// Upload Photo or Video
    @IBOutlet weak var lblPhotosNVideo: UILabel!
    @IBOutlet weak var lblUploadPhoto: UILabel!
    @IBOutlet weak var lblAddPhotosNVideoDesc1: UILabel!
    @IBOutlet weak var lblAddPhotosNVideoDesc2: UILabel!
    @IBOutlet weak var lblAddPhotosNVideoDesc3: UILabel!
    
    @IBOutlet weak var clvAddPhoto: UICollectionView!
    @IBOutlet weak var constCLVAddPhotos: NSLayoutConstraint!
    
    /// Product Basic Info
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tbvProductInfo: UITableView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewQty: UIView! ///pro user
    @IBOutlet weak var txtProductTitle: AppTextField!
    @IBOutlet weak var stepperQTY: GMStepper!
    
    /// Dimension
    @IBOutlet weak var lblDimension: UILabel!
    
    @IBOutlet weak var lblDimensionRule : UILabel!
    
    @IBOutlet weak var lblOptional: UILabel!
    @IBOutlet weak var lblDimensionDescription: UILabel!
    
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtLength: UITextField!
    @IBOutlet weak var txtWidth: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblLength: UILabel!
    @IBOutlet weak var lblWidth: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    
    @IBOutlet weak var lblHeightType: UILabel!
    @IBOutlet weak var lblLengthType: UILabel!
    @IBOutlet weak var lblWidthType: UILabel!
    @IBOutlet weak var lblWeightType: UILabel!
    
    /// Product Details
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblColorOptional: UILabel!
    @IBOutlet weak var lblSelectedColor: UILabel!
    
    @IBOutlet weak var viewMaterial: UIView!
    @IBOutlet weak var lblMaterial: UILabel!
    @IBOutlet weak var lblMaterialOptional: UILabel!
    @IBOutlet weak var lblSelectedMaterial: UILabel!
    
    @IBOutlet weak var viewInvoice: UIView!
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var lblInvoiceOptional: UILabel!
    
    @IBOutlet weak var viewWarranty: UIView!
    @IBOutlet weak var lblWarranty: UILabel!
    @IBOutlet weak var lblWarrantyOptional: UILabel!
    
    /// Color, Material, Invoice, Warranty
    @IBOutlet weak var lblInvoiceRemove: UILabel!
    @IBOutlet weak var vwInvoiceRemove: UIView!
    @IBOutlet weak var btnInvoiceRemove: UIButton!
    @IBOutlet weak var btnInvoiceUpload: UIButton!
    @IBOutlet weak var btnWarrantyUpload: UIButton!
    @IBOutlet weak var btnWarrantyRemove: UIButton!
    @IBOutlet weak var lblWarrantyRemove: UILabel!
    @IBOutlet weak var vwWarrantyRemove: UIView!
    
    
    /// Address
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPickUpAddress: UILabel!
    @IBOutlet weak var viewAddAddress: UIView!
    @IBOutlet weak var viewAddress: UIView!
    
    /// Type of Delivery
    @IBOutlet weak var lblTypeOfDelivery: UILabel!
    @IBOutlet weak var lblTypeOfDeliverySubTitle: UILabel!
    
    /// Delivery Method
    @IBOutlet weak var clvTypeOfDelivery: UICollectionView!
    @IBOutlet weak var lblDeliveryMethod: UILabel!
    @IBOutlet weak var lblDeliveryDescription: UILabel!
    @IBOutlet weak var tbvDeliveryMethods: UITableView!
    
    /// Pin Product
    @IBOutlet weak var viewPinProduct: UIView!
    @IBOutlet weak var lblPinProduct: UILabel!
    
    @IBOutlet weak var viewSelectPinProduct: UIView!
    @IBOutlet weak var ivCheckPin: UIImageView!
    
    /// Term condition
    @IBOutlet weak var viewTermCondition: UIView!
    @IBOutlet weak var lblTermCondition: UILabel!
    @IBOutlet weak var ivCheckTandC: UIImageView!
    
    @IBOutlet weak var lblBulbInstruction: UILabel!
    @IBOutlet weak var txtOriginalPrice: AppTextField!
    @IBOutlet weak var txtSellingPrice: AppTextField!
    @IBOutlet weak var txtEarningPrice: AppTextField!
    
    @IBOutlet weak var lblAddPrice: UILabel!
    @IBOutlet weak var lblBrandNewPrice: UILabel!
    @IBOutlet weak var lblBrandNewPriceOptional: UILabel!
    @IBOutlet weak var lblBrandNewPriceDesc: UILabel!
    
    @IBOutlet weak var sendMsgBackView: UIView!
    @IBOutlet weak var sendMsgLbl: UILabel!
    @IBOutlet weak var sendMsgSwitchBtn: UISwitch!
    
    @IBOutlet weak var negotiateBackView: UIView!
    @IBOutlet weak var negotiateLbl: UILabel!
    @IBOutlet weak var negotiateSwitchBtn: UISwitch!

    @IBOutlet weak var lblSellingPrice: UILabel!
    @IBOutlet weak var lblSellingPriceDesc: UILabel!
    
    @IBOutlet weak var lblForYouPrice: UILabel!
    @IBOutlet weak var lblForYouPriceDesc: UILabel!
    
    @IBOutlet weak var lblPriceSuggestion: UILabel!
    @IBOutlet weak var lblSellFaster: UILabel!
    @IBOutlet weak var lblSellSlower: UILabel!
    
    @IBOutlet weak var lblIntegrateGoodzDeals: UILabel!
    @IBOutlet weak var lblIntegrateGoodzDealsDesc1: UILabel!
    @IBOutlet weak var lblIntegrateGoodzDealsDesc2: UILabel!
    @IBOutlet weak var lblIntegrateGoodzDealsDesc3: UILabel!
    
    @IBOutlet weak var lblAddressUserName: UILabel!
    @IBOutlet weak var lblAddressLocation: UILabel!
    @IBOutlet weak var lblAddressMobile: UILabel!
    @IBOutlet weak var lblChange: UILabel!
    
    @IBOutlet weak var vwTextView: UIView!
    
    @IBOutlet weak var btnSellNow: UIButton!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var lblGoodzDeals: UILabel!
    
    @IBOutlet weak var lblForYou: UILabel!
    @IBOutlet weak var imgInfo: UIImageView!
    
    @IBOutlet weak var lblAddressDetails: UILabel!
    @IBOutlet weak var lblRangeAmount: UILabel!
    // --------------------------------------------
    // MARK: - Custom Variables
    // --------------------------------------------
    
    var arrCategoryItems = SellVCProductInfoType.allCases
    var arrMedia : [SellItemUploadMediaModel] = [SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "ivAddPhoto" ),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "" , dymyImg: "imgFront"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "ImgBackD"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "img34"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "imgDegault"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "imgSide")]
    lazy var sellItemType: SellItemType = .goodsDefault
    var viewModel : SellVM = SellVM()
    var selectedDeliveryType : Int = 0
    var categoryMain : CategoryMainModel?
    var categorySub : CategorySubModel?
    var categoryCollection : CategoryCollectionModel?
    var condition : ConditionModel?
    var brand : BrandModel?
    var colorSelectedArr : [ColorModel]? = nil
    var materialSelectedArr : [ColorModel]? = nil
    var arrSelectedDeliveryMethod : [DeliveryMethodsModel] = []
    var isFromEdit = false
    var productDetails : ProductDetailsModel?
    var address: MyAddressModel?
    var sellVCUploadBtnType: SellVCUploadBtnType = .invoice
    var isAgreeTermCondition = false
    var dispatchGroup = DispatchGroup()
    var invoiceURL : URL?
    var warrantyURL : URL?
    var productID = ""
    var isGoodzDeals : Bool = false
    var defaultCover  = 1
    let commision = (appDelegate.generalModel?.commission?.toDouble() ?? 0) / 100
    var offer_toggle  = true
    var receive_chat = true
     
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SellVC")
        if !self.isFromEdit {
           // self.setClearData()
        }
        
        self.clvAddPhoto.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        DispatchQueue.main.async {
            self.tbvProductInfo.reloadData()
        }
        
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.clvAddPhoto.removeObserver(self, forKeyPath: "contentSize")
    }
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.headerView.textTitle = isFromEdit  ? Labels.editSellItem : Labels.sellYourItem
        self.headerView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        self.headerView.btnBack.isHidden = !isFromEdit
        
        /// Upload photo or video
        self.lblPhotosNVideo.font(font: .medium, size: .size14)
        self.lblUploadPhoto.font(font: .regular, size: .size14)
        self.lblSell2.font(font: .regular, size: .size14)
        self.lblsell1.font(font: .regular, size: .size14)
        self.lblAddPhotosNVideoDesc1.font(font: .regular, size: .size13)
        self.lblAddPhotosNVideoDesc2.font(font: .regular, size: .size13)
        self.lblAddPhotosNVideoDesc3.font(font: .regular, size: .size13)
        self.lblTitle.font(font: .medium, size: .size14)
        self.lblDescription.font(font: .medium, size: .size14)
       
        self.txtProductTitle.txt.delegate = self
        self.txtProductTitle.txt.setAutocapitalization()
        self.txtView.delegate = self
        self.txtView.setPlaceholder(text: Labels.productDescription, color: UIColor.lightGray)
        self.txtView.setAutocapitalization()

        
        [self.txtHeight, self.txtLength, self.txtWidth, self.txtWeight].forEach {
            $0?.font(font: .medium, size: .size14)
            $0?.textAlignment = .center
            $0?.delegate = self
        }
        
        [self.lblHeight, self.lblLength, self.lblWidth, self.lblWeight].forEach {
            $0?.font(font: .medium, size: .size12)
        }
        
        [self.lblHeightType, self.lblLengthType, self.lblWidthType, self.lblWeightType].forEach {
            $0?.font(font: .medium, size: .size14)
        }

        
        self.txtOriginalPrice.txt.delegate = self
        self.txtSellingPrice.txt.delegate = self
        self.txtEarningPrice.txt.delegate = self
        self.txtOriginalPrice.delegate = self
        self.txtSellingPrice.delegate = self
        self.txtEarningPrice.delegate = self
        
        [self.txtHeight, self.txtLength, self.txtWidth, self.txtWeight, self.txtOriginalPrice.txt, self.txtSellingPrice.txt, self.txtEarningPrice.txt].forEach {
            $0?.keyboardType = .decimalPad
        }
       
        /// Dimension
        self.lblDimension.font(font: .medium, size: .size16)
        self.lblOptional.font(font: .regular, size: .size14)
        self.lblDimensionDescription.font(font: .regular, size: .size13)
        
        self.lblDimensionRule.font(font: .medium, size: .size12)
        
        /// Product Details
        self.lblColor.font(font: .medium, size: .size16)
        self.lblColorOptional.font(font: .regular, size: .size14)
        
        self.lblForYou.font(font: .regular, size: .size12)
        self.lblForYou.color(color: .themeGray)
        
        self.lblAddressDetails.font(font: .regular, size: .size14)
        self.lblAddressDetails.color(color: .themeGray)
                
        self.hideButton.font(font: .regular, size: .size14)
        self.hidetitle.font(font: .regular, size: .size14)
        
        self.lblSelectedColor.color(color: .themeGray)
        self.lblSelectedColor.font(font: .regular, size: .size14)
        
        self.lblMaterial.font(font: .medium, size: .size16)
        self.lblMaterialOptional.font(font: .regular, size: .size14)
        
        
        self.lblSelectedMaterial.color(color: .themeGray)
        self.lblSelectedMaterial.font(font: .regular, size: .size14)
        
        self.lblInvoice.font(font: .medium, size: .size16)
        self.lblInvoiceOptional.font(font: .regular, size: .size14)
        
        
        self.lblWarranty.font(font: .medium, size: .size16)
        self.lblWarrantyOptional.font(font: .regular, size: .size14)
        
        
        self.btnInvoiceUpload.font(font: .medium, size: .size12)
        self.btnWarrantyUpload.font(font: .medium, size: .size12)
        
        
        self.lblInvoiceRemove.font(font: .medium, size: .size12)
        self.lblWarrantyRemove.font(font: .medium, size: .size12)
        
        /// Address
        self.lblAddress.font(font: .semibold, size: .size16)
        self.lblPickUpAddress.font(font: .regular, size: .size14)
        
        
        self.lblChange.font(font: .medium, size: .size16)
        
        /// Type Of Delivery
        self.lblTypeOfDelivery.font(font: .medium, size: .size16)
        self.lblRangeAmount.font(font: .regular, size: .size14)
        self.lblRangeAmount.numberOfLines = 0
        /// DeliveryMethod
        self.lblDeliveryMethod.font(font: .medium, size: .size16)
        self.lblDeliveryDescription.font(font: .regular, size: .size14)
        self.lblTypeOfDeliverySubTitle.font(font: .regular, size: .size14)
        
        self.viewAddAddress.isHidden = false
        self.viewAddress.isHidden = true
        
        self.lblAddPrice.font(font: .medium, size: .size16)
        self.lblBrandNewPrice.font(font: .medium, size: .size12)
        self.lblBrandNewPriceOptional.font(font: .regular, size: .size14)
        self.lblBrandNewPriceDesc.font(font: .regular, size: .size14)
        self.lblSellingPrice.font(font: .medium, size: .size12)
        self.lblSellingPriceDesc.font(font: .regular, size: .size14)
        self.lblForYouPrice.font(font: .medium, size: .size14)
        self.lblForYouPriceDesc.font(font: .regular, size: .size14)
        self.lblPriceSuggestion.font(font: .medium, size: .size16)
        self.lblSellFaster.font(font: .regular, size: .size12)
        self.lblSellSlower.font(font: .regular, size: .size12)
        
        self.sendMsgLbl.font(font: .regular, size: .size14)
        self.negotiateLbl.font(font: .regular, size: .size14)
        
        self.lblIntegrateGoodzDeals.font(font: .medium, size: .size13)
        self.lblBulbInstruction.font(font: .regular, size: .size13)
        self.lblIntegrateGoodzDealsDesc1.font(font: .regular, size: .size13)
        self.lblIntegrateGoodzDealsDesc2.font(font: .regular, size: .size13)
        self.lblIntegrateGoodzDealsDesc3.font(font: .regular, size: .size13)
        
        self.setTermsAndConditionAttributedText()
        self.btnSellNow.font(font: .semibold, size: .size16)
    /*    self.stepperQTY.value = 1
        
        //hide buttons
        self.stepperQTY.leftButton.isHidden = true
        self.stepperQTY.rightButton.isHidden = true
        self.stepperQTY.border(borderWidth: 1.0, borderColor: .themeGreenProfile)*/
        
        self.lblGoodzDeals.color(color: .themeGoodz)
        self.lblGoodzDeals.font(font: .medium, size: .size16)
        self.rangeSlider.isUserInteractionEnabled = false
        self.lblGoodzDeals.isHidden = true
        self.rangeSicker()
        self.setLabels()
        self.txtEarningPrice.txt.isUserInteractionEnabled = false
        self.imgInfo.addTapGesture {
            self.showOKAlert(title: AppInfo().appName, message: Labels.sellInfo ) {
            }
        }
        
        self.lblOptional.isHidden = true
        
        
        lblNum.font(font: .medium, size: .size12)
        lblNumSet.font(font: .medium, size: .size12)
        lblResult.font(font: .medium, size: .size12)
        lblq1.font(font: .medium, size: .size14)
        lblq2.font(font: .medium, size: .size14)
        
        
        
        lblNum.color(color: .themeGray)
        lblNumSet.color(color: .themeGray)
        lblResult.color(color: .themeGray)
        lblq1.color(color: .themeBlack)
        lblq2.color(color: .themeBlack)
        
                       
        btnSetMin.font(font: .extraBold, size: .size18)
        btnSetPlus.font(font: .extraBold, size: .size18)
        btnNumMin.font(font: .extraBold, size: .size18)
        btnNumPlus.font(font: .extraBold, size: .size18)
        
        
        btnSetMin.color(color: .themeGreen)
        btnSetPlus.color(color: .themeGreen)
        btnNumMin.color(color: .themeGreen)
        btnNumPlus.color(color: .themeGreen)
        
        
        self.viewQty.isHidden = true
        self.numView.isHidden = true
        self.setView.isHidden = true
         
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.lblRangeAmount.text = ""
        self.btnSellNow.title(title: isFromEdit ? Labels.validateModifications : Labels.sellNow)
        self.lblGoodzDeals.text = Labels.itsAGoodzDea
        self.lblIntegrateGoodzDeals.text = Labels.toIntegrateGoodzDealShould
        self.lblBulbInstruction.text = Labels.toBoostYourItemsChanceSellingPrice
        self.lblIntegrateGoodzDealsDesc1.text = Labels.fillAllTheDimensions
        self.lblIntegrateGoodzDealsDesc2.text = Labels.uploadYourOriginalInvoice
        self.lblIntegrateGoodzDealsDesc3.text = Labels.sellingPriceIsDiscountFromTheBrandNewPrice
        self.lblSellFaster.text = Labels.sellFaster
        self.lblSellSlower.text = Labels.sellSlower
        self.lblPriceSuggestion.text = Labels.pricingSuggestion
        self.lblForYouPriceDesc.text = Labels.priceYouWillEarn
        self.txtOriginalPrice.placeholder = Labels.salesInAED
        self.txtSellingPrice.placeholder = Labels.salesInAED
        self.txtEarningPrice.placeholder = Labels.salesInAED
        self.lblAddPrice.text = Labels.price
        self.lblBrandNewPrice.text = Labels.brandNewPrice
        self.lblBrandNewPriceOptional.text = ""//Labels.optional
        self.lblBrandNewPriceDesc.text = Labels.originalBrandNewPriceOfYourItem
        self.lblSellingPrice.text = Labels.sellingPriceStar
        self.lblSellingPriceDesc.text = Labels.publicPriceOnGoodz
        self.lblForYouPrice.text = Labels.forYou
        self.lblDimension.text = Labels.dimensions + "*"
        self.lblOptional.text = Labels.optional
        self.lblDimensionDescription.text = Labels.sellFasterByFillingInTheDimensions
        self.lblColor.text = Labels.color
        self.lblColorOptional.text = Labels.optional
        self.lblMaterial.text = Labels.material
        self.lblMaterialOptional.text = Labels.optional
        self.lblInvoice.text = Labels.invoice
        self.lblInvoiceOptional.text = Labels.optional
        self.lblWarranty.text = Labels.warranty
        self.lblWarrantyOptional.text = Labels.optional
        self.btnInvoiceUpload.title(title: Labels.upload)
        self.btnWarrantyUpload.title(title: Labels.upload)
        self.lblAddress.text = Labels.address + "*"
        self.lblPickUpAddress.text = Labels.yourPickUpAddress
        self.lblChange.text = Labels.change
        self.lblTypeOfDelivery.text = Labels.typeOfDeliveryTitle
        self.lblTypeOfDeliverySubTitle.text = Labels.yourProductCouldFitIn
        self.lblDeliveryMethod.text = Labels.deliveryMethodTitle
       //self.lblDeliveryDescription.text = Labels.youCanChoseSeveralOptionsMsg
        self.lblHeight.text = Labels.height
        self.lblLength.text = Labels.length
        self.lblWidth.text = Labels.width
        self.lblWeight.text = Labels.weight
        self.txtHeight.placeholder = Labels.cm
        self.txtLength.placeholder = Labels.cm
        self.txtWidth.placeholder = Labels.cm
        self.txtWeight.placeholder = Labels.kg
        self.lblHeightType.text = Labels.cm
        self.lblLengthType.text = Labels.cm
        self.lblWidthType.text = Labels.cm
        self.lblWeightType.text = Labels.kg
        self.lblPhotosNVideo.text = Labels.addPhotosAndVideosOfYourItem
        self.lblUploadPhoto.text = Labels.uploadUpToPicturesAndVideos
        self.lblAddPhotosNVideoDesc1.text = Labels.addPhotoAndVideoDesc1
        self.lblAddPhotosNVideoDesc2.text = Labels.addPhotoAndVideoDesc2
        self.lblAddPhotosNVideoDesc3.text = Labels.addPhotoAndVideoDesc3
        self.lblTitle.text = Labels.titleStar
        self.lblDescription.text = Labels.descriptionStar
        self.txtProductTitle.placeholder = Labels.productTitle
        self.lblForYou.text = Labels.forYou
        self.lblAddressDetails.text = Labels.thisAddressWillEitherBeUsedForPickupForTheDeliveryOptionOrWillBeProvidedToTheBuyerOnlyOnceThePurchaseIsFinalizedOnThePlatform
    }
    
    // --------------------------------------------
    
    @objc func originalPriceChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        setSliderValues()
    }
    
    @objc func sellingPriceChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        setSliderValues()
        let commisionPrice = text.toDouble() * self.commision
        self.txtEarningPrice.txt.text = (text.toDouble() - commisionPrice).clean
        DispatchQueue.main.async {
            self.lblForYou.numberOfLines = 0
            self.lblForYou.text = Labels.forYou + " " + kCurrency + ((text.toDouble() - commisionPrice).clean).description
        }
    }
    
    @objc func forYouPriceChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        print("❗️❗️❗️❗️ for you Price : ", text)
        self.txtSellingPrice.txt.text = (text.toDouble() / (1 - self.commision)).clean
    }
    
    func setSliderValues() {
        DispatchQueue.main.async {
            let originalPrice: Double = (self.txtOriginalPrice.txt.text ?? "0").toDouble()
            let sellingPrice: Double = (self.txtSellingPrice.txt.text ?? "0").toDouble()
            
            self.rangeSlider.maxValue = sellingPrice > originalPrice ? sellingPrice : originalPrice
            self.rangeSlider.minValue = 0
            
            if originalPrice > 0 {
                let ogHalf = (originalPrice / 2)
                if ogHalf < sellingPrice {
                    self.rangeSlider.selectedMinValue = ogHalf
                    self.rangeSlider.selectedMaxValue = sellingPrice
                    self.lblRangeAmount.text = Labels.theOptimalSellingPriceIs + kCurrency + Int(ogHalf.rounded()).description + Labels.reduceYourPriceBy + kCurrency +
                    Int((sellingPrice - ogHalf).rounded()).description + Labels.toReachThatPrice
                    self.rangeSlider.isLeftCenter = true
                    self.lblRangeAmount.isHidden = false
                } else {
                    self.rangeSlider.selectedMaxValue = ogHalf
                    self.rangeSlider.selectedMinValue = sellingPrice
                    self.lblRangeAmount.text = ""
                    self.rangeSlider.isLeftCenter = false
                    self.lblRangeAmount.isHidden = true
                }
            } else {
                self.lblRangeAmount.isHidden = true
                self.rangeSlider.selectedMinValue = originalPrice
                self.rangeSlider.selectedMaxValue = sellingPrice
                self.rangeSlider.isLeftCenter = true
            }
            self.rangeSlider.layoutSubviews()
            self.rangeSlider.updateHandleUI()
            self.goodzDeals()
        }
    }
    
    func rangeSicker() {

        self.txtOriginalPrice.txt.addTarget(self, action: #selector(originalPriceChanged(_:)), for: .allEditingEvents)
        self.txtSellingPrice.txt.addTarget(self, action: #selector(sellingPriceChanged(_:)), for: .allEditingEvents)
        self.txtEarningPrice.txt.addTarget(self, action: #selector(forYouPriceChanged(_:)), for: .allEditingEvents)
        
        self.txtWidth.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.txtLength.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.txtHeight.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.txtWeight.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UICollectionView,
           obj1 == self.clvAddPhoto && keyPath == "contentSize" {
            self.constCLVAddPhotos.constant = self.clvAddPhoto.contentSize.height
        }
    }
    
    // --------------------------------------------
    
    func goodzDeals() {
        guard let width = Double(self.txtWidth.text ?? ""),
              let length = Double(self.txtLength.text ?? ""),
              let height = Double(self.txtHeight.text ?? ""),
              let weight = Double(self.txtWeight.text ?? ""),
              let originalPrice = Double(self.txtOriginalPrice.txt.text ?? ""),
              let sellingPrice = Double(self.txtSellingPrice.txt.text ?? "")
        else {
            self.lblGoodzDeals.isHidden = true
            return
        }
        
        let halfOriginalPrice = originalPrice / 2
        
        if halfOriginalPrice >= sellingPrice {
            self.lblGoodzDeals.isHidden = self.invoiceURL == nil
            self.isGoodzDeals = !(self.invoiceURL == nil)
        } else {
            self.lblGoodzDeals.isHidden = true
            self.isGoodzDeals = false
        }
    }
    
    // --------------------------------------------
    
    func setTap() {
        self.ivCheckPin.image = .iconUncheckBox
        self.viewSelectPinProduct.addTapGesture {
            
            if self.ivCheckPin.image == .iconUncheckBox {
                self.ivCheckPin.image = .icCheckboxSqr
            } else {
                self.ivCheckPin.image = .iconUncheckBox
            }
        }
        
        self.ivCheckTandC.image = .iconUncheckBox
        self.viewTermCondition.addTapGesture {
            
            self.isAgreeTermCondition = !self.isAgreeTermCondition
            
            if self.ivCheckTandC.image == .iconUncheckBox {
                self.ivCheckTandC.image = .icCheckboxSqr
            } else {
                self.ivCheckTandC.image = .iconUncheckBox
            }
        }
        
        self.viewColor.addTapGesture {
            self.coordinator?.navigateToColor(selectedColor: self.colorSelectedArr ?? [], isMultipleSelection: true, id:  "") { data in
                if let data = data {
                    self.colorSelectedArr =  data//?.first ?? ColorModel(id: "", title: "")
                    
                  ///  self.lblSelectedColor.text = data.map{$0.title ?? ""}.joined(separator: ",")//data?.first?.title ?? ""
                    self.lblSelectedColor.text = data
                        .compactMap { $0.title }
                        .filter { !$0.isEmpty }
                        .joined(separator: ",")
                    
                }
            }
        }
        
        self.viewMaterial.addTapGesture {
            self.coordinator?.navigateToMaterial(selectedMaterial: self.materialSelectedArr ?? [], isMultipleSelection: true, id:  "", completion: {data in
                if let data = data {
                    self.materialSelectedArr = data//?.first ?? ColorModel(id: "", title: "")
                   // self.lblSelectedMaterial.text = data.map{$0.title ?? ""}.joined(separator: ",")//?.first?.title ?? ""
                    self.lblSelectedMaterial.text = data
                        .compactMap { $0.title }
                        .filter { !$0.isEmpty }
                        .joined(separator: ",")
                }
            })
        }
        
        self.lblChange.addTapGesture {
            self.coordinator?.navigateToSelectAddress(addressID: self.address?.addressId ?? "") { address in
                self.setUpAddressData(address)
            }
        }
        
        self.btnInvoiceUpload.addTapGesture {
            self.sellVCUploadBtnType = .invoice
            self.setOpenLibrary() { _,url in
                self.invoiceURL = url
                self.goodzDeals()
            }
        }
        
        self.btnWarrantyUpload.addTapGesture {
            self.sellVCUploadBtnType = .warranty
            self.setOpenLibrary() { _,url in
                self.warrantyURL = url
            }
        }
    }
    
    // --------------------------------------------
    
    func setUpAddressData(_ address: MyAddressModel) {
        self.viewAddAddress.isHidden = true
        self.viewAddress.isHidden = false
        self.address = address
        self.lblAddressUserName.text = address.fullName
        let location = (address.floor ?? "").setComma() + (address.streetAddress ?? "").setComma() + (address.area ?? "").setComma() + (address.city ?? "").setComma()
        self.lblAddressLocation.text = location.trim()
        self.lblAddressLocation.removeLastCommaFromAddress()
        self.lblAddressMobile.text = (address.mobile ?? "").setFormatCountryCode(address.countryCode ?? "+971")
    }
    
    // --------------------------------------------
    
    func checkValidationforUploadImage() {
        if arrMedia.count > 2 {
            notifier.showToast(message: "you can upload to max 10 pictures and videos")
            return
        }
    }
    
    // --------------------------------------------
    
    func setOpenLibrary(completion:@escaping((UIImage,URL?) -> Void)) {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary,.file], vc: self)
        AttachmentHandler.shared.imagePickedBlock = { [self] (img,imgUrl) in
            print(img)
            if self.sellVCUploadBtnType == .invoice {
                self.lblInvoiceRemove.text = imgUrl?.lastPathComponent
                
                self.vwInvoiceRemove.isHidden = false
                self.btnInvoiceUpload.isHidden = true
            } else {
                self.lblWarrantyRemove.text = imgUrl?.lastPathComponent
                self.vwWarrantyRemove.isHidden = false
                self.btnWarrantyUpload.isHidden = true
            }
            completion(img, imgUrl)
        }
        AttachmentHandler.shared.filePickedBlock = { [self] (fileType, url, img) in
            print(url)
            if self.sellVCUploadBtnType == .invoice {
                self.lblInvoiceRemove.text = url.lastPathComponent
                self.vwInvoiceRemove.isHidden = false
                self.btnInvoiceUpload.isHidden = true
            } else {
                self.lblWarrantyRemove.text = url.lastPathComponent
                self.vwWarrantyRemove.isHidden = false
                self.btnWarrantyUpload.isHidden = true
            }
            completion(img ?? UIImage(), url)
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.collectionRegister()
        self.tableRegister()
        self.manageRedirection()
        self.setTap()
        self.apiCalling()
        let gesture  = UILongPressGestureRecognizer(target: self, action: #selector( handleLongPressGesture(_:)))
        clvAddPhoto.addGestureRecognizer(gesture)
    }
    
    //-----------Gesture
    
    @objc func handleLongPressGesture(_ gesture : UILongPressGestureRecognizer){
        
        guard let coll = clvAddPhoto else {
            return
        }
            
        switch gesture.state {
        case .began :
            guard let targertIndexPath  = coll.indexPathForItem(at: gesture.location(in: coll )) else {
                return
            }
            coll.beginInteractiveMovementForItem(at: targertIndexPath)
            break;
        case .changed:
            coll.updateInteractiveMovementTargetPosition(gesture.location(in: coll))
            break;
        case .ended:
            coll.endInteractiveMovement()
            break;
        default : coll.cancelInteractiveMovement()
            break;
        }
    }
    
    // --------------------------------------------
    
    private func manageRedirection() {
        let proUser = !(appUserDefaults.getValue(.isProUser) ?? false)
        self.viewPinProduct.isHidden = proUser
        //self.viewQty.isHidden = false //proUser
        self.sendMsgBackView.isHidden = proUser
        self.negotiateBackView.isHidden = proUser
    }
    
    // --------------------------------------------
    
    private func collectionRegister() {
        self.clvAddPhoto.delegate = self
        self.clvAddPhoto.dataSource = self
        self.clvAddPhoto.registerReusableCell(DocumentCell.self)
        self.clvTypeOfDelivery.delegate = self
        self.clvTypeOfDelivery.dataSource = self
        self.clvTypeOfDelivery.registerReusableCell(DeliveryTypesCell.self)
    }
    
    // --------------------------------------------
    
    private func tableRegister() {
        self.tbvDeliveryMethods.delegate = self
        self.tbvDeliveryMethods.dataSource = self
        self.tbvDeliveryMethods.register(DeliveryMethodViewCell.nib, forCellReuseIdentifier: DeliveryMethodViewCell.reuseIdentifier)
        self.tbvProductInfo.delegate = self
        self.tbvProductInfo.dataSource = self
        self.tbvProductInfo.register(MyAccountCell.nib, forCellReuseIdentifier: MyAccountCell.reuseIdentifier)
    }
    
    // --------------------------------------------
    
    func apiDeliveryMethodCalling() {
        self.dispatchGroup.enter()
        self.viewModel.fetchConditionsData { isDone, defaultAddress in
            self.dispatchGroup.leave()
            if isDone {
                if let defaultAddress = defaultAddress, !defaultAddress.addressID.isEmpty {
                    self.viewAddAddress.isHidden = true
                    self.viewAddress.isHidden = false
                    
                    var new = MyAddressModel() // Initialize new object
                    
                    new.addressId = defaultAddress.addressID
                    new.area = defaultAddress.areaName
                    new.city = defaultAddress.cityName
                    new.mobile = defaultAddress.phoneNumber
                    new.fullName = defaultAddress.fullName
                    new.streetAddress = defaultAddress.streetAddress
                    new.floor = defaultAddress.floor
                    
                    self.address = new
                    if let add = self.address, !(add.addressId ?? "").isEmpty {
                        self.setUpAddressData(add)
                    }
                }
                self.tbvDeliveryMethods.reloadData()
            }
        }
    }
    
    // --------------------------------------------
    
    func apiDeliveryTypeCalling() {
        self.dispatchGroup.enter()
        self.viewModel.fetchDeliveryType { isDone in
            self.dispatchGroup.leave()
            if isDone {
                self.clvTypeOfDelivery.reloadData()
            }
        }
    
    }
    
    func apiEditSellProductDetailsCalling() {
        self.dispatchGroup.enter()
        self.viewModel.editProductDetailsAPI(productID: productID) { isDone in
            self.dispatchGroup.leave()
        }
    }
    
    func apiCalling() {
        self.apiDeliveryTypeCalling()
        self.apiDeliveryMethodCalling()
        isFromEdit ? apiEditSellProductDetailsCalling() : ()
        self.dispatchGroup.notify(queue: .main) { [self] in
            self.setProductDetailsData()
        }
    }
    
    // --------------------------------------------
    
    func setProductDetailsData() {
        
        let model = viewModel.editSellProductDetails
        
        self.txtProductTitle.txt.text = model?.productTitle
        self.txtView.text = model?.description
        self.txtView.checkPlaceholder()
        //self.stepperQTY.value = Double(model?.quantity ?? "1") ?? 1
        self.txtWidth.text = model?.productWidth
        self.txtHeight.text = model?.productHeight
        self.txtWeight.text = model?.productWeight
        self.txtLength.text = model?.productLength
        self.txtOriginalPrice.txt.text = model?.originalPrice
        self.txtSellingPrice.txt.text = model?.sellingPrice
        self.txtEarningPrice.txt.text = model?.earningPrice
        
        
        if model?.isOrderPlaced == "1"{
            txtView.isUserInteractionEnabled = false
            txtProductTitle.isUserInteractionEnabled = false
            tbvProductInfo.isUserInteractionEnabled = false
            txtOriginalPrice.isUserInteractionEnabled = false
            txtSellingPrice.isUserInteractionEnabled = false
            txtEarningPrice.isUserInteractionEnabled = false
            clvTypeOfDelivery.isUserInteractionEnabled = false
            tbvDeliveryMethods.isUserInteractionEnabled = false
            btnInvoiceRemove.isUserInteractionEnabled = false
            btnInvoiceUpload.isUserInteractionEnabled = false
            btnWarrantyUpload.isUserInteractionEnabled = false
            btnWarrantyRemove.isUserInteractionEnabled = false
            txtHeight.isUserInteractionEnabled = false
            txtLength.isUserInteractionEnabled = false
            txtWidth.isUserInteractionEnabled = false
            txtWeight.isUserInteractionEnabled = false
            clvAddPhoto.isUserInteractionEnabled = false
            viewColor.isUserInteractionEnabled = false
            viewMaterial.isUserInteractionEnabled = false
            viewInvoice.isUserInteractionEnabled = false
            viewWarranty.isUserInteractionEnabled = false
            viewAddress.isUserInteractionEnabled = false
            viewPinProduct.isUserInteractionEnabled = false
            viewTermCondition.isUserInteractionEnabled = false
        }
        
        if let invoiceUrl = URL(string: model?.invoice ?? "") {
            self.invoiceURL = invoiceUrl
            self.lblInvoiceRemove.text = invoiceURL?.lastPathComponent
            self.vwInvoiceRemove.isHidden = false
            self.btnInvoiceUpload.isHidden = true
        }
        
        if let warrantyUrl = URL(string: model?.warranty ?? "") {
            self.warrantyURL = warrantyUrl
            self.lblWarrantyRemove.text = warrantyURL?.lastPathComponent
            self.vwWarrantyRemove.isHidden = false
            self.btnWarrantyUpload.isHidden = true
        }
        
        if let productImgs = model?.productImages {
            let sellItemUploadMediaModels = productImgs.map { $0.toSellItemUploadMediaModel() }
            self.arrMedia.append(contentsOf: sellItemUploadMediaModels)
            self.clvAddPhoto.reloadData()
        }
        
        self.arrSelectedDeliveryMethod.removeAll()
        
        for deliveryMethod in (model?.deliveryMethod ?? []) {
            if let data = self.viewModel.arrDeliveryMethods.first(where: { $0.deliveryMethodID == deliveryMethod.id }) {
                self.arrSelectedDeliveryMethod.append(data)
            }
        }
        if  self.arrSelectedDeliveryMethod.count == 0 && self.viewModel.numberOfRows() > 0 {
            self.arrSelectedDeliveryMethod = [self.viewModel.arrDeliveryMethods[0]]
        }
        self.tbvDeliveryMethods.reloadData()
        
        if let index = self.viewModel.arrDeliveryType.firstIndex(where: { $0.id == model?.typeOfDelivery }) {
            self.selectedDeliveryType = index
        }
        self.clvTypeOfDelivery.reloadData()
        
        if let addressData = model?.address {
            self.address = addressData
            self.setUpAddressData(addressData)
        }
        
        self.brand = BrandModel(brandTitle: model?.brand, brandID: model?.brandID, isCustomizationSelected: "")
        self.condition = ConditionModel(conditionTitle: model?.condition, description: nil, conditionID: model?.conditionID)
        
        self.colorSelectedArr = [ColorModel(id: model?.colorID, title: model?.colors)]
        self.lblSelectedColor.text = model?.colors
        
        self.materialSelectedArr = [ColorModel(id: model?.materialID, title: model?.material)]
        self.lblSelectedMaterial.text = model?.material
        
        self.categoryMain = CategoryMainModel(categoriesMainTitle: model?.category, categoriesMainId: model?.categoryID, categoriesMainImage: nil, isCustomizationSelected: "")
        self.categorySub = CategorySubModel(categoriesSubTitle: model?.subCategory, categoriesSubId: model?.subCategoryID, categoriesSubImage: nil)
        self.categoryCollection = CategoryCollectionModel(categoryCollectionTitle: model?.subSubCategory, categoryCollectionId: model?.subSubCategoryID, isCustomizationSelected: "")
        
        if isFromEdit {
            self.isAgreeTermCondition = true
            self.ivCheckTandC.image = .icCheckboxSqr
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//
//            })
            self.sellingPriceChanged(self.txtSellingPrice.txt)
           // self.setSlider()
        }
        self.tbvProductInfo.reloadData()
        
    }
    
    func setClearData() {
          
     ///   self.arrMedia = [SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "ivAddPhoto" ),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "" , dymyImg: "imgFront"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "imgBack"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "img34"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "imgDegault"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "imgSide")]
        ///
        self.txtProductTitle.txt.text = ""
        self.txtView.text = ""
        self.txtView.checkPlaceholder()
        
        //self.stepperQTY.value = 1
        self.brand = nil
        self.condition = nil
        self.categoryMain = nil
        self.categorySub = nil
        self.categoryCollection = nil
       
        self.txtHeight.text  = ""
        self.txtLength.text  = ""
        self.txtWidth.text  = ""
        self.txtWeight.text  = ""
        self.colorSelectedArr =  nil
        self.materialSelectedArr = nil
        self.invoiceURL = nil
        self.warrantyURL = nil
        self.address = nil
        self.viewAddAddress.isHidden = false
        self.viewAddress.isHidden = true
        self.selectedDeliveryType = 0
        self.arrSelectedDeliveryMethod = []
        self.ivCheckPin.image = .iconUncheckBox
        self.txtSellingPrice.txt.text = ""
        self.txtOriginalPrice.txt.text  = ""
        self.txtEarningPrice.txt.text  = ""
        
        self.lblSelectedColor.text = ""
        self.lblSelectedMaterial.text = ""
        self.vwInvoiceRemove.isHidden = true
        self.btnInvoiceUpload.isHidden = false
        self.lblInvoiceRemove.text = nil
        
        self.vwWarrantyRemove.isHidden = true
        self.btnWarrantyUpload.isHidden = false
        self.lblWarrantyRemove.text = nil
        self.ivCheckTandC.image = .iconUncheckBox
        self.isAgreeTermCondition = false
        self.lblForYou.text = Labels.forYou
        self.lblRangeAmount.text = ""
        self.rangeSlider.maxValue = 0
        self.rangeSlider.minValue = 0
        self.rangeSlider.selectedMaxValue = 0
        self.rangeSlider.selectedMinValue = 0
        self.tbvProductInfo.reloadData()
        self.tbvDeliveryMethods.reloadData()
        DispatchQueue.main.async{
            self.clvAddPhoto.reloadData()
        }
        
        self.clvTypeOfDelivery.reloadData()
        self.scrollView.layoutIfNeeded()
        self.lblGoodzDeals.isHidden = true
        self.scrollView.scrollsToTop(animated: false)
        self.apiCalling()
        
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    
    @IBAction func quantityAddAction (_ sender : UISwitch ) {
         
        if sender.tag == 0{
            if quantity > 1 {
                quantity -= 1
            }
        }else { // Plush
            quantity += 1
        }
        updateQuantityMethod()
    }
    
    
    @IBAction func quantitySetAddAction (_ sender : UISwitch ) {
        if sender.tag == 0{
            if quantitySet > 1 {
                quantitySet -= 1
            }
        }else { // Plush
            quantitySet += 1
        }
        updateQuantityMethod()
    }
    
    func updateQuantityMethod(){
        
        self.lblq1.text = "\(quantity)"
        self.lblq2.text = "\(quantitySet)"
        if self.seletedQunatityIndex == 0 {
            self.lblResult.text = "You have \(quantity) item for sale."
        } else {
            self.lblResult.text = "You have \(quantity*quantitySet) items for sale in total (\(quantity) x \(quantitySet))."
        }
        
    }
    
    
    @IBAction func quantityAction (_ sender : UISwitch ) {
        
        self.coordinator?.qantityViewController(seletedQunatityIndex: seletedQunatityIndex , completion: { [weak self] val in
            guard let self = self else {return}
            self.seletedQunatityIndex = val
            if val == 0 {
                self.viewQty.isHidden = false
                self.numView.isHidden = false
                self.setView.isHidden = true
            } else if val == 1 {
                self.viewQty.isHidden = false
                self.numView.isHidden = false
                self.setView.isHidden = false
            }
            self.updateQuantityMethod()
        })
    }
    
    @IBAction func makeOfferToggel(_ sender : UISwitch ) {
        if sender.isOn {
            offer_toggle =  true
        }else {
            offer_toggle =   false
        }
    }
    
    @IBAction func msgToggel(_ sender : UISwitch ) {
        if sender.isOn {
            receive_chat =  true
        }else {
            receive_chat =   false
        }
    }
    
    @IBAction func actionAddAddress(_ sender: Any) {
        self.coordinator?.navigateToSelectAddress() { address in
            self.setUpAddressData(address)
        }
    }
    
    // --------------------------------------------
    @IBAction func actionTips(_ sender: Any) {
        
        if tipView.isHidden == true {
            
            tipView.isHidden = false
            
            self.hidetitle.text = "Hide"
            self.hideImg.image = UIImage(named: "imgUp")
            
            
        } else {
            
            self.hideImg.image = UIImage(named: "imgDown")
            self.hidetitle.text = "Click to get photo tips"
            tipView.isHidden =  true
            
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionSellNow(_ sender: Any) {
        let deliveryMethods = arrSelectedDeliveryMethod.compactMap{ $0.deliveryMethodID }.joined(separator: ",")
        
        if defaultCover != 1 {
            let coverIndex = self.arrMedia[defaultCover]
            self.arrMedia.remove(at: defaultCover)
            self.arrMedia.insert(coverIndex, at: 1)
        }
        
        self.viewModel.checkSellNowData(productImages: arrMedia, title: self.txtProductTitle.txt.text ?? "", description: self.txtView.text, brand: self.brand?.brandID ?? "", condition: self.condition?.conditionID ?? "", category: self.categoryMain?.categoriesMainId ?? "", productHeight: self.txtHeight.text ?? "", productDepth: self.txtLength.text ?? "", productWidth: self.txtWidth.text ?? "", productWeight: self.txtWeight.text ?? "" , address: address?.addressId ?? "", deliveryMethod: deliveryMethods, brandNewPrice: self.txtOriginalPrice.txt.text ?? "", sellingPrice: self.txtSellingPrice.txt.text ?? "", priceForYou: self.txtEarningPrice.txt.text ?? "", termsAndCondtion: isAgreeTermCondition, quantity: self.quantity) { isDone in
            
           // print("COnt 23 - > " ,arrMedia.count )
            var arr  = arrMedia.filter{$0.dymyImg == nil }
            
            print("COnt 24 - > " ,arr.count )
            
            
           // var arr  = self.arrMedia//.dropFirst()
            
            print("COnt 2 - > " ,arr.count )
            
            
            
            var arrImages = [[String: Any]]()
            
            for val in arr {
                arrImages.append([
                    "product_media_name": val.productMediaName ?? "",
                    "media_type": val.mediaType ?? ""
                ])
            }
            
            let jsonString = arrImages.getJsonString()//arr.map({$0.toDictionary()}) //.getJsonString()
            print(jsonString)
            
            if isDone {
                
                if  self.isFromEdit {
                    let goodzDealsVal = self.isGoodzDeals ? "1" : "0"
                    self.showAlert(title: Labels.goodz, message: Labels.areYouSureYouWantToEditItemsForSell) { [self] in
                        self.viewModel.editSellItemAPI(productID: self.productID,
                                                       productName: self.txtProductTitle.txt.text ?? "",
                                                       description: self.txtView.text,
                                                       conditionId: self.condition?.conditionID ?? "",
                                                       categoriesMainId: self.categoryMain?.categoriesMainId  ?? "",
                                                       categoriesSubId: categorySub?.categoriesSubId ?? "",
                                                       categoriesCollectionId: categoryCollection?.categoryCollectionId ?? "",
                                                       deliveryMethod: deliveryMethods,
                                                       sellingPrice: self.txtSellingPrice.txt.text ?? "",
                                                       brandId: self.brand?.brandID ?? "",
                                                       colorsId: self.colorSelectedArr?.map{$0.id ?? "" }.joined(separator: ",") ?? "",
                                                       materialId: self.materialSelectedArr?.map{$0.id ?? "" }.joined(separator: ",") ?? "",
                                                       productHeight: self.txtHeight.text ?? "",
                                                       productLength: self.txtLength.text ?? "",
                                                       productWidth: self.txtWidth.text ?? "",
                                                       productWeight: self.txtWeight.text ?? "",
                                                       originalPrice: self.txtOriginalPrice.txt.text ?? "",
                                                       earningPrice: self.txtEarningPrice.txt.text ?? "",
                                                       invoice: self.invoiceURL,
                                                       warranty: self.warrantyURL,
                                                       pinProduct: (self.viewSelectPinProduct.isHidden == true) ? "0" : (self.ivCheckPin.image == .icCheckboxSqr ? "1" : "0"),
                                                       typeOfDelivery: viewModel.arrDeliveryType[selectedDeliveryType].id ?? "",
                                                       quantity: self.quantity,
                                                       productImages: jsonString,
                                                       address: self.address?.addressId ?? "",
                                                       is_order_placed: viewModel.editSellProductDetails?.isOrderPlaced ?? "",
                                                       isGoodzDeals: goodzDealsVal ,
                                                       quantity_type:  (self.seletedQunatityIndex ?? 0)+1  ,
                                                       items_per_set  : self.quantitySet ) { status, data in

                            if status {
                                
//                                self.showOKAlert(title: Labels.goodz, message: Labels.sellItemEditedSuccessfully) {
                                    self.coordinator?.popVC()
//                                }
                            }
                        }
                    }
                } else {
                    let goodzDealsVal = self.isGoodzDeals ? "1" : "0"
                    let qty = self.quantity  // viewQty.isHidden ? 1 : self.stepperQTY.value
                    self.showAlert(title: Labels.goodz, message: Labels.areYouSureYouWantToAddItemsForSell) { [self] in

                        viewModel.sellItemAPI(productName: txtProductTitle.txt.text ?? "",
                                              description: txtView.text,
                                              conditionId: condition?.conditionID ?? "",
                                              categoriesMainId: categoryMain?.categoriesMainId  ?? "",
                                              categoriesSubId: categorySub?.categoriesSubId ?? "",
                                              categoriesCollectionId: categoryCollection?.categoryCollectionId ?? "",
                                              deliveryMethod: deliveryMethods,
                                              sellingPrice: txtSellingPrice.txt.text ?? "",
                                              brandId: brand?.brandID ?? "",
                                              colorsId: colorSelectedArr?.map{$0.id ?? ""}.joined(separator: ",") ?? "",
                                              materialId: materialSelectedArr?.map{$0.id ?? ""}.joined(separator: ",") ?? "",
                                              productHeight: txtHeight.text ?? "",
                                              productLength: txtLength.text ?? "",
                                              productWidth: txtWidth.text ?? "",
                                              productWeight: txtWeight.text ?? "",
                                              originalPrice: txtOriginalPrice.txt.text ?? "",
                                              earningPrice: txtEarningPrice.txt.text ?? "",
                                              invoice: invoiceURL,
                                              warranty: warrantyURL,
                                              pinProduct: (self.viewSelectPinProduct.isHidden == true) ? "0" : (self.ivCheckPin.image == .icCheckboxSqr ? "1" : "0"),
                                              typeOfDelivery: viewModel.arrDeliveryType[selectedDeliveryType].id ?? "",
                                              quantity: self.quantity,
                                              productImages: jsonString,
                                              isGoodzDeals : goodzDealsVal, addressID: self.address?.addressId ?? "" , offer_toggle : offer_toggle , receive_chat : offer_toggle ,
                                              quantity_type:  (self.seletedQunatityIndex ?? 0) + 1  ,
                                              items_per_set  : self.quantitySet ) { status, data in
                            if status {
                                self.scrollView.scrollsToTop(animated: false)
                                self.setClearData()
                                let isDocsSubmitted = UserDefaults.isDocumentsSubmitted
                                if !isDocsSubmitted {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                        self.coordinator?.navigateToDocsPendingVC(fromSellVC: true)
                                    })
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        self.coordinator?.navigateToOrderCompletePopup(storeId: appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID ?? "", productId: data?.first?.productID ?? "", type: .sellAnItem)
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionInvoice(_ sender: Any) {
        self.vwInvoiceRemove.isHidden = false
        self.btnInvoiceUpload.isHidden = true
        self.sellVCUploadBtnType = .invoice
    }
    
    // --------------------------------------------
    
    @IBAction func actionInvoiceRemove(_ sender: Any) {
        self.vwInvoiceRemove.isHidden = true
        self.btnInvoiceUpload.isHidden = false
        self.lblInvoiceRemove.text = nil
        self.invoiceURL = nil
    }
    
    // --------------------------------------------
    
    @IBAction func actionWarranty(_ sender: Any) {
        self.btnWarrantyRemove.isHidden = false
        self.btnWarrantyUpload.isHidden = true
        self.sellVCUploadBtnType = .warranty
    }
    
    // --------------------------------------------
    
    @IBAction func actionWarrantyRemove(_ sender: Any) {
        self.vwWarrantyRemove.isHidden = true
        self.btnWarrantyUpload.isHidden = false
        self.lblWarrantyRemove.text = nil
        self.warrantyURL = nil
    }
    
    // --------------------------------------------
    
    //MARK: - Attributes String
    func setTermsAndConditionAttributedText() {
        
        let sellItemTermsConditionDesc = Labels.sellItemAcceptedTermsAndCondition
        
        let attReg: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.themeGray, .font: FUNCTION().getFont(for: .regular, size: FontSize.size14)]
        let attLink: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.themeBlack, .font: FUNCTION().getFont(for: .medium, size: FontSize.size14)]
        let term1String = NSMutableAttributedString(string: sellItemTermsConditionDesc, attributes: attReg)
        let term2String = NSAttributedString(string: " " + Labels.t_and_c, attributes: attLink)
        term1String.append(term2String)
        self.lblTermCondition.attributedText = term1String
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        self.lblTermCondition.isUserInteractionEnabled = true
        self.lblTermCondition.addGestureRecognizer(tapAction)
    }
    
    @objc private func tapLabel(gesture: UITapGestureRecognizer) {
        
        if gesture.didTapAttributedTextInLabel(label: lblTermCondition, targetText: Labels.t_and_c) {
            print("Terms of service")
            self.coordinator?.navigateToWebView(id: 5) //Terms And Condition = 5
        }
    }
}

// --------------------------------------------
//MARK: - UITextFieldDelegate
// --------------------------------------------

extension SellVC {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range1 = Range(range, in: text) {
            let finaltext = text.replacingCharacters(in: range1, with: string)
            if textField == self.txtProductTitle.txt {
                if textField.text == "" {
                    if string == " " {
                        return false
                    }
                }
                
//                if finaltext.count > TextFieldMaxLenth.productTitleMaxLength.length {
//                    return false
//                }
                
            } else if textField == self.txtHeight ||  textField == self.txtLength || textField == self.txtWidth || textField == self.txtWeight {

                guard let oldText = textField.text,
                          let r = Range(range, in: oldText) else {
                        return true
                    }

                    let newText = oldText.replacingCharacters(in: r, with: string)
                    let isNumeric = newText.isEmpty || (Double(newText) != nil)
                    let numberOfDots = newText.components(separatedBy: ".").count - 1
                    let numberOfDecimalDigits: Int
                    
                    if let dotIndex = newText.firstIndex(of: ".") {
                        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                    } else {
                        numberOfDecimalDigits = 0
                    }

                    return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 8
                
            } else if textField == self.txtOriginalPrice.txt || textField == self.txtSellingPrice.txt || textField == self.txtEarningPrice.txt {
                
                guard let oldText = textField.text,
                          let r = Range(range, in: oldText) else {
                        return true
                    }

                    let newText = oldText.replacingCharacters(in: r, with: string)
                    let isNumeric = newText.isEmpty || (Double(newText) != nil)
                    let numberOfDots = newText.components(separatedBy: ".").count - 1
                    let numberOfDecimalDigits: Int
                    
                    if let dotIndex = newText.firstIndex(of: ".") {
                        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                    } else {
                        numberOfDecimalDigits = 0
                    }
                if textField == self.txtSellingPrice.txt {
                    return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11
                } else if  textField == self.txtEarningPrice.txt {
                     if !(self.txtOriginalPrice.txt.text ?? "").isEmpty {
                        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11 && (((Double(self.txtOriginalPrice.txt.text ?? "0") ?? 0)) >= ((Double(newText) ?? 0) / (1 - self.commision)))
                    } else {
                        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11
                    }
                } else {
//                    if !(self.txtSellingPrice.txt.text ?? "").isEmpty {
//                        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11 && ((Double(self.txtSellingPrice.txt.text ?? "0") ?? 0) >= (Double(newText) ?? 0))
//                    } else  if !(self.txtEarningPrice.txt.text ?? "").isEmpty {
//                        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11 && (((Double(self.txtEarningPrice.txt.text ?? "0") ?? 0)  / (1 - self.commision)) >= (Double(newText) ?? 0))
//                    } else {
                        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11
//                    }
                }
                
            } /*else if textField == self.txtSellingPrice.txt {
                if !(self.txtOriginalPrice.txt.text ?? "").isEmpty {
                    guard let oldText = textField.text,
                          let r = Range(range, in: oldText) else {
                        return true
                    }
                    
                    let newText = oldText.replacingCharacters(in: r, with: string)
                    let isNumeric = newText.isEmpty || (Double(newText) != nil)
                    let numberOfDots = newText.components(separatedBy: ".").count - 1
                    let numberOfDecimalDigits: Int
                    
                    if let dotIndex = newText.firstIndex(of: ".") {
                        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                    } else {
                        numberOfDecimalDigits = 0
                    }
                    
                    return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11 && ((Double(self.txtOriginalPrice.txt.text ?? "0") ?? 0) >= (Double(newText) ?? 0))
                }
            } else if textField == self.txtEarningPrice.txt {
                if !(self.txtOriginalPrice.txt.text ?? "").isEmpty {
                    guard let oldText = textField.text,
                          let r = Range(range, in: oldText) else {
                        return true
                    }
                    
                    let newText = oldText.replacingCharacters(in: r, with: string)
                    let isNumeric = newText.isEmpty || (Double(newText) != nil)
                    let numberOfDots = newText.components(separatedBy: ".").count - 1
                    let numberOfDecimalDigits: Int
                    
                    if let dotIndex = newText.firstIndex(of: ".") {
                        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                    } else {
                        numberOfDecimalDigits = 0
                    }
                    
                    return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11 && (((Double(self.txtOriginalPrice.txt.text ?? "0") ?? 0)) >= ((Double(newText) ?? 0) / (1 - self.commision)))
                }
            }*/
        }
        
        return true
    }
    
    // --------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtProductTitle.txt {
            self.txtView.becomeFirstResponder()
        } else if textField == self.txtHeight {
            self.txtLength.becomeFirstResponder()
        } else if textField == self.txtLength {
            self.txtWidth.becomeFirstResponder()
        } else if textField == self.txtWidth {
            self.txtWeight.becomeFirstResponder()
        } else if textField == self.txtOriginalPrice.txt {
            self.txtSellingPrice.txt.becomeFirstResponder()
        } else if textField == self.txtSellingPrice.txt {
            self.txtEarningPrice.txt.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // --------------------------------------------
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.goodzDeals()
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITextView Delegate Mathods
// --------------------------------------------

extension SellVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.vwTextView.border(borderWidth: 1, borderColor: .themeGreen)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.vwTextView.border(borderWidth: 1, borderColor: .themeBorder)
    }
}


extension SellVC: TextFieldsClearable {
    func clearTextFields() {
        self.setClearData()
    }
}

extension SellVC: appTextFieldDelegate {
    func clearTextFieldClicked() {
        self.setSliderValues()
    }
}

