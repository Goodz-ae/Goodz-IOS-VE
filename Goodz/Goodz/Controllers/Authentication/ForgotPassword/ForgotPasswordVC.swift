//
//  ForgotPasswordVC.swift
//  Goodz
//
//  Created by Akruti on 30/11/23.
//

import Foundation
import UIKit

class ForgotPasswordVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var btnSubnit: ThemeGreenButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var appTopView: AppStatusView!
   
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : ForgotPasswordVM = ForgotPasswordVM()
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ForgotPasswordVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.txtEmail.txtType = .normal
        self.txtEmail.imgleft.image = .iconMail
        self.txtEmail.txt.keyboardType = .emailAddress
        
        self.lblTitle.font(font: .semibold, size: .size18)
        self.lblTitle.color(color: .themeBlack)
        
        self.lblDescription.font(font: .regular, size: .size16)
        self.lblDescription.color(color: .themeBlack)
        
        self.btnLogin.font(font: .medium, size: .size16)
        self.btnLogin.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = ""
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblTitle.text = Labels.forgotPasswordQue
        self.lblDescription.text = Labels.enterYourEmailAssociatedWithYourAccount
        self.btnSubnit.setTitle(Labels.submit, for: .normal)
        self.btnLogin.setTitle(Labels.backToLogin, for: .normal)
        self.txtEmail.placeholder = Labels.emailPlaceholder
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
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        let email = self.txtEmail.txt.text ?? ""
        
        self.viewModel.checkLoginData(email: email) { isDone, data  in
            if isDone {
                self.coordinator?.navigateToOTPVarification(userID: data?.first?.userID ?? "", mobile: data?.first?.mobileNo ?? "", email: email, isFrom: .forgotPassword)
            } else {
              
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
}
