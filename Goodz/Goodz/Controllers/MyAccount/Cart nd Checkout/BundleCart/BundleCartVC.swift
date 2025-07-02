//
//  CartVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class BundleCartVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwPay: UIView!
    @IBOutlet weak var btnPay: ThemeGreenButton!
    
    @IBOutlet weak var btnClearBundle: ThemeGreenButton_14!
    @IBOutlet weak var viewClearBundle: UIView!
    
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var constHeightItemTable: NSLayoutConstraint!
    
    @IBOutlet weak var vwCoupon: UIView!
    
    @IBOutlet weak var vwSummary: UIView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var lblTitlePriceDetails: UILabel!
    @IBOutlet weak var lblTitlePrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitleDiscount: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTitleTotalPrice: UILabel!
    
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    
    @IBOutlet weak var lblVatTitle: UILabel!
    @IBOutlet weak var lblVatPrice: UILabel!
    
    
    @IBOutlet weak var vwDeliveryMethods: UIView!
    @IBOutlet weak var lblChoose: UILabel!
    @IBOutlet weak var btnFirstmethods: UIButton!
    @IBOutlet weak var lblFirstAmount: UILabel!
    
    @IBOutlet weak var btnSecondmethods: UIButton!
    @IBOutlet weak var lblSecondAmount: UILabel!
     
    @IBOutlet weak var btnThirdmethods: UIButton!
    @IBOutlet weak var lblThirdAmount: UILabel!
     
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblDeliveryCost: UILabel!
    
    @IBOutlet weak var vwCashBack: UIView!
    @IBOutlet weak var lblUseCashback: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblBalanceAmount: UILabel!
    @IBOutlet weak var btnCashback: UIButton!
    
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblWalletAmount: UILabel!

    @IBOutlet weak var vwAddAddress: UIStackView!
    @IBOutlet weak var vwAddressDetails: UIStackView!
    @IBOutlet weak var lblAddAddress: UILabel!
    @IBOutlet weak var btnHome: ThemeGreenButton!
    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var lblCouponVal: UILabel!
    @IBOutlet weak var txtCoupon: AppTextField!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : BundleCartVM = BundleCartVM()
    var selectedIndex : Int = -1
    var isAddressShow = false
    var addressID : String = ""
    var deliveryPrice : String = "0"
    var address: MyAddressModel?
    var priceDetails: BundleProductCartModel?
    var bundleId: String = ""
    var storeId: String = ""
    var isSelectedDeliveryMethod : String = "0"
    var deliveryMethodID = "0"
    var isSelectID = "0"
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //notifier.showToast(message: "This feature under development.")
        
        self.deliveryMethod()
        self.tblItems.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblItems.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
   
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblAddAddress.text = Labels.yourDeliveryAddress
        self.btnClearBundle.setTitle(Labels.clearBundle, for: .normal)
        //  self.viewModel.setData()
        self.vwCashBack.isHidden = true
        let nibCart = UINib(nibName: "CartItemCell", bundle: nil)
        self.tblItems.register(nibCart, forCellReuseIdentifier: "CartItemCell")
        self.tblItems.delegate = self
        self.tblItems.dataSource = self

        
        self.tblItems.reloadData()
        self.txtCoupon.txtType = .rightButton
        self.tblItems.cornerRadius(cornerRadius: 4.0)
        self.vwAddress.cornerRadius(cornerRadius: 4.0)
        self.vwSummary.cornerRadius(cornerRadius: 4.0)
        
        [self.lblBalance, self.lblUsername, self.lblBalanceAmount,self.lblTotalPrice].forEach {
            $0.font(font: .medium, size: .size14)
            $0.color(color: .themeBlack)
        }
        
        [
         self.lblTitleTotalPrice,
         self.lblTitlePriceDetails,
         self.lblUseCashback,
         self.lblAddress].forEach {
            $0.font(font: .bold, size: .size14)
            $0.color(color: .themeBlack)
        }
        
        [self.lblAddress1, self.lblAddress2, self.lblMobile].forEach {
            $0.font(font: .regular, size: .size14)
            $0.color(color: .themeGray)
        }
        
        self.btnChange.font(font: .medium, size: .size14)
        self.btnChange.color(color: .themeBlack)
        
        [self.btnFirstmethods,
         self.btnSecondmethods,
         self.btnThirdmethods].forEach {
            $0.font(font: .regular, size: .size14)
            $0.color(color: .themeBlack)
            $0.setImage(.iconCircle, for: .normal)
            $0.setImage(.iconCircleFill, for: .selected)
        }
        
        [self.lblChoose, self.lblTitlePrice, self.lblPrice, self.lblTitleDiscount, self.lblDiscount, self.lblVatPrice, self.lblVatTitle, self.lblThirdAmount, self.lblSecondAmount].forEach {
            $0.font(font: .regular, size: .size14)
            $0.color(color: .themeBlack)
        }
        [self.lblFirstAmount, self.lblWallet, self.lblWalletAmount, self.lblDelivery, self.lblDeliveryCost, self.lblCoupon, self.lblCouponVal].forEach {
            $0.font(font: .regular, size: .size14)
            $0.color(color: .themeBlack)
        }
        self.setLabels()
        self.buttonTapped()
        self.btnThirdmethods.isHidden = true
        self.lblThirdAmount.isHidden = true
        self.btnSecondmethods.isHidden = true
        self.lblSecondAmount.isHidden = true
        self.btnFirstmethods.isHidden = true
        self.lblFirstAmount.isHidden = true
        self.vwAddAddress.isHidden = true
        self.vwAddressDetails.isHidden = true
        self.btnHome.isHidden = true
        self.lblCouponVal.superview?.isHidden = true
        self.lblWallet.superview?.isHidden = !self.btnCashback.isSelected
        self.lblTitleDiscount.superview?.isHidden = self.isSelectedDeliveryMethod == "0"
        
        self.txtCoupon.btnApply.addTapGesture {
            if self.txtCoupon.isApplyCoupon {
                self.txtCoupon.txt.text = ""
                self.apiCalling(isUseCashback: self.btnCashback.isSelected ? "1" : "0")
            }else{
                if (self.txtCoupon.txt.text ?? "").isEmpty {
                    notifier.showToast(message: Labels.pleaseEnterCouponCode)
                } else {
                    self.apiCalling(isUseCashback: self.btnCashback.isSelected ? "1" : "0")
                }
            }
            
            
        }
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.lblTitlePriceDetails.text = Labels.priceDetail
        self.lblTitlePrice.text = Labels.subtotal
        self.lblTitleDiscount.text = Labels.deliveryCost
        self.lblWallet.text = Labels.goodzWalletCashback
        self.lblChoose.text = Labels.chooseYourFavoriteOption
        self.lblTitleTotalPrice.text = Labels.totalPrice
        self.lblAddress.text = Labels.address
        self.lblBalance.text = Labels.balance
        self.btnChange.setTitle(Labels.change, for: .normal)
        self.btnHome.setTitle(Labels.continueShopping, for: .normal)
        self.btnCashback.setImage(.switchGray, for: .normal)
        self.btnCashback.setImage(.switchGreen, for: .selected)
        self.txtCoupon.placeholder = Labels.couponCode
        self.lblUseCashback.text = Labels.useMyCashback
        self.vwAddAddress.addTapGesture {
            self.coordinator?.navigateToSelectAddress() { address in
                print(address)
                self.addressID = address.addressId ?? ""
                self.lblUsername.text = address.fullName ?? ""
                self.lblAddress1.text = "\(address.floor ?? ""), \(address.streetAddress ?? ""),"
                self.lblAddress2.text = "\(address.area ?? ""), \(address.city ?? "")"
                self.lblMobile.text = address.countryCode?.count ?? 0 > 0 ? "(\(address.countryCode ?? "")) \(address.mobile ?? "")" : "\(address.mobile ?? "")"
            }
        }
    }
    
    // --------------------------------------------
    
    func setBlankCart(isHide : Bool) {
        self.viewClearBundle.isHidden = isHide
        self.vwDeliveryMethods.isHidden = isHide
        self.vwAddress.isHidden = isHide
        self.vwSummary.isHidden = isHide
        self.vwCashBack.isHidden = isHide
        self.vwCoupon.isHidden = isHide
        self.vwPay.isHidden = isHide
        self.btnHome.isHidden = !isHide
        self.setNoData(scrollView: self.tblItems, noDataType: .productEmptyData)
        self.tblItems.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    // --------------------------------------------
    
    private func apiCalling(isUseCashback : String) {
        var price = "0"

            if let matchingMethod = self.viewModel.arrDeliveryMethods.first(where: { $0.deliveryMethodID == self.isSelectedDeliveryMethod }) {
                price = matchingMethod.price ?? "0"
            } else {
                price = "0"
            }
        
        self.viewModel.fetchData(isUseCashback: isUseCashback, logisticPrice: price, isSelectedDeliveryMethod: self.isSelectID, couponCode: self.txtCoupon.txt.text ?? "", storeID: storeId) { isDone in
            if isDone {
                if let data = self.viewModel.arrBundleProducts.first {
                    if self.viewModel.numberOfRows() == 0 {
                        self.setBlankCart(isHide: true)
                    } else {
                        self.setData(data: data)
                    }
                    if let cpPrice = Double(data.couponPrice ?? ""), cpPrice > 0 {
                        self.txtCoupon.isApplyCoupon = self.txtCoupon.txt.text != ""
                    }else{
                        self.txtCoupon.txt.text = ""
                        self.txtCoupon.isApplyCoupon = self.txtCoupon.txt.text != ""
                    }
                    if data.isOfferSend == Status.one.rawValue {
                        
                    }else{
                        
                    }
                }
            } else {
                self.setBlankCart(isHide: true)
            }
            self.tblItems.reloadData()
        }
    }
    
    // --------------------------------------------
    
    func deliveryMethod() {
        self.viewModel.fetchConditionsData(bundleId: self.bundleId) { status in
            if status {
                self.apiCalling(isUseCashback: self.btnCashback.isSelected ? "1" : "0")
                self.setDeliveryMethods()
            }
        }
    }
    
    func setDeliveryMethods() {
        let arr = self.viewModel.arrDeliveryMethods
        if arr.count == 3 {
            let p1Double: Double = (arr[0].price)?.toDouble() ?? 0
            let p2Double: Double = (arr[1].price)?.toDouble() ?? 0
            let p3Double: Double = (arr[2].price)?.toDouble() ?? 0
            
            let p1 = (p1Double == 0 ? Labels.free : (kCurrency +  p1Double.customString))
            let p2 = (p2Double == 0 ? Labels.free : (kCurrency +  p2Double.customString))
            let p3 = (p3Double == 0 ? Labels.free : (kCurrency +  p3Double.customString))
            
            self.btnThirdmethods.isHidden = false
            self.lblThirdAmount.isHidden = false
            self.btnSecondmethods.isHidden = false
            self.lblSecondAmount.isHidden = false
            self.btnFirstmethods.isHidden = false
            self.lblFirstAmount.isHidden = false
            
            self.btnFirstmethods.setTitle(appLANG.retrive(label: arr[0].title ?? ""), for: .normal)
            self.lblFirstAmount.text = p1
            
            self.btnSecondmethods.setTitle(appLANG.retrive(label: arr[1].title ?? ""), for: .normal)
            self.lblSecondAmount.text = p2
            
            self.btnThirdmethods.setTitle(appLANG.retrive(label: arr[2].title ?? ""), for: .normal)
            self.lblThirdAmount.text = p3
            
        } else if arr.count == 2 {
            let p1Double: Double = (arr[0].price)?.toDouble() ?? 0
            let p2Double: Double = (arr[1].price)?.toDouble() ?? 0
            
            let p1 = (p1Double == 0 ? Labels.free : (kCurrency +  p1Double.customString))
            let p2 = (p2Double == 0 ? Labels.free : (kCurrency +  p2Double.customString))
            
            self.btnThirdmethods.isHidden = true
            self.lblThirdAmount.isHidden = true
            self.btnSecondmethods.isHidden = false
            self.lblSecondAmount.isHidden = false
            self.btnFirstmethods.isHidden = false
            self.lblFirstAmount.isHidden = false
            
            self.btnFirstmethods.setTitle(arr[0].title, for: .normal)
            self.lblFirstAmount.text = p1
            
            self.btnSecondmethods.setTitle(arr[1].title, for: .normal)
            self.lblSecondAmount.text = p2
            
        } else if arr.count == 1 {
            let p1Double: Double = (arr[0].price)?.toDouble() ?? 0
            
            let p1 = (p1Double == 0 ? Labels.free : (kCurrency +  p1Double.customString))
            
            self.btnFirstmethods.setTitle(arr[0].title, for: .normal)
            self.lblFirstAmount.text = p1
            
            self.btnThirdmethods.isHidden = true
            self.lblThirdAmount.isHidden = true
            self.btnSecondmethods.isHidden = true
            self.lblSecondAmount.isHidden = true
            self.btnFirstmethods.isHidden = false
            self.lblFirstAmount.isHidden = false
            
        } else {
            self.btnThirdmethods.isHidden = true
            self.lblThirdAmount.isHidden = true
            self.btnSecondmethods.isHidden = true
            self.lblSecondAmount.isHidden = true
            self.btnFirstmethods.isHidden = true
            self.lblFirstAmount.isHidden = true
        }
        
        self.btnFirstmethods.isSelected = true
        self.btnSecondmethods.isSelected = false
        self.btnThirdmethods.isSelected = false
        self.isSelectID = "1"
        self.deliveryMethodID =  self.viewModel.arrDeliveryMethods[0].deliveryMethodID ?? ""
        self.isSelectedDeliveryMethod =  self.viewModel.arrDeliveryMethods[0].deliveryMethodID ?? ""
        self.apiCalling(isUseCashback: self.btnCashback.isSelected ? "1" : "0")
    }
    // --------------------------------------------
    
    private func setData(data: BundleProductCartModel) {
        self.viewClearBundle.isHidden = false
        self.btnChange.isHidden = self.isSelectedDeliveryMethod == "2"
        
        self.lblTitleDiscount.superview?.isHidden = self.isSelectedDeliveryMethod == "0"
        self.lblPrice.text = kCurrency + (data.totalPrice ?? "0")
        self.lblDiscount.text = kCurrency + (data.deliveryPrice ?? "0")
        self.lblVatPrice.text = kCurrency + (data.vatPrice ?? "0")
        self.lblTotalPrice.text = kCurrency + (data.totalPriceWithTax ?? "0")
        self.lblVatTitle.text = Labels.vAT + " (" + (data.vatPercentage ?? "0") + "%)"
        self.lblWalletAmount.text = "- " + kCurrency + (data.goodzWalletCashback ?? "0")
        self.lblBalanceAmount.text = kCurrency + (self.btnCashback.isSelected ? (data.remaimingWalletCashbackBalance ?? "0") : (data.walletCashbackBalance ?? "0"))
        self.addressID = address?.addressId ?? ""

        self.vwAddAddress.isHidden = !self.addressID.isEmpty
        self.vwAddressDetails.isHidden = self.addressID.isEmpty
        self.lblUsername.text = address?.fullName ?? ""
        self.lblAddress1.text = "\(address?.floor ?? ""), \(address?.streetAddress ?? ""),"
        self.lblAddress2.text = "\(address?.area ?? ""), \(address?.city ?? "")"
        self.lblMobile.text = address?.countryCode?.count ?? 0 > 0 ? "(\(address?.countryCodes ?? "")) \(address?.mobile ?? "")" : "\(address?.mobile ?? "")"
        self.btnCashback.isHidden = data.totalPrice == data.couponPrice
        self.vwCashBack.isHidden = data.walletCashbackBalance == Status.zero.rawValue
        
        self.lblDelivery.text = Labels.kDiscout + "(" + (data.discountPercentage ?? "0") + "%)"
        self.lblDeliveryCost.text = "-" + kCurrency + (data.discountPrice ?? "0")
        self.setViewAddress(isShow: self.isSelectedDeliveryMethod != "2")
        self.lblCouponVal.superview?.isHidden = 0 >= (Double(data.couponPrice ?? "0") ?? 0)
        self.lblCouponVal.text = "-" + kCurrency + (data.couponPrice ?? "0")
    }

    
    // --------------------------------------------
    
    func setViewAddress(isShow: Bool) {
        self.vwAddress.isHidden = !isShow
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblItems && keyPath == "contentSize" {
            if self.viewModel.numberOfRows() == 0 {
                self.constHeightItemTable.constant = screenHeight - 200
            } else {
                self.constHeightItemTable.constant = self.tblItems.contentSize.height
            }
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.cart
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    func handleDeliveryMethodTap(allButton: [UIButton],button: UIButton, isShowAddress: Bool) {
        self.isSelectID = "1"
        button.isSelected = true
        var selectedButtonIndex: Int = 0
            
            for (index, otherButton) in allButton.enumerated() {
                if otherButton != button {
                    otherButton.isSelected = false
                } else {
                    selectedButtonIndex = index
                }
            }
    
        self.deliveryMethodID =  self.viewModel.arrDeliveryMethods[selectedButtonIndex].deliveryMethodID ?? ""
        self.isSelectedDeliveryMethod =  self.viewModel.arrDeliveryMethods[selectedButtonIndex].deliveryMethodID ?? ""
        self.apiCalling(isUseCashback: self.btnCashback.isSelected ? "1" : "0")
       
    }
    
    // --------------------------------------------
    
    func buttonTapped() {
        let buttons : [UIButton] = [self.btnFirstmethods, self.btnSecondmethods, self.btnThirdmethods]
        self.btnFirstmethods.addTapGesture {
            self.handleDeliveryMethodTap(allButton: buttons, button: self.btnFirstmethods, isShowAddress: true)
        }
        
        self.btnSecondmethods.addTapGesture {
            self.handleDeliveryMethodTap(allButton: buttons, button: self.btnSecondmethods, isShowAddress: true)
        }
        
        self.btnThirdmethods.addTapGesture {
            self.handleDeliveryMethodTap(allButton: buttons, button: self.btnThirdmethods, isShowAddress: true)
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnChangeTapped(_ sender: Any) {
        self.coordinator?.navigateToSelectAddress() { address in
            print(address)
            self.addressID = address.addressId ?? ""
            self.lblUsername.text = address.fullName ?? ""
            self.lblAddress1.text = "\(address.floor ?? ""), \(address.streetAddress ?? ""),"
            self.lblAddress2.text = "\(address.area ?? ""), \(address.city ?? "")"
            self.lblMobile.text = address.countryCode?.count ?? 0 > 0 ? "(\(address.countryCode ?? "")) \(address.mobile ?? "")" : "\(address.mobile ?? "")"
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnHomeTappe(_ sender: Any) {
        self.coordinator?.setTabbar(selectedIndex: 0)
    }
    
    // --------------------------------------------
    
  @IBAction func btnPayTapped(_ sender: Any) {
      if self.viewModel.numberOfRows() < 2 {
          notifier.showToast(message: Labels.ToMakeABuyInBundlePurchaseMoreThanOneProductIsRequired)
      } else {
          if self.isSelectID == "0" {
              notifier.showToast(message: Labels.pleaseSelectDeliveryMethod)
              return
          } else if (self.deliveryMethodID == "1" || self.deliveryMethodID == "3") && self.addressID == "" {
              notifier.showToast(message: Labels.pleaseSelectAddress)
              return
          }
          if let data = self.viewModel.arrBundleProducts.first {
              self.viewModel.orderPay(bundleId : data.bundleID ?? "",
                                      storeId: data.bundleAddedProductList?.first?.storeId ?? "",
                                      addressId: self.addressID,
                                      discountedPrice: data.discountPrice ?? "",
                                      subtotalPrice:  data.totalPrice ?? "",
                                      payablePrice: data.totalPriceWithTax ?? "",
                                      deliveryPrice: self.deliveryPrice,
                                      orderType: "1",
                                      deliveryMethod: self.deliveryMethodID.description,
                                      walletCashbackBalance : data.walletCashbackBalance ?? "",
                                      goodzWalletCashback : data.goodzWalletCashback ?? "0",
                                      remaimingWalletCashbackBalance : data.remaimingWalletCashbackBalance ?? "0",
                                      vatPrice: data.vatPrice ?? "", bundleDiscountPrice: data.discountPrice ?? "",bundleDiscountPercentage: data.discountPercentage ?? "") { isDone, data in
                  if isDone {
                      self.coordinator?.navigateToTelrPayment(storeID: self.storeId,type: .cart, cartData: [data])
                      //self.coordinator?.navigateToOrderCompletePopup(orderID : data.orderID ?? "",storeId: self.storeId, productId: "", type: .confirmation)
                  }
              }
          }
      }
    }
    
    @IBAction func btnCashBackTapped(_ sender: Any) {
        self.btnCashback.isSelected.toggle()
        self.lblWallet.superview?.isHidden = !self.btnCashback.isSelected
        self.apiCalling(isUseCashback: self.btnCashback.isSelected ? "1" : "0")
    }
    
    @IBAction func btnClearBundleClicked() {
        self.viewModel.clearBundle(bundleId: bundleId) { isDone in
            if isDone {
                //let vc = BundleProductListVC.instantiate(storyBoard: .home)
                self.coordinator?.popVC()
                self.coordinator?.popVC()
            }
        }
    }
}

// --------------------------------------------
// MARK: - UItableView Delegate And DataSource
// --------------------------------------------

extension BundleCartVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellCart = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        cellCart.vwDelivery.isHidden = true
        let data = self.viewModel.setCollectionCategories(row: indexPath.row)
        cellCart.setBundleProductCart(data: data)
        cellCart.btnCross.isHidden = true
        cellCart.btnCross.addTapGesture {
            self.viewModel.addRemoveBundle(productId: data.productID ?? "", isAdd: "0") { isDone, error in
                if isDone {
                    self.apiCalling(isUseCashback: self.btnCashback.isSelected ? "1" : "0")
                }else if error != "" {
                    notifier.showToast(message: appLANG.retrive(label: error))
                }
            }
        }
        cellCart.imgProduct.addTapGesture {
            self.coordinator?.navigateToProductDetail(productId: data.productID ?? "", type: .goodsDefault)
        }
        
        cellCart.vwProduct.addTapGesture {
            self.coordinator?.navigateToProductDetail(productId: data.productID ?? "", type: .goodsDefault)
        }
        
        return cellCart
        
    }
    
    // --------------------------------------------
    
}
