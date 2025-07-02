//
//  WithdrawPopupVC.swift
//  Goodz
//
//  Created by Akruti on 12/12/23.
//

import Foundation
import UIKit

class WithdrawPopupVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblEnterAmount: UILabel!
    @IBOutlet weak var txtEnterAmount: AppTextField!
    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var lblAvailableBalanceAmount: UILabel!
    @IBOutlet weak var lblBankDetail: UILabel!
    @IBOutlet weak var lblAccountHoldername: UILabel!
    @IBOutlet weak var lblcardNumber: UILabel!
    @IBOutlet weak var btnWithdraw: SmallGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
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
        DispatchQueue.main.async {
            self.vwMain.cornerRadius(cornerRadius: 4.0)
        }
        
        self.lblTitle.font(font: .semibold, size: .size16)
        self.lblTitle.color(color: .themeBlack)
        
        self.lblEnterAmount.font(font: .medium, size: .size14)
        self.lblEnterAmount.color(color: .themeBlack)
        
        self.txtEnterAmount.txtType = .normalWithoutImage
        self.txtEnterAmount.txt.keyboardType = .numberPad
        
        self.lblAvailableBalance.font(font: .medium, size: .size14)
        self.lblAvailableBalance.color(color: .themeDarkGray)
        
        self.lblAvailableBalanceAmount.font(font: .semibold, size: .size16)
        self.lblAvailableBalanceAmount.color(color: .themeBlack)
        
        self.lblBankDetail.font(font: .medium, size: .size16)
        self.lblBankDetail.color(color: .themeBlack)
        
        self.lblAccountHoldername.font(font: .medium, size: .size14)
        self.lblAccountHoldername.color(color: .themeBlack)
        
        self.lblcardNumber.font(font: .regular, size: .size16)
        self.lblcardNumber.color(color: .themeBlack)
        
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.btnWithdraw.setTitle(Labels.withdraw, for: .normal)
        self.lblTitle.text = Labels.withdrawAmount
        self.lblEnterAmount.text = Labels.enterAmount
        self.txtEnterAmount.placeholder = Labels.enterAmount
        self.lblAvailableBalance.text = Labels.availableBalance + " :"
        self.lblBankDetail.text = Labels.bankDetail
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnCrossTapped(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    // --------------------------------------------
    
    @IBAction func btnWithdrawTapped(_ sender: Any) {
        if self.txtEnterAmount.txt.text!.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterAmount)
        } else {
            self.dismiss(animated: false)
        }
    }
    
    // --------------------------------------------
    
}
