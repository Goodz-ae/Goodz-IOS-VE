//
//  SecurityEmailVC.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
import UIKit

class SecurityEmailVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var btnSend: ThemeGreenButton!
    @IBOutlet weak var btnChange: ThemeGreenBorderButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : SecurityEmailVM = SecurityEmailVM()
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
        print("LoginVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblEmail.font(font: .medium, size: .size14)
        self.lblEmail.color(color: .themeBlack)
        
        self.txtEmail.txtType = .normal
        self.txtEmail.imgleft.image = UIImage.iconMail
        
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblEmail.text = Labels.verifyYourEmailAddress
        self.txtEmail.placeholder = Labels.emailPlaceholder
        self.btnSend.setTitle(Labels.sendConfirmationEmail, for: .normal)
        self.btnChange.setTitle(Labels.changeCurrentEmail, for: .normal)
        self.txtEmail.placeholder = Labels.emailPlaceholder
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.email
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        let email = self.txtEmail.txt.text ?? ""
        if email.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterEmail)
        } else if !Validation.shared.isValidEmail(email) {
            notifier.showToast(message: Labels.pleaseEnterValidEmail)
        } else {
            showAlert(title: "", message: Labels.areYouSureYouWantToChangeCurrentEmail ) {
                self.viewModel.changeCurrentEmailAPI(email: email) { otp,status  in
                    if status {
                        self.coordinator?.navigateToOTPVarification(otp: otp, email: email, isFrom: .changeEmail)
                    }
                }
            }
        }
        
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnSendTapped(_ sender: Any) {
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    @IBAction func btnChangeTapped(_ sender: Any) {
        self.apiCalling()
    }
    
    // --------------------------------------------
}
