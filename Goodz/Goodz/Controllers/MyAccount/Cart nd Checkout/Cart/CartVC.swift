//
//  CartVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class CartVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var lblAddressText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwPay: UIView!
    @IBOutlet weak var btnPay: ThemeGreenButton!
    
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var constHeightItemTable: NSLayoutConstraint!
    
    @IBOutlet weak var tblDelivery: UITableView!
    
    @IBOutlet weak var vwCoupon: UIView!
    @IBOutlet weak var txtCoupon: AppTextField!
    
    @IBOutlet weak var vwSummary: UIView!
    @IBOutlet weak var lblOrderSummary: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblSubTotalAmount: UILabel!
    @IBOutlet weak var lblVat: UILabel!
    @IBOutlet weak var lblVatAmount: UILabel!
    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var lblCouponAmount: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalPriceAmount: UILabel!
    
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    
    @IBOutlet weak var vwPayment: UIView!
    @IBOutlet weak var tblPayment: UITableView!
    @IBOutlet weak var constHeightPaymentTable: NSLayoutConstraint!
    @IBOutlet weak var lblPayment: UILabel!
    
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblWallwtAmount: UILabel!
    
    @IBOutlet weak var vwCashback: UIView!
    @IBOutlet weak var lblCashback: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblBalanceAmount: UILabel!
    @IBOutlet weak var btnCashback: UIButton!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblDeliveryPrice: UILabel!
    
    @IBOutlet weak var vwAddAddress: UIStackView!
    @IBOutlet weak var vwAddressDetails: UIStackView!
    @IBOutlet weak var lblAddAddress: UILabel!

    @IBOutlet weak var btnHome: ThemeGreenButton!
    
    @IBOutlet weak var vwChoose: UIView!
    @IBOutlet weak var vwDelivery: UIStackView!
    @IBOutlet weak var lblChoose: UILabel!
    @IBOutlet weak var btnCollectionSeller: UIButton!
    @IBOutlet weak var lblFree: UILabel!
    @IBOutlet weak var btnPickUp: UIButton!
    @IBOutlet weak var lblDeliveryHome: UILabel!
    @IBOutlet weak var btnAssembly: UIButton!
    @IBOutlet weak var lblAssembly: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : CartVM = CartVM()
    var selectedIndex : Int = -1
    var isAddressShow = false
    var addressID : String = ""
    var deliveryPrice : String = ""
    var productDetails : ProductDetailsModel?
    var isSelectDelivery : Bool = false
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.apiCalling()
        self.tblItems.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblPayment.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblItems.removeObserver(self, forKeyPath: "contentSize")
        self.tblPayment.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblAddAddress.text = Labels.yourDeliveryAddress

        self.vwPayment.isHidden = true
        self.viewModel.setData()
        let nibCart = UINib(nibName: "CartItemCell", bundle: nil)
        self.tblItems.register(nibCart, forCellReuseIdentifier: "CartItemCell")
        self.tblItems.delegate = self
        self.tblItems.dataSource = self
        
        let nib = UINib(nibName: "PaymentOptionCell", bundle: nil)
        self.tblPayment.register(nib, forCellReuseIdentifier: "PaymentOptionCell")
        self.tblPayment.delegate = self
        self.tblPayment.dataSource = self
        
        self.tblItems.reloadData()
        self.tblPayment.reloadData()
        
        self.tblItems.cornerRadius(cornerRadius: 4.0)
        self.tblPayment.cornerRadius(cornerRadius: 4.0)
        self.vwCoupon.cornerRadius(cornerRadius: 4.0)
        self.vwAddress.cornerRadius(cornerRadius: 4.0)
        self.vwSummary.cornerRadius(cornerRadius: 4.0)
        self.vwPayment.cornerRadius(cornerRadius: 4.0)
        self.vwChoose.cornerRadius(cornerRadius: 4.0)
        
        self.lblUsername.font(font: .medium, size: .size14)
        self.lblUsername.color(color: .themeBlack)
        
        self.btnChange.font(font: .medium, size: .size16)
        self.btnChange.color(color: .themeBlack)

        self.vwAddAddress.isHidden = true
        self.vwAddressDetails.isHidden = true
        
        self.txtCoupon.txtType = .rightButton
        
        [self.lblOrderSummary,
         self.lblAddress,
         self.lblTotalPrice,
         self.lblCashback,
         self.lblPayment].forEach {
            $0.font(font: .semibold, size: .size16)
            $0.color(color: .themeBlack)
        }
        
        [self.lblSubTotal,
         self.lblSubTotalAmount].forEach {
            $0.font(font: .medium, size: .size16)
            $0.color(color: .themeBlack)
        }
        
        [self.lblVat,
         self.lblVatAmount,
         self.lblCoupon,
         self.lblCouponAmount,
         self.lblBalance,
         self.lblBalanceAmount,
         self.lblWallet,
         self.lblWallwtAmount].forEach {
            $0.font(font: .regular, size: .size16)
            $0.color(color: .themeBlack)
        }

        [self.lblAddress1,
         self.lblAddress2,
         self.lblMobile].forEach {
            $0.font(font: .regular, size: .size14)
            $0.color(color: .themeGray)
        }
        
        self.txtCoupon.btnApply.addTapGesture {
            if self.txtCoupon.isApplyCoupon {
                self.txtCoupon.txt.text = ""
                self.apiCalling(couponCode: "")
            }else{
                if (self.txtCoupon.txt.text ?? "").isEmpty {
                    notifier.showToast(message: Labels.pleaseEnterCouponCode)
                } else {
                    self.apiCalling(couponCode: self.txtCoupon.txt.text ?? "")
                }
            }
        }
        
        self.btnCashback.setImage(.switchGray, for: .normal)
        self.btnCashback.setImage(.switchGreen, for: .selected)
        
        self.hideView(isHide: true)
        self.tblItems.isScrollEnabled = false
        self.tblPayment.isScrollEnabled = false
        self.btnCashback.isSelected = false
        self.vwCashback.isHidden = true
        self.lblWallet.superview?.isHidden = !self.btnCashback.isSelected
        self.lblCoupon.superview?.isHidden = true
        self.setViewAddress(isShow: false)
        self.btnHome.isHidden = true
        
        self.lblChoose.font(font: .medium, size: .size14)
        self.lblChoose.color(color: .themeBlack)
        
        self.lblFree.font(font: .regular, size: .size14)
        self.lblFree.color(color: .themeBlack)
        
        self.lblDeliveryHome.font(font: .regular, size: .size14)
        self.lblDeliveryHome.color(color: .themeBlack)
        
        self.lblAssembly.font(font: .regular, size: .size14)
        self.lblAssembly.color(color: .themeBlack)
        
        self.btnPickUp.font(font: .regular, size: .size14)
        self.btnPickUp.color(color: .themeBlack)
        
        self.btnCollectionSeller.font(font: .regular, size: .size14)
        self.btnCollectionSeller.color(color: .themeBlack)
        
        self.btnAssembly.font(font: .regular, size: .size14)
        self.btnAssembly.color(color: .themeBlack)
        
        self.btnAssembly.setImage(.iconCircle, for: .normal)
        self.btnAssembly.setImage(.iconCircleFill, for: .selected)
        
        self.btnCollectionSeller.setImage(.iconCircle, for: .normal)
        self.btnCollectionSeller.setImage(.iconCircleFill, for: .selected)
        
        self.btnPickUp.setImage(.iconCircle, for: .normal)
        self.btnPickUp.setImage(.iconCircleFill, for: .selected)
        
        self.btnPickUp.superview?.isHidden = true
        self.btnAssembly.superview?.isHidden = true
        self.btnCollectionSeller.superview?.isHidden = true
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.lblPayment.text = Labels.payment
        self.txtCoupon.placeholder = Labels.couponCode
        self.lblOrderSummary.text = Labels.orderSummary
        self.lblSubTotal.text = Labels.subtotal
        self.lblVat.text = Labels.vAT + "(" + (appDelegate.generalModel?.vat ?? "").setPercentage() + ")"
        self.btnHome.setTitle(Labels.continueShopping, for: .normal)
        self.lblTotalPrice.text = Labels.totalPrice
        self.lblCashback.text = Labels.useMyCashback
        self.lblBalance.text = Labels.balance
        self.lblDelivery.text = Labels.deliveryCost
        self.lblWallet.text = Labels.goodzWalletCashback
        self.txtCoupon.placeholder = Labels.couponCode
        self.lblOrderSummary.text = Labels.orderSummary
        self.lblSubTotal.text = Labels.subtotal
        self.lblAddress.text = Labels.address
        self.lblVat.text = Labels.vAT + "(" + (appDelegate.generalModel?.vat ?? "").setPercentage() + ")"
        self.lblTotalPrice.text = Labels.totalPrice
        self.lblChoose.text = Labels.chooseYourFavoriteOption
        
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
    
    func apiCalling(couponCode : String = "", deviceId: String = "") {
        self.viewModel.fetchCart(couponCode: couponCode, deviceId: deviceId, isUseCashback: self.btnCashback.isSelected ? "1" :  "0") { isDone in
            
            if isDone {
                if let error = self.viewModel.dataCart?.couponAppliedMessage, !error.isEmpty {
                    notifier.showToast(message: appLANG.retrive(label: error))
                }
                if self.viewModel.dataCart?.products?.count ?? 0 == 0 {
                    self.hideView(isHide: true)
                    self.vwAddress.isHidden = true
                }
                if let data =  self.viewModel.dataCart {
                    self.setData(data: data)
                    self.hideView(isHide: false)
                }
                if let cpPrice = Double(self.viewModel.dataCart?.couponPrice ?? ""), cpPrice > 0 {
                    self.txtCoupon.isApplyCoupon = self.txtCoupon.txt.text != ""
                }else{
                    self.txtCoupon.txt.text = ""
                    self.txtCoupon.isApplyCoupon = self.txtCoupon.txt.text != ""
                }
                self.tblItems.reloadData()
            } else {
                if let error = self.viewModel.dataCart?.couponAppliedMessage {
                    notifier.showToast(message: appLANG.retrive(label: error))
                }
                self.hideView(isHide: true)
                self.vwAddress.isHidden = true
                self.tblItems.reloadData()
            }
           
        }
    }
    
    func hideView(isHide : Bool) {
        /// set not data view
        self.btnPay.isHidden = isHide
        self.vwPay.isHidden = isHide
        self.vwCoupon.isHidden = isHide
        self.vwSummary.isHidden = isHide
        self.btnHome.isHidden = !isHide
        self.vwPay.isHidden = isHide
        
        if isHide {
            self.vwCashback.isHidden = true
            self.setNoData(scrollView: self.tblItems, noDataType: .productEmptyData)
            self.tblItems.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
    }
    // --------------------------------------------
    
    private func setData(data: CartModel) {
        self.lblWallet.superview?.isHidden = !self.btnCashback.isSelected
        self.lblVatAmount.text = kCurrency + data.vatPrice
        if data.couponPrice.isEmpty || data.couponPrice == "0" || data.couponPrice == "0.0" || data.couponPrice == "0.00" {
            self.lblCoupon.superview?.isHidden = true
        } else {
            self.lblCoupon.superview?.isHidden = false
            self.lblCouponAmount.text = "-" + kCurrency + data.couponPrice
        }
        
        self.lblDelivery.superview?.isHidden = !((Int(data.deliveryPrice) ?? 0) > 0)
        
        self.lblSubTotalAmount.text = kCurrency + data.subtotal
        
        self.lblTotalPriceAmount.text = kCurrency + data.totalPrice
        self.lblWallwtAmount.text = "-" + kCurrency + data.goodzWalletCashback
        self.addressID = data.address?.first?.addressId ?? ""
        
        self.vwAddAddress.isHidden = !self.addressID.isEmpty
        self.vwAddressDetails.isHidden = self.addressID.isEmpty
        self.lblBalanceAmount.text = kCurrency + (self.btnCashback.isSelected ? data.remaimingWalletCashbackBalance : data.walletCashbackBalance)
        self.setViewAddress(isShow: data.products?.first?.selectedDeliveryMethodsID != "2")
        self.lblUsername.text = data.address?.first?.fullName ?? ""
        self.lblAddress1.text = "\(data.address?.first?.floor ?? ""), \(data.address?.first?.streetAddress ?? ""),"
        self.lblAddress2.text = "\(data.address?.first?.area ?? ""), \(data.address?.first?.city ?? "")"
        self.lblMobile.text = "(\(data.address?.first?.countryCodes ?? "")) \(data.address?.first?.mobile ?? "")"
        self.lblDeliveryPrice.text = kCurrency + data.deliveryPrice
        self.deliveryPrice = data.products?.first?.deliveryTypeList?.filter{ $0.deliveryMethodID == "1" }.first?.price ?? ""
        self.btnChange.isHidden = data.products?.first?.selectedDeliveryMethodsID == "2"
        if let id = data.products?.first?.selectedDeliveryMethodsID {
            if id.isEmpty || (Int(id) ?? 0) <= 0 {
                self.isSelectDelivery = false
            } else {
                self.isSelectDelivery = true
            }
        } else {
            self.isSelectDelivery = false
        }
        
            self.btnCashback.isHidden = data.subtotal.toDouble() == data.couponPrice.toDouble()
       
            self.vwCashback.isHidden = data.walletCashbackBalance == "0"
        
        let cartData = data.products ?? []
        print("Cart Data is:", cartData[0])
        if let methods = cartData[0].deliveryTypeList {
            for index in methods {
                let priceDouble: Double = (index.price)?.toDouble() ?? 0
                    
                let price = priceDouble == 0 ? Labels.free : "+ " + kCurrency + priceDouble.customString
                if index.deliveryMethodID == "1" {
                    self.btnCollectionSeller.setTitle(appLANG.retrive(label: index.title ?? ""), for: .normal)
                    self.lblFree.text = price
                    self.btnCollectionSeller.superview?.isHidden = false
                } else if index.deliveryMethodID == "2" {
                    self.btnPickUp.setTitle(appLANG.retrive(label: index.title ?? ""), for: .normal)
                    self.lblDeliveryHome.text = price
                    self.btnPickUp.superview?.isHidden = false
                } else if index.deliveryMethodID == "3" {
                    self.btnAssembly.setTitle(appLANG.retrive(label: index.title ?? ""), for: .normal)
                    self.lblAssembly.text = price
                    self.btnAssembly.superview?.isHidden = false
                }
            }
        }
        self.btnPickUp.isSelected = cartData[0].selectedDeliveryMethodsID == Status.two.rawValue
        self.btnCollectionSeller.isSelected = cartData[0].selectedDeliveryMethodsID == Status.one.rawValue
        self.btnAssembly.isSelected = cartData[0].selectedDeliveryMethodsID == Status.three.rawValue
        
        self.btnPickUp.addTarget(self, action: #selector(pickUpAction), for: .touchUpInside)
        self.btnCollectionSeller.addTarget(self, action: #selector(collectionSellerAction), for: .touchUpInside)
        self.btnAssembly.addTarget(self, action: #selector(assemblyAction), for: .touchUpInside)
    }
    
    // --------------------------------------------
    
    func setViewAddress(isShow: Bool) {
        self.vwAddress.isHidden = !isShow
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblItems && keyPath == "contentSize" {
            
            if self.viewModel.dataCart?.products?.count ?? 0 > 0 {
                self.constHeightItemTable.constant = self.tblItems.contentSize.height
            } else {
                self.constHeightItemTable.constant = screenHeight - 200
            }
        }
        if let obj2 = object as? UITableView,
           obj2 == self.tblPayment && keyPath == "contentSize" {
            self.constHeightPaymentTable.constant = self.tblPayment.contentSize.height
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
        self.setLabels()
        self.setTopViewAction()
        self.setViewAddress(isShow: false)
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
    
    
    @IBAction func btnHomeTapped(_ sender: Any) {
        self.coordinator?.setTabbar(selectedIndex: 0)
    }
    
    // --------------------------------------------
    
    @IBAction func btnPayTapped(_ sender: Any) {
        if !self.isSelectDelivery  {
            notifier.showToast(message: Labels.pleaseSelectDeliveryMethod)
        } else if self.addressID == "" {
            notifier.showToast(message: Labels.pleaseSelectAddress)
        } else {
            let _ = self.tblPayment.dequeueReusableCell(withIdentifier: "PaymentOptionCell") as! PaymentOptionCell
                self.viewModel.orderPay(productId : self.viewModel.dataCart?.products?.first?.productID ?? "",
                                        couponCode: self.txtCoupon.txt.text ?? "",
                                        addressId: self.addressID,
                                        vat: self.viewModel.dataCart?.vatPrice ?? "",
                                        discountedPrice: self.viewModel.dataCart?.couponPrice ?? "",
                                        subtotalPrice: self.viewModel.dataCart?.subtotal ?? "",
                                        payablePrice: self.viewModel.dataCart?.totalPrice ?? "",
                                        deliveryPrice: self.deliveryPrice,
                                        orderType: "0",
                                        deliveryMethod: self.viewModel.dataCart?.products?.first?.selectedDeliveryMethodsID ?? "",
                                        walletCashbackBalance: self.viewModel.dataCart?.walletCashbackBalance ?? "",
                                        goodzWalletCashback: self.viewModel.dataCart?.goodzWalletCashback ?? "",
                                        remaimingWalletCashbackBalance: self.viewModel.dataCart?.remaimingWalletCashbackBalance ?? "") { isDone, data in
                    if isDone {
                        print(data)
                        self.coordinator?.navigateToTelrPayment(type: .cart, cartData: [data])
                        //self.coordinator?.navigateToOrderCompletePopup(orderID : data.orderID ?? "",storeId: data.storeID ?? "", productId: "", type: .confirmation)
                    }
                }
        }
    }
    
    // --------------------------------------------
    @IBAction func btnCashbackTapped(_ sender: Any) {
        self.btnCashback.isSelected.toggle()
        self.apiCalling(couponCode: self.txtCoupon.txt.text ?? "")
    }
    
    // --------------------------------------------
    // MARK: - Delivery Method Actions
    
    @objc func pickUpAction() {
        if let data = self.viewModel.dataCart?.products?[0] {
            self.handleDeliveryMethodTap(button: self.btnPickUp, isShowAddress: true, data: data)
        }
    }
    
    @objc func collectionSellerAction() {
        if let data = self.viewModel.dataCart?.products?[0] {
            self.handleDeliveryMethodTap(button: self.btnCollectionSeller, isShowAddress: true, data: data)
        }
    }
    
    @objc func assemblyAction() {
        if let data = self.viewModel.dataCart?.products?[0] {
            self.handleDeliveryMethodTap(button: self.btnAssembly, isShowAddress: true, data: data)
        }
    }
}

// --------------------------------------------
// MARK: - UItableView Delegate And DataSource
// --------------------------------------------

extension CartVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tblPayment ? self.viewModel.setNumberOfPayment() : self.viewModel.setNumberOfItems()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblItems {
            let cellCart = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
            let data = self.viewModel.setRowDataOfItme(row: indexPath.row)
            cellCart.setData(data: data)
            self.deliveryPrice = data.deliveryTypeList?.first { $0.deliveryMethodID == data.selectedDeliveryMethodsID }?.price ?? ""
            cellCart.vwDelivery.isHidden = true
            cellCart.btnCross.addTapGesture {
                self.viewModel.deleteItem(cartId: data.cartID ?? "") { isDone in
                    if isDone {
                        self.apiCalling(couponCode: self.txtCoupon.txt.text ?? "")
                    }
                }
            }
            
            cellCart.vwProduct.addTapGesture {
                self.coordinator?.navigateToProductDetail(productId: data.productID ?? "", type: .goodsDefault)
            }
            
            cellCart.imgProduct.addTapGesture {
                self.coordinator?.navigateToProductDetail(productId: data.productID ?? "", type: .goodsDefault)
            }
            
            return cellCart
        } else {
            let cellPayment = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionCell", for: indexPath) as! PaymentOptionCell
            cellPayment.setData(data: self.viewModel.setRowData(row: indexPath.row))
            cellPayment.btnSelect.addTapGesture {
                DispatchQueue.main.async {
                    self.selectedIndex = indexPath.row
                    self.tblPayment.reloadData()
                }
            }
            if self.selectedIndex == indexPath.row {
                cellPayment.btnSelect.isSelected = true
                cellPayment.vwAccountDetails.isHidden = false
            } else {
                cellPayment.btnSelect.isSelected = false
                cellPayment.vwAccountDetails.isHidden = true
            }
            return cellPayment
        }
    }
    
    // --------------------------------------------
    
    func handleDeliveryMethodTap(button: UIButton, isShowAddress: Bool, data: CartProductModel) {
       // self.setViewAddress(isShow: isShowAddress)
        
        let allButton : [UIButton] = [self.btnPickUp, self.btnAssembly, self.btnCollectionSeller]
        
        let buttonTag = button.tag
        var id: String?
        if buttonTag == 1 {
            id = data.deliveryTypeList?.first { $0.deliveryMethodID == "1" }?.deliveryMethodID
        } else if buttonTag == 2 {
            id = data.deliveryTypeList?.first { $0.deliveryMethodID == "2" }?.deliveryMethodID
        } else if buttonTag == 3{
            id = data.deliveryTypeList?.first { $0.deliveryMethodID == "3" }?.deliveryMethodID
        }
        
        print(data.deliveryTypeList)
        print(title)
        print(id)
        
        self.deliveryPrice = data.deliveryTypeList?.first { $0.title?.trim() == title?.trim() }?.price ?? "0"
        button.isSelected = true
        for otherButton in allButton {
            if otherButton != button {
                otherButton.isSelected = false
            }
        }
        if let deliveryMethodId = id {
            self.viewModel.updateDeliveryMethods(cartId: data.cartID ?? "", deliveryMethodId: deliveryMethodId) { isDone in
                if isDone {
                    self.apiCalling(couponCode: self.txtCoupon.txt.text ?? "")
                    self.isSelectDelivery = true
                }
            }
        }
    }
    
}
