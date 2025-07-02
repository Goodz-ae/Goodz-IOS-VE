//
//  OrderCompleteVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class OrderCompleteVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var lblCongrets: UILabel!
    @IBOutlet weak var imgDone: UIImageView!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var btnSeller: ThemeGreenBorderButton!
    @IBOutlet weak var btnTrack: ThemeGreenButton!
    @IBOutlet weak var vwConfirmation: UIStackView!
    @IBOutlet weak var vwComplete: UIStackView!
    @IBOutlet weak var lblTq: UILabel!
    @IBOutlet weak var lblTqDes: UILabel!
    
    @IBOutlet weak var vwBoostButton: UIStackView!
    @IBOutlet weak var btnUpdateProfile: ThemeGreenButton!
    @IBOutlet weak var btnBackToBoost: ThemeGreenButton!
    @IBOutlet weak var vwProuser: UIStackView!
    @IBOutlet weak var lblThankYou: UILabel!
    @IBOutlet weak var lblProuser: UILabel!
    
    @IBOutlet weak var vwSellItem: UIStackView!
    @IBOutlet weak var btnHome: ThemeGreenBorder14Button!
    @IBOutlet weak var btnSell: ThemeGreen14Button!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var type : OrderCompleteType = .completion
    var storeId : String = ""
    var productID : String = ""
    var orderID : String = ""
    var viewModel : TelrPaymentVM = TelrPaymentVM()
    var data : [PaymentModel] = []
    var cartData : [AddOrderModel] = []
    var paymentType :  TelrPaymentType = .boostItem
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblCongrets.font(font: .semibold, size: .size22)
        self.lblCongrets.color(color: .themeBlack)
        self.lblDes.font(font: .regular, size: .size14)
        self.lblDes.color(color: .themeGray)
        
        self.lblTq.font(font: .semibold, size: .size22)
        self.lblTq.color(color: .themeBlack)
        self.lblTqDes.font(font: .regular, size: .size14)
        self.lblTqDes.color(color: .themeBlack)
        
        self.lblThankYou.font(font: .semibold, size: .size22)
        self.lblThankYou.color(color: .themeBlack)
        self.lblProuser.font(font: .regular, size: .size14)
        self.lblProuser.color(color: .themeBlack)
        self.btnBackToBoost.setTitle(Labels.goBackToYourBoost, for: .normal)
        switch type {
        case .confirmation:
            self.lblCongrets.isHidden = false
            self.imgDone.image = .doneCart
            self.vwComplete.isHidden = true
            self.vwConfirmation.isHidden = false
            self.vwProuser.isHidden = true
            self.vwSellItem.isHidden = true
            self.vwBoostButton.isHidden = true
            if let data1 = self.cartData.first {
                    self.viewModel.handlePaymentSuccessAPI(datacart: data1, data: nil) { _, _ in
                }
            }
        case .sellAnItem :
            self.lblCongrets.isHidden = true
            self.imgDone.image = .iconTq
            self.vwComplete.isHidden = false
            self.vwConfirmation.isHidden = true
            self.vwProuser.isHidden = true
            self.vwSellItem.isHidden = false
            self.vwBoostButton.isHidden = true
        case .completion, .boostItem, .boostStore:
            self.lblCongrets.isHidden = true
            self.imgDone.image = .iconTq
            self.vwComplete.isHidden = false
            self.vwConfirmation.isHidden = true
            self.vwProuser.isHidden = true
            self.vwSellItem.isHidden = true
            self.vwBoostButton.isHidden = true
            if type == .boostItem || type == .boostStore {
                self.vwBoostButton.isHidden = false
                if let data1 = self.data.first {
                    self.viewModel.handlePaymentSuccessAPI(datacart: nil, data: data1) { _, _ in
                    }
                }
            } else { }
            
        case .subscription:
            self.lblCongrets.isHidden = true
            self.imgDone.image = .iconTq
            self.vwComplete.isHidden = true
            self.vwConfirmation.isHidden = true
            self.vwProuser.isHidden = false
            self.vwSellItem.isHidden = true
            self.vwBoostButton.isHidden = true
        case .paymentFail:
            self.lblCongrets.isHidden = true
            self.imgDone.image = .failIcon
            self.vwComplete.isHidden = false
            self.lblTq.text = "Payment Fail"
            self.lblTqDes.text = "Please try again"
            self.vwConfirmation.isHidden = true
            self.vwProuser.isHidden = true
            self.vwSellItem.isHidden = true
            self.vwBoostButton.isHidden = true
            if self.paymentType == .boostItem || self.paymentType == .boostStore {
                self.vwBoostButton.isHidden = false
                if let data1 = self.data.first {
                    self.viewModel.handlePaymentCancelAPI(datacart: nil, data: data1) { _, _ in
                    }
                }
            } else if self.paymentType == .cart {
                if let data1 = self.cartData.first {
                    self.viewModel.handlePaymentCancelAPI(datacart: data1, data: nil) { _, _ in
                    }
                }
            }
        }
        
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        switch type {
        case .completion :
            self.appTopView.textTitle = Labels.confirmation
        case .confirmation, .boostItem, .boostStore:
            self.appTopView.textTitle = ""
        case .subscription:
            self.appTopView.textTitle = ""
            self.appTopView.btnBack.isHidden = true
        case .sellAnItem:
            self.appTopView.textTitle = ""
            self.appTopView.btnBack.setImage(UIImage(named: "icon_cross"), for: .normal)
            self.appTopView.backButtonClicked = { [] in
                self.coordinator?.setTabbar(selectedIndex: 0)
            }
        case .paymentFail:
            self.appTopView.textTitle = Labels.goodz
        }
        self.appTopView.backButtonClicked = { [] in
            
            self.coordinator?.setTabbar(selectedIndex: 0)
            
        }
        self.appTopView.btnBack.setImage(UIImage.iconCross, for: .normal)
    }
    
    private func setData() {
        self.lblCongrets.text = Labels.congratsYourOrderIsComplete
        self.lblDes.text =  Labels.youCanNowTrackYourDelivery
        self.btnSeller.setTitle(Labels.checkSeller, for: .normal)
        self.btnTrack.setTitle(Labels.trackMyOrder, for: .normal)
        self.lblTq.text = Labels.thankYou
        if type == .completion || type == .sellAnItem {
            self.lblTqDes.text = Labels.YourProductWillBeReleasedShortly
        } else if type == .boostItem {
            self.lblTqDes.text = Labels.yourProductBoostShortly
        } else if type == .boostStore {
            self.lblTqDes.text = Labels.yourStoreBoostShortly
        } else {}
        self.lblThankYou.text = Labels.thankYou
        self.lblProuser.text = Labels.yourPaymentHasBeenSuccessfullyProcessed
        self.btnSell.setTitle("Add Another Product", for: .normal)
        self.btnHome.setTitle("Back to Home Page", for: .normal)
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnSellerTapped(_ sender: Any) {
        self.coordinator?.navigateToPopularStore(storeId: self.storeId)
    }
    
    // --------------------------------------------
    
    @IBAction func btnTrackTapped(_ sender: Any) {
        
        self.coordinator?.navigateToOrderTrack(orderID: self.orderID)
    }
    
    // --------------------------------------------
    
    @IBAction func btnUpdateProfileTapped(_ sender: Any) {
        
        self.coordinator?.navigateToEditProfile(isPro: true)
        
    }
    
    // --------------------------------------------
    
    @IBAction func btnHomeTapped(_ sender: Any) {
        self.coordinator?.setTabbar(selectedIndex: 0)
    }
    
    // --------------------------------------------
    
    @IBAction func btnSellTapped(_ sender: Any) {
        self.coordinator?.popVC()
//        self.coordinator?.setTabbar(selectedIndex: 2)
    }
    
//    MyAdsVC
    @IBAction func btnBackToMyAdsClicked() {
//        let vc = MyAdsVC.instantiate(storyBoard: .myAccount)
        if let navigationController = navigationController {
            for vc in navigationController.viewControllers {
                if let loginSignUpVC  = vc as? MyAdsVC {
                    navigationController.popToViewController(loginSignUpVC, animated: true)
                }
            }
        }
//        self.coordinator?.popVC(to: vc)
    }
    
    // --------------------------------------------
    
}
