//
//  HideDeletePopUpVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

class HideDeletePopUpVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var titleText: String = ""
    var titleDescription: String = ""
    var viewModel : ProductDetailVM = ProductDetailVM()
    var chatViewModel : ChatDropDownVM = ChatDropDownVM()
    var storeId: String = ""
    var productId : String = ""
    var isHide : String = ""
    var type : OpenPopup = .delete
    var completion: ((Bool) -> Void)?
    var chatId : String = ""
    var toID : String = ""
    var isBlock : String = ""
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func applyStyle() {
        self.lblTitle.font(font: .semibold, size: .size16)
        self.lblDescription.font(font: .medium, size: .size16)
        self.lblDescription.numberOfLines = 0
        self.lblTitle.text = titleText
        self.lblDescription.text = titleDescription
        switch self.type {
        case .delete, .hide, .chatDelete, .chatReport, .chatBlock:
            self.btnNo.setTitle(Labels.no, for: .normal)
            self.btnYes.setTitle(Labels.yes, for: .normal)
        case .appUpadate:
            self.btnNo.setTitle(Labels.cancel, for: .normal)
            self.btnYes.setTitle(Labels.update, for: .normal)
        case .forceUpdate:
            self.btnNo.setTitle(Labels.exit, for: .normal)
            self.btnYes.setTitle(Labels.update, for: .normal)
        }
    }
    
    // --------------------------------------------
    // MARK: - Action methods
    // --------------------------------------------
    
    @IBAction func btnNoTapped(_ sender: Any) {
        switch self.type {
        case .delete, .hide, .chatDelete, .chatReport, .chatBlock:
            self.dismiss()
        case .appUpadate:
            self.dismiss()
        case .forceUpdate:
            exit(0)
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnYesTApped(_ sender: Any) {
        switch self.type {
        case .delete:
            self.viewModel.deleteItem(productID: self.productId, storeID: self.storeId) { status in
                
                if status {
                    self.completion?(status)
                    self.dismiss()
                    
                }
                
            }
        case .hide:
            self.viewModel.hideItem(productID: self.productId, storeID: self.storeId, isHide: self.isHide) { status in
                
                if status {
                    self.completion?(true)
                    self.dismiss()
                }
                
            }
        case .chatDelete:
            self.chatViewModel.deleteChatAPI(toId: self.toID, chatId: self.chatId) { status in
                if status {
                    self.dismiss()
                    self.coordinator?.popToRootVC()
                }
            }
        case .chatReport:
//            self.chatViewModel.reportUserAPI(toId: self.toID, chatId: self.chatId) { status in
//                if status {
                    self.dismiss()
//                    self.coordinator?.popToRootVC()
            self.coordinator?.showReportPopup(toID: self.toID, chatId: self.chatId)
//                    
//                }
//            }
        case .chatBlock:
            self.chatViewModel.blockUserAPI(toId: self.toID, chatId: self.chatId, isBlock: self.isBlock == "1" ? "0" : "1" ) { status in
                if status {
                    self.dismiss()
                    self.coordinator?.popToRootVC()
                }
            }
        case .appUpadate, .forceUpdate:
            UIApplication.shared.open(URL(string: "https://www.apple.com/in/app-store/")!, options: [:], completionHandler: nil)
        }
        
    }
    
    // --------------------------------------------
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss()
        
    }
}
