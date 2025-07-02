//
//  ResetPasswordVC.swift
//  Goodz
//
//  Created by Akruti on 30/11/23.
//

import UIKit

class ResetPasswordVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtCurrentPassword: AppTextField!
    @IBOutlet weak var lblChangePassword: UILabel!
    @IBOutlet weak var lblpasswordRequired: UILabel!
    @IBOutlet weak var txtNewPassword: AppTextField!
    @IBOutlet weak var txtConfirmPasswod: AppTextField!
    @IBOutlet weak var btnSaved: ThemeGreenButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwReset: UIStackView!
    @IBOutlet weak var vwChange: UIStackView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var isChangePassword = false
    private var viewModel : ResetPasswordVM = ResetPasswordVM()
    
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
        print("ResetPasswordVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.lblTitle.font(font: .semibold, size: .size16)
        self.lblTitle.color(color: .themeBlack)
        
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblDescription.color(color: .themeBlack)
        
        self.lblChangePassword.font(font: .semibold, size: .size16)
        self.lblChangePassword.color(color: .themeBlack)
        
        self.lblpasswordRequired.font(font: .regular, size: .size14)
        self.lblpasswordRequired.color(color: .themeBlack)
        
        self.txtCurrentPassword.txtType = .password
        self.txtCurrentPassword.imgleft.image = .iconPassword
        self.txtNewPassword.txtType = .password
        self.txtNewPassword.imgleft.image = .iconPassword
        self.txtConfirmPasswod.txtType = .password
        self.txtConfirmPasswod.imgleft.image = .iconPassword
        
        self.btnLogin.font(font: .medium, size: .size16)
        self.btnLogin.color(color: .themeBlack)
        
        if self.isChangePassword {
            self.vwReset.isHidden = true
            self.btnLogin.isHidden = true
        } else {
            self.txtCurrentPassword.isHidden = true
            self.vwChange.isHidden = true
        }
        
    }
    
    // --------------------------------------------
    
    private func setData() {
        if self.isChangePassword {
            self.btnSaved.setTitle(Labels.changePassword, for: .normal)
            self.lblTitle.text = Labels.changePassword
            self.lblChangePassword.text = Labels.changePassword
            self.lblpasswordRequired.text = Labels.passwordRequirementsShouldInclude
            self.txtCurrentPassword.placeholder = Labels.currentPassword
            self.txtNewPassword.placeholder = Labels.newPassword
            self.txtConfirmPasswod.placeholder = Labels.confirmNewPassword
        } else {
            self.txtNewPassword.placeholder = Labels.newPasswordPlaceHolder
            self.txtConfirmPasswod.placeholder = Labels.confirmedPasswordPlaceHolder
            self.btnSaved.setTitle(Labels.saveNewPassword , for: .normal)
            self.lblTitle.text = Labels.resetPassword
            self.lblDescription.text = Labels.pleaseEnterNewPassword
            self.btnLogin.setTitle(Labels.backToLogin, for: .normal)
        }
    }
    
    // --------------------------------------------
    
    private func setTopViewAction() {
        self.appTopView.textTitle = self.isChangePassword ? Labels.changePassword : ""
        self.appTopView.backButtonClicked = { [] in
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
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnSavedTaped(_ sender: Any) {
        if self.isChangePassword {
            /// Change Password
            self.viewModel.checkChangePasswordData(currentPassword: self.txtCurrentPassword.txt.text ?? "", newPassword: self.txtNewPassword.txt.text ?? "", confirmPassword: self.txtConfirmPasswod.txt.text ?? "") { isDone in
                if isDone {
                    //                    self.showAlert(title: "", message: Labels.areYouSureYouWantToChangePassword ) {
                    self.viewModel.apiChangePassword(currentPassword: self.txtCurrentPassword.txt.text ?? "", newPassword: self.txtNewPassword.txt.text ?? "", confirmPassword: self.txtConfirmPasswod.txt.text ?? "") { isDone in
                        if isDone {
                            self.coordinator?.popVC()
//                            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//                            UserDefaults.standard.clearUserDefaults()
//                            self.coordinator?.navigateToLoginVC()
//                            appDelegate.setLogin()
                        }
                    }
                    //                    }
                }
            }
        } else {
            /// Reset Password
            let email = UserDefaults.emailID
            self.viewModel.checkResetPasswordData(email: email, newPassword: self.txtNewPassword.txt.text ?? "", confirmPassword: self.txtConfirmPasswod.txt.text ?? "") { [self] isDone in
                if isDone {
//                    self.showAlert(title: "", message: Labels.areYouSureYouWantToResetPassword ) {
                        self.viewModel.apiResetPassword(email: email, newPassword: self.txtNewPassword.txt.text ?? "", confirmPassword: self.txtConfirmPasswod.txt.text ?? "") { isDone in
                            if isDone {
                                self.showOKAlert(title: Labels.goodz, message: Labels.resetPasswordSuccessfully) {
                                    appDelegate.setRootWindow()
                                }
                            }
                        }
//                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        self.coordinator?.popToRootVC()
    }
    
    // --------------------------------------------
    
}
