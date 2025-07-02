//
//  OTPVarification.swift
//  Goodz
//
//  Created by Akruti on 01/12/23.
//

import Foundation
import UIKit
enum OpenOTPVarification {
    case login
    case forgotPassword
}
class OTPVarification : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtSecond: UITextField!
    @IBOutlet weak var txtThird: UITextField!
    @IBOutlet weak var txtFourth: UITextField!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblInvalidOtp: UILabel!
    @IBOutlet weak var btnVerify: ThemeGreenButton!
    
    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    lazy var token = ""
    lazy var userID = ""
    lazy var mobile = ""
    lazy var email = ""
    lazy var isDocumentsSubmitted = ""
    lazy var isDocumentsVerified = ""
    var otp = ""
    var secondsRemaining = 2 * 60
    var myTimer : Timer?
    lazy var screenType: ScreenType = .defaultScreen
    private var viewModel : OTPVarificationVM = OTPVarificationVM()
    var isProUser = false
    
    // --------------------------------------------
    // MARK: - Life cycle methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirst.becomeFirstResponder()
        self.setUp()
        DispatchQueue.main.async {
            self.controlTimer()
        }
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("OTPVarification")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.lblTitle.font(font: .semibold, size: .size18)
        self.lblTitle.color(color: .themeBlack)
        
        self.lblDescription.font(font: .regular, size: .size16)
        self.lblDescription.color(color: .themeBlack)
        
        self.lblTimer.font(font: .regular, size: .size14)
        self.lblTimer.text = Labels.expiringIn + " 01:24"
        self.lblTimer.color(color: .themeGray)
        
        self.lblInvalidOtp.isHidden = true
        self.lblInvalidOtp.font(font: .regular, size: .size14)
        self.lblInvalidOtp.color(color: .themeRed)
        
        self.btnVerify.isEnabled = false
        
    }
    
    // --------------------------------------------
    
    func setRangeLabel() {
        
        self.lblResend.text = Labels.didntReceiveVerificationCode//setAttributeText(fulltext: .didntReceiveVerificationCodeResend, range1: .didntReceiveVerificationCode, range2: .resend, range3: "")
        // self.lblResend.isUserInteractionEnabled = true
        //  self.lblResend.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    // --------------------------------------------
    
    private func setVerifyButton() {
        if !(self.txtFirst.text!.isEmpty || self.txtSecond.text!.isEmpty || self.txtThird.text!.isEmpty || self.txtFourth.text!.isEmpty) {
            self.btnVerify.isEnabled = true
        } else {
            self.btnVerify.isEnabled = false
        }
    }
    
    // --------------------------------------------
    
    private func optTextfield() {
        
        self.txtFirst.delegate = self
        self.txtSecond.delegate = self
        self.txtThird.delegate = self
        self.txtFourth.delegate = self
        
        self.txtFirst.roundBorderWithColor(borderWidth: 1, borderColor: .themeBorder, cornerRadius: 8)
        self.txtSecond.roundBorderWithColor(borderWidth: 1, borderColor: .themeBorder, cornerRadius: 8)
        self.txtThird.roundBorderWithColor(borderWidth: 1, borderColor: .themeBorder, cornerRadius: 8)
        self.txtFourth.roundBorderWithColor(borderWidth: 1, borderColor: .themeBorder, cornerRadius: 8)
        
        self.txtFirst.font(font: .bold, size: .size20)
        self.txtSecond.font(font: .bold, size: .size20)
        self.txtThird.font(font: .bold, size: .size20)
        self.txtFourth.font(font: .bold, size: .size20)
        
        self.btnResend.font(font: .medium, size: .size14)
        
        self.lblResend.font(font: .regular, size: .size14)
        self.lblResend.color(color: .themeGray)
        self.btnResend.isHidden = true
        self.lblResend.isHidden = true
        self.btnResend.setTitle(Labels.resend, for: .normal)
        self.txtFirst.keyboardType = .numberPad
        self.txtSecond.keyboardType = .numberPad
        self.txtThird.keyboardType = .numberPad
        self.txtFourth.keyboardType = .numberPad
        self.txtFirst.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.txtSecond.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.txtThird.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.txtFourth.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = ""
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func controlTimer() {
        self.myTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            if self?.secondsRemaining ?? 0 > 0 {
                let minutes = Int(self?.secondsRemaining ?? 0) / 60
                let seconds = Int(self?.secondsRemaining ?? 0) % 60
                let timerResults = String(format: "%02d:%02d", minutes, seconds)
                self?.lblTimer.text = Labels.expiringIn + " \(timerResults)"
                self?.secondsRemaining -= 1
                self?.lblResend.isHidden = true
                self?.btnResend.isHidden = true
            } else {
                self?.lblResend.isHidden = false
                self?.btnResend.isHidden = false
                
                timer.invalidate()
                self?.lblTimer.text = "" //Labels.expired
            }
        }
        
        RunLoop.current.add(myTimer!, forMode: .common)
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.btnVerify.setTitle(Labels.verify, for: .normal)
        self.lblTitle.text = Labels.verificationCode
        self.lblDescription.text = Labels.enterVerificationCodeWeJustSentViaEmail
        
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.optTextfield()
        self.setRangeLabel()
        self.setData()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        let text = textField.text
        self.setVerifyButton()
        if (text!.utf16.count) >= 1 {
            switch textField {
            case self.txtFirst:
                self.txtSecond.becomeFirstResponder()
            case self.txtSecond:
                self.txtThird.becomeFirstResponder()
            case self.txtThird:
                self.txtFourth.becomeFirstResponder()
            case self.txtFourth:
                self.txtFourth.resignFirstResponder()
            default:
                break
            }
        } else {
        }
    }
    
    // --------------------------------------------
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text : String = Labels.didntReceiveVerificationCodeResend
        let termsRange = (text as NSString).range(of: Labels.resend)
        if self.lblTimer.text == Labels.expired  {
            if gesture.didTapAttributedTextInLabel(label: lblResend, inRange: termsRange) {
                
                self.viewModel.apiResendOTP(email: email) { status in
                    DispatchQueue.main.async {
                        self.myTimer?.invalidate()
                        self.secondsRemaining = 2 * 60
                        self.controlTimer()
                    }
                }
                
            } else {
                print("Tapped none")
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnVerifyTapped(_ sender: Any) {
        let otp = (self.txtFirst.text ?? "") + (self.txtSecond.text ?? "") + (self.txtThird.text ?? "") + (self.txtFourth.text ?? "")
        if (self.txtFirst.text ?? "").isEmpty || (self.txtSecond.text ?? "").isEmpty ||  (self.txtThird.text ?? "").isEmpty ||  (self.txtFourth.text ?? "").isEmpty {
            return
        }
        if self.screenType == .changeMobile {
            //            if otp == self.otp {
            self.viewModel.verifyChangeMobileOtpAPI(otp: otp, mobileNo: mobile) { isDone in
                if isDone {
                    self.coordinator?.popToRootVC()
                    GlobalRepo.shared.getProfileAPI { status, response, error in
                        print(response)
                    }
                }
            }
            //            }
        }else if self.screenType == .changeEmail {
//            if otp == self.otp {
                if  let currentUserEmail = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.email {
                    self.viewModel.verifyChangeEmailOtpAPI(oldEmail: currentUserEmail, currentEmail: self.email, otp: otp) { isDone in
                        if isDone {
                            self.coordinator?.popToRootVC()
                            GlobalRepo.shared.getProfileAPI { status, response, error in
                                print(response)
                            }
                        }
                    }
                }
//            }
        } else {
            self.viewModel.checkLoginData(email: email, otp: otp, mobile: mobile, userid: userID) { isDone, error in
                if isDone {
                    self.lblInvalidOtp.isHidden = true
                    if self.screenType == .forgotPassword {
                        self.coordinator?.navigateToResetPassword()
                    } else {
                        UserDefaults.accessToken = self.token
                        UserDefaults.isLogin = true
                        UserDefaults.isGuestUser = false
                        UserDefaults.userID = self.userID
                        UserDefaults.isDocumentsSubmitted = self.isDocumentsSubmitted == "0" ? false : true
                        UserDefaults.isDocumentsValidated = self.isDocumentsVerified == "0" ? false : true
                        appUserDefaults.setValue(.isProUser, to: self.isProUser)
                        if self.isProUser {
                            self.coordinator?.navigateToProSplash(isComeFromSignup: true)
                        } else {
                            self.coordinator?.setTabbar()
                        }
                        
                    }
                } else {
                    self.lblInvalidOtp.isHidden = false
                    if error == "otp_expired" {
                        self.lblInvalidOtp.text = Labels.otpExpired
                    } else {
                        self.lblInvalidOtp.text  = Labels.enteredOTPIsInvalid
                    }
                    self.clearOTPText()
                }
            }
        }
        
    }
    
    // --------------------------------------------
    
    @IBAction func btnResendTapped(_ sender: Any) {
        
        if self.screenType == .changeEmail {
            self.viewModel.changeCurrentEmailAPI(email: self.email) { otp, status in
                if status {
                    self.otp = otp
                    
                    //                    DispatchQueue.main.async {
                    
                    self.myTimer?.invalidate()
                    self.secondsRemaining = 2 * 60
                    self.controlTimer()
                    self.lblInvalidOtp.isHidden = true
                    self.clearOTPText()
                    //                    }
                }
            }
        } else {
            self.viewModel.apiResendOTP(email: self.email) { status in
                if status {
                    //                    DispatchQueue.main.async {
                    notifier.showToast(message: Labels.otpResendSuccessfully)
                    self.myTimer?.invalidate()
                    self.secondsRemaining = 2 * 60
                    self.controlTimer()
                    self.lblInvalidOtp.isHidden = true
                    self.clearOTPText()
                    //                    }
                }
            }
        }
    }
    
    func clearOTPText() {
        txtFirst.text = nil
        txtSecond.text = nil
        txtThird.text = nil
        txtFourth.text = nil
    }
}

// --------------------------------------------
// MARK: - UITextFeild Delegate Methods -
// --------------------------------------------

extension OTPVarification : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.lblInvalidOtp.isHidden = true
        textField.text = ""
        self.setVerifyButton()
        switch textField {
        case txtFirst:
            self.txtSecond.text = ""
            self.txtThird.text = ""
            self.txtFourth.text = ""
        case txtSecond:
            self.txtThird.text = ""
            self.txtFourth.text = ""
        case txtThird:
            self.txtFourth.text = ""
        case txtFourth:
            break
        default:
            break
        }
    }
    
    // --------------------------------------------
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.roundBorderWithColor(borderWidth: 1, borderColor: .themeGreen, cornerRadius: 8)
        return true
    }
    
    // --------------------------------------------
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.roundBorderWithColor(borderWidth: 1, borderColor: .themeGray, cornerRadius: 8)
    }
    
    // --------------------------------------------
    
}
