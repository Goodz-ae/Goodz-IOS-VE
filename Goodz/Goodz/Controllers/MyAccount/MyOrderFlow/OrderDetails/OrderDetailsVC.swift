//
//  OrderDetailsVC.swift
//  Goodz
//
//  Created by Akruti on 11/12/23.
//

import Foundation
import UIKit

class OrderDetailsVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    // shipment details view
    @IBOutlet weak var shipmentDetailsBackView: UIView!
    @IBOutlet weak var shipmentNoBtn: UIButton!
    @IBOutlet weak var downloadShipmentDetailsBtn: UIButton!
    
    // Order Status --
    
    @IBOutlet weak var tableView        :   UITableView!
    @IBOutlet weak var tableViewHeight  :   NSLayoutConstraint!
    
    
     
    
     
    
    // --------------------------------------------
    
     
    // Order Details View
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwOrderDetails: UIView!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblPlacedDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDeliveredDate: UILabel!
    @IBOutlet weak var stkVwOrderStatus: UIStackView!
    @IBOutlet weak var btnTrackOrder: SmallGreenButton!
    // buyer view
    
    @IBOutlet weak var vwBuyer: UIView!
    @IBOutlet weak var lblBuyer: UILabel!
    @IBOutlet weak var lblBuyerName: UILabel!
    // Product List View
    @IBOutlet weak var vwTotalItem: UIView!
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var constHeightOfTable: NSLayoutConstraint!
    @IBOutlet weak var lblTotalItems: UILabel!
    
    // Payment Method View
    @IBOutlet weak var vwPayment: UIView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblMethodName: UILabel!
    
    // Pickup date view
    @IBOutlet weak var vwPickupDate: UIView!
    @IBOutlet weak var lblPickupDate: UILabel!
    @IBOutlet weak var lblPickupDateValue: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    // Pickup time view
    @IBOutlet weak var vwPickupTime: UIView!
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    // Deliver details view
    @IBOutlet weak var vwDeliver: UIView!
    @IBOutlet weak var lblDeliverTo: UILabel!
    @IBOutlet weak var lblCustomName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    
    // Seller view
    @IBOutlet weak var vwSeller: UIView!
    @IBOutlet weak var lblSeller: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
    
    // Summary View
    @IBOutlet weak var vwSummary: UIView!
    @IBOutlet weak var lblOrderSummary: UILabel!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblSubtotalAmount: UILabel!
    @IBOutlet weak var lblCoupan: UILabel!
    @IBOutlet weak var lblCoupanAmount: UILabel!
    @IBOutlet weak var lblVat: UILabel!
    @IBOutlet weak var lblVatAmount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    
    @IBOutlet weak var lblDeliveryTitle: UILabel!
    @IBOutlet weak var lblDeliveryValue: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblWalletValue: UILabel!
    
    //review view
    @IBOutlet weak var vwReview: UIView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var btnAddReview: SmallGreenButton!
    
    @IBOutlet weak var vwButton: UIStackView!
    @IBOutlet weak var btnConfirmReception: ThemeGreenButton!
    @IBOutlet weak var btnReportProblem: ThemeGreenBorderButton!
    
    // vwSummary UserDetials
    
    @IBOutlet weak var vwSummaryUser: UIView!
    @IBOutlet weak var lblOrderIdummary: UILabel!
    @IBOutlet weak var lblOrderIdValueummary: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblDateSummary: UILabel!
    @IBOutlet weak var lblTimeSummary: UILabel!
    @IBOutlet weak var vwEstimate: UIView!
    @IBOutlet weak var lblEstimate: UILabel!
    @IBOutlet weak var btnEstimate: UIButton!
    
    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var lblCouponVal: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var openType : OrderDetialsType = .inTransit
    var orderStatusType : OrderStatus = .inTransit
    var viewModel = OrderDetailsVM()
    var isFromOrderList = false
    var orderId         = ""
    var toStoreID       = ""
    var sallerName      = ""
    
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
        super.viewWillAppear(animated)
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblItems.removeObserver(self, forKeyPath: "contentSize")
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {

        let nib = UINib(nibName: "OrderDetailCell", bundle: nil)
        self.tblItems.register(nib, forCellReuseIdentifier: "OrderDetailCell")
        self.tblItems.delegate = self
        self.tblItems.dataSource = self
        self.tblItems.reloadData()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SellStepView.nib, forCellReuseIdentifier: SellStepView.reuseIdentifier)
        self.tableView.reloadData()
        
        [self.lblPayment, self.lblPickupDate, self.lblPickupTime, self.lblReview, self.lblDeliverTo, self.lblSeller, self.lblOrderSummary, self.lblTotalAmount, self.lblEstimate, self.lblTotal, self.lblBuyer, self.lblTotalItems].forEach {
            $0?.font(font: .semibold, size: .size16)
            $0?.color(color: .themeBlack)
        }
        
        [self.lblMethodName, self.lblStatus].forEach {
            $0?.font(font: .regular, size: .size14)
            $0?.color(color: .themeBlack)
        }
        
        [self.lblPickupDateValue, self.lblDate, self.lblTime, self.lblAddress, self.lblMobile].forEach {
            $0?.font(font: .regular, size: .size14)
            $0?.color(color: .themeGray)
            
        }
        
        [self.vwPayment, self.vwPickupDate, self.vwPickupTime, self.vwDeliver, self.vwSeller, self.vwSummary, self.vwSummaryUser, self.vwEstimate, self.vwOrderDetails, self.vwBuyer, self.vwTotalItem].forEach {
            $0?.cornerRadius(cornerRadius: 4.0)
        }

        [self.lblSubtotal, self.lblSubtotalAmount, self.lblBuyerName].forEach {
            $0?.font(font: .medium, size: .size16)
            $0?.color(color: .themeBlack)
        }
        
        [self.lblCustomName, self.lblSellerName, self.lblDateSummary, self.lblTimeSummary, self.lblOrderIdValueummary].forEach {
            $0?.font(font: .medium, size: .size14)
            $0?.color(color: .themeBlack)
        }
        
        [self.lblCoupon, self.lblCouponVal,self.lblCoupan, self.lblCoupanAmount, self.lblVat, self.lblVatAmount, self.lblDeliveryTitle, self.lblDeliveryValue, self.lblWallet, self.lblWalletValue].forEach {
            $0?.font(font: .regular, size: .size16)
            $0?.color(color: .themeBlack)
        }
        
        [self.lblOrderIdummary, self.lblDateTime, self.lblOrderID, self.lblPlacedDate, self.lblDeliveredDate].forEach {
            $0?.font(font: .regular, size: .size12)
            $0?.color(color: .themeGray)
        }
       
        self.btnEstimate.font(font: .regular, size: .size14)
        self.shipmentNoBtn.font(font: .regular, size: .size14)
        self.btnEstimate.color(color: .themeBlack)
        self.vwPickupDate.isHidden = true
        self.vwPickupTime.isHidden = true
       
        self.setLabels()
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.lblReview.text = Labels.review
        self.lblPayment.text = Labels.paymentMethod
        self.lblOrderSummary.text = Labels.orderSummary
        self.lblSubtotal.text = Labels.subtotal
        self.lblCoupan.text = Labels.discount
        self.lblVat.text = Labels.vAT + "(" + (appDelegate.generalModel?.vat ?? "").setPercentage() + ")"
        self.lblTotal.text = Labels.totalPrice
        self.lblBuyer.text = Labels.buyerName
        self.btnAddReview.setTitle(Labels.addReview, for: .normal)
        self.lblCoupan.text = "Coupon discount price"
        self.lblDeliveryTitle.text = Labels.deliveryCost
        self.lblWallet.text = Labels.goodzWalletCashback
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.shipmentDetailsBackView.isHidden = true
        if isFromOrderList {
            self.viewModel.fetchOrderDetails(orderId: viewModel.orderListResultModel?.orderID ?? "") { [self] isDone in
                if isDone {
                    configData()
                }
            }
            
        }else {
            self.viewModel.fetchSellDetails(sellId: viewModel.sellListResultModel?.sellID ?? "") { [self] isDone in
                if isDone {
                    configData()
                }
            }
        }
    }
    
    func configData() {
        [self.vwSummaryUser, self.vwOrderDetails, self.vwEstimate, self.vwBuyer, self.vwTotalItem, self.vwPayment, self.vwPickupDate, self.vwPickupTime, self.vwDeliver, self.vwSeller, self.vwSummary, self.vwButton].forEach {
            $0?.isHidden = false
        }
        let model = self.viewModel.orderDetails
        self.orderId = (model?.orderID ?? "")
        self.toStoreID = (model?.storeID ?? "")
        self.sallerName = (model?.sallerName ?? "")
        self.lblOrderID.text = Labels.orderId + " : " + orderId
        self.lblPlacedDate.text = Labels.orderPlaced + " : " + (model?.placedDate ?? "").UTCToLocal(inputFormat: DateFormat.apiDateFormateymd, outputFormat: DateFormat.appDateFormateMMddYYY)
        self.lblMethodName.text = model?.paymentOption ?? ""
        self.lblSubtotalAmount.text = kCurrency + " " + (model?.subtotal ?? "")
       
        self.lblVatAmount.text = kCurrency + " " + (model?.vat ?? "")
        self.lblTotalAmount.text = kCurrency + " " + (model?.totalPrice ?? "")
        self.viewModel.arrOrderItemList = model?.items ?? []
        self.lblTotalItems.text = Labels.totalItem + "(\(viewModel.arrOrderItemList.count))"
        self.lblBuyerName.text = model?.sallerName
        self.btnConfirmReception.isHidden = model?.isReceptionConfirmed == "1"
        
        if model?.isReview == "1" || isFromOrderList == false {
            self.vwReview.isHidden = true
        } else {
            if model?.isReceptionConfirmed == "1" {
                self.vwReview.isHidden = false
            } else {
                self.vwReview.isHidden = true
            }
        }
        
        self.lblCustomName.text = model?.username
        self.lblAddress.text = model?.address
        self.lblMobile.text = model?.mobile
        self.lblSellerName.text = model?.sallerName
        self.lblBuyerName.text = model?.buyerName
        if (model?.couponDiscountPrice ?? "").isEmpty || (Int(model?.bundleDiscountPrice ?? "0") ?? 0) <= 0{
            self.lblCoupanAmount.superview?.isHidden = true
        } else {
            self.lblCoupanAmount.text =  "- " + kCurrency + " " + ((model?.couponDiscountPrice ?? "0").isEmpty ? "0" : (model?.couponDiscountPrice ?? "0"))
        }
        if (model?.couponDiscountPrice ?? "").isEmpty || (Int(model?.bundleDiscountPrice ?? "0") ?? 0) <= 0 {
            self.lblCouponVal.superview?.isHidden = true
        } else {
            self.lblCouponVal.text =  "- " + kCurrency + " " + ((model?.bundleDiscountPrice ?? "0").isEmpty ? "0" : (model?.couponDiscountPrice ?? "0"))
            
        }
        self.lblCoupan.text = Labels.kDiscout + "(\(model?.bundleDiscountPercentage ?? "0")%)"
        self.lblStatus.text = Labels.deliveryStatus + ": " + (model?.orderStatus ?? "")
        self.lblDeliveredDate.text = Labels.delivered + ":" + (model?.placedDate ?? "").UTCToLocal(inputFormat: DateFormat.apiDateFormateymd, outputFormat: DateFormat.appDateFormateMMddYYY)
        if (model?.goodzWalletCashback ?? "").isEmpty || (model?.goodzWalletCashback ?? "") == "0" ||  (model?.goodzWalletCashback ?? "") == "0.0" || (model?.goodzWalletCashback ?? "") == "0.00" {
            self.lblWalletValue.superview?.isHidden = true
        } else {
            self.lblWalletValue.text = "- " + kCurrency + " " + ((model?.goodzWalletCashback ?? "0").isEmpty ? "0" : (model?.goodzWalletCashback ?? "0"))
        }
        if (model?.deliveryCost ?? "").isEmpty || (model?.deliveryCost ?? "") == "0" || (model?.deliveryCost ?? "") == "0.0" || (model?.deliveryCost ?? "") == "0.00" {
            self.lblDeliveryValue.superview?.isHidden = true
        } else {
            self.lblDeliveryValue.text = kCurrency + " " + (model?.deliveryCost ?? "0")
        }
        self.lblPickupDateValue.text = model?.pickUpDate//?.UTCToLocal(inputFormat: DateFormat.apiDateFormateymd, outputFormat: DateFormat.appDateFormateMMddYYY)
        self.lblTime.text = model?.pickUpTime
        self.vwPickupDate.isHidden = (model?.pickUpDate ?? "").isEmpty
        self.vwPickupTime.isHidden = (model?.pickUpTime ?? "").isEmpty
        self.tblItems.reloadData()
        self.tblItems.endRefreshing()
        self.orderStatusTypeSet()
        
        if model?.awbNumber != "" && model?.awbNumber != nil {
            self.shipmentDetailsBackView.isHidden = false
            self.shipmentNoBtn.setTitle("Shipment N°: \(model?.awbNumber ?? "")", for: .normal)
            if model?.labelPath != "" && model?.labelPath != nil {
                self.downloadShipmentDetailsBtn.isHidden = false
            } else {
                self.downloadShipmentDetailsBtn.isHidden = true
            }
        } else {
            self.shipmentDetailsBackView.isHidden = true
        }
        
        self.tableView.reloadData()
        setData()
    }
    
    // --------------------------------------------
    
    func orderStatusTypeSet() {
        
        let ordermodel = self.viewModel.orderListResultModel
        let sellmodel = self.viewModel.sellListResultModel
        self.orderStatusType = OrderStatus(rawValue: isFromOrderList ? (ordermodel?.status ?? "") : (sellmodel?.status ?? "")) ?? .inTransit
        if ordermodel?.paymentStatus == "1" || sellmodel?.paymentStatus == "1" {
            switch orderStatusType {
            case .delivery, .orderPlaced, .pickedUp: 
                if isFromOrderList {
                    self.stkVwOrderStatus.isHidden = false
                    self.btnTrackOrder.isHidden = false
                    self.vwBuyer.isHidden = true
                    self.vwSummaryUser.isHidden = true
                    self.vwEstimate.isHidden = true
                } else {
                    self.vwDeliver.isHidden = true
                    self.stkVwOrderStatus.isHidden = false
                    self.vwSeller.isHidden = true
                    self.btnTrackOrder.isHidden = true
                    self.vwSeller.isHidden = true
                    self.vwButton.isHidden = true
                    self.vwSummaryUser.isHidden = true
                    self.vwEstimate.isHidden = true
                
                }
            case .inTransit, .shipped:
                if isFromOrderList {
                    self.vwDeliver.isHidden = true
                    self.stkVwOrderStatus.isHidden = false
                    self.vwSeller.isHidden = true
                    self.vwButton.isHidden = true
                    self.lblDeliveredDate.isHidden = true
                    self.vwBuyer.isHidden = true
                    self.vwSummaryUser.isHidden = true
                    self.vwEstimate.isHidden = true
                } else {
                    self.vwDeliver.isHidden = true
                    self.stkVwOrderStatus.isHidden = false
                    self.vwSeller.isHidden = true
                    self.vwButton.isHidden = true
                    self.btnTrackOrder.isHidden = true
                    self.lblDeliveredDate.isHidden = true
                    self.vwSeller.isHidden = true
                    self.vwDeliver.isHidden = true
                    self.vwSummaryUser.isHidden = true
                    self.vwEstimate.isHidden = true
                }
            }
        }else{
            self.stkVwOrderStatus.isHidden = true
            self.vwEstimate.isHidden = true
            self.vwDeliver.isHidden = true
            self.vwPayment.isHidden = true
            self.vwPickupDate.isHidden = true
            self.vwPickupTime.isHidden = true
            self.vwReview.isHidden = true
            self.vwReview.isHidden = true
            self.vwButton.isHidden = true
            self.vwSummaryUser.isHidden = true
            self.vwBuyer.isHidden = true
            self.vwSeller.isHidden = true
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        var strTitle : String = ""
        switch openType {
        case .deliver:
            strTitle = Labels.orderDetails
        case .inTransit:
            strTitle = Labels.orderDetails
        case .salesDelivered:
            strTitle = Labels.saleDetails
        case .salesInTransit:
            strTitle = Labels.saleDetails
        case .orderSummary:
            strTitle = Labels.orderSummary
        }
        self.appTopView.textTitle = strTitle
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    private func setData() {
        self.btnConfirmReception.setTitle(Labels.confirmReception, for: .normal)
        self.btnReportProblem.setTitle(Labels.reportAProblem, for: .normal)
        btnReportProblem.setTitleColor(.themeGreen, for: .normal)
    }
    
    // --------------------------------------------
    
    func setUp() {
        self.applyStyle()
        self.orderStatusTypeSet()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblItems && keyPath == "contentSize" {
            self.constHeightOfTable.constant = self.tblItems.contentSize.height
        }else if let collectionView = object as? UITableView {
                if collectionView == self.tableView {
                    self.tableViewHeight.constant = self.tableView.contentSize.height
                    view.layoutIfNeeded()
                }
            }
        
        
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnConfirmReceptionTapped(_ sender: Any) {
        self.viewModel.fetch(orderId: orderId) { isDone in
//            if isDone {
//                self.showSimpleAlert(Message: Labels.confirmReceptionSuccessfull)
//            }
            self.apiCalling()
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnReportProblemTapped(_ sender: Any) {
        self.coordinator?.navigateToReport(orderDetailsModel: self.viewModel.orderDetails)
    }
    
    // --------------------------------------------
    
    @IBAction func btnTrackMyOrderTapped(_ sender: Any) {
        self.coordinator?.navigateToOrderTrack(orderID: self.viewModel.orderDetails?.MainOrderId ?? "")
    }
    
    // --------------------------------------------
    
    @IBAction func btnInfoTapped(_ sender: Any) {
    }
    
    // --------------------------------------------
    
    @IBAction func btnAddReviewTapped(_ sender: Any) {
        self.coordinator?.navigateToAddReview(orderID: viewModel.orderListResultModel?.orderID ?? "", toStoreID: toStoreID, saller_name: self.sallerName)
    }
    
    // --------------------------------------------
    
    @IBAction func downlaodShipmentDetailsBtnAction(_ sender: Any) {
        let model = self.viewModel.orderDetails
        let labelPath = model?.labelPath ?? ""
        
        if let fullURL = URL(string: labelPath) {
            self.viewModel.downloadAndSavePDF(from: fullURL) { isDone in
                if isDone {
                    print("Download Successfull")
                    self.showOKAlert(title: "Download Successfull", message: "You can check the downloaded file in your file manager.", okAction: {})
                } else {
                    print("Download Failed")
                    self.showOKAlert(title: "Download Failed", message: "Something was wrong, Please try again later.", okAction: {})
                }
            }
        }
    }
}

// ---------------------------------------------------
// MARK: - UITableView Delegate and Datasource methods
// ---------------------------------------------------



