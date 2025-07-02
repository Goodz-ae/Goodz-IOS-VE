//
//  TwoStepVerificationVC.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
import UIKit

class TwoStepVerificationVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var apptopView: AppStatusView!
    @IBOutlet weak var lblTwoStep: UILabel!
    @IBOutlet weak var lblWeWillSend: UILabel!
    @IBOutlet weak var txtMobile: AppTextField!
    @IBOutlet weak var btnChange: ThemeGreenBorderButton!
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var lblVerified: UILabel!
    @IBOutlet weak var btnSend: ThemeGreenButton!
    @IBOutlet weak var lblProtectLogin: UILabel!
    @IBOutlet weak var lblTwoStepVerification: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    private var viewModel : TwoStepVerificationVM = TwoStepVerificationVM()
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.lblTwoStep.font(font: .medium, size: .size16)
        self.lblTwoStep.color(color: .themeBlack)
        
        self.lblWeWillSend.font(font: .regular, size: .size14)
        self.lblWeWillSend.color(color: .themeBlack)
        
        self.lblVerified.font(font: .medium, size: .size14)
        self.lblVerified.color(color: .themeBlack)
        
        self.lblProtectLogin.font(font: .medium, size: .size14)
        self.lblProtectLogin.color(color: .themeBlack)
        
        self.lblTwoStepVerification.font(font: .regular, size: .size14)
        self.lblTwoStepVerification.color(color: .themeBlack)
        
        self.btnSwitch.setImage(.switchGray, for: .normal)
        self.btnSwitch.setImage(.switchGreen, for: .selected)
        
        self.txtMobile.txtType = .normalWithoutImage
        self.txtMobile.txt.keyboardType = .numberPad
        self.txtMobile.txt.delegate = self
        
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblTwoStep.text = Labels.twoSteps
        self.lblWeWillSend.text = Labels.wewillSendYou
        self.lblVerified.text = Labels.verified
        self.lblProtectLogin.text = Labels.protectLoginAttempts
        self.lblTwoStepVerification.text = Labels.twoStepsVerificationIsActivated
        self.btnChange.setTitle(Labels.Change, for: .normal)
        self.btnSend.setTitle(Labels.sendConfirmationSMS, for: .normal)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.apptopView.textTitle = Labels.twoStepsVerification
        self.apptopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    private func getData() {
        self.viewModel.getTwoStepVerificationStatusAPI { isDone, isProtectLogin, mobileNo, isVerified in
            if isDone {
                self.imgVerified.image = isVerified == "1" ? .iconCheck : .icUncheckRound
                self.txtMobile.txt.text = mobileNo
                if isProtectLogin == "1" {
                    self.btnSwitch.isSelected = true
                }else{
                    self.btnSwitch.isSelected = false
                }
            }else{
                self.btnSwitch.isSelected = false
            }
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnChnageTapped(_ sender: Any) {
        self.viewModel.editMobileNoValidation(mobile: self.txtMobile.txt.text ?? ""){status, otp in
            if status {
                self.showAlert(title: "", message: Labels.areYouSureYouWantToChangeMobile ) {
                    self.viewModel.editMobileNoAPI(mobile: self.txtMobile.txt.text ?? "") {status, otp in
                        if status {
                            self.coordinator?.navigateToOTPVarification(token: UserDefaults.accessToken , userID: UserDefaults.userID , mobile: self.txtMobile.txt.text ?? "", email: UserDefaults.emailID, isFrom: .changeMobile)
                        }
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnSendTapped(_ sender: Any) {
        self.viewModel.editMobileNoValidation(mobile: self.txtMobile.txt.text ?? ""){status, otp in
            if status {
                self.showAlert(title: "", message: Labels.areYouSureYouWantToChangeMobile ) {
                    self.viewModel.editMobileNoAPI(mobile: self.txtMobile.txt.text ?? "") {status, otp in
                        if status {
                            self.coordinator?.navigateToOTPVarification(token: UserDefaults.accessToken , userID: UserDefaults.userID , mobile: self.txtMobile.txt.text ?? "", email: UserDefaults.emailID, isFrom: .changeMobile)
                        }
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnSwitchTapped(_ sender: Any) {
        self.btnSwitch.isSelected.toggle()
        self.viewModel.updateTwoStepVerificationStatusAPI(isProtectLogin: self.btnSwitch.isSelected ? "1" : "0") { isDone, str in
            
        }
    }
    
    // --------------------------------------------
    
}
extension TwoStepVerificationVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let range = Range(range, in: text) {
            let finaltext = text.replacingCharacters(in: range, with: string)
            if textField ==  self.txtMobile.txt {
               if textField.text == "" {
                   if string == " " {
                       return false
                   }
               }
                if finaltext.count > 15 { // Int(kLengthMobile.phoneNumberLength ?? "7") ?? 7 {
                   return false
               }
           }
        }
        return true
    }
}
