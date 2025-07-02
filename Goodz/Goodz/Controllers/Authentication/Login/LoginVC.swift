//
//  LoginVC.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//


import UIKit
import AuthenticationServices
import LocalAuthentication

class LoginVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var txtPassword: AppTextField!
    @IBOutlet weak var btnForgotPwd: UIButton!
    @IBOutlet weak var activeBioLbl: UILabel!
    @IBOutlet weak var activeBioSwitchBtn: UISwitch!
    @IBOutlet weak var btnLogin: ThemeGreenButton!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblContinue: UILabel!
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var imgAple: UIImageView!
    @IBOutlet weak var lblAple: UILabel!
    @IBOutlet weak var btnAple: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : LoginVM = LoginVM()
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        UserDefaults.accessToken =  ""
        UserDefaults.isLogin = false
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        print("LoginVC")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.btnSkip.font(font: .medium, size: .size16)
        self.btnSkip.color(color: .themeGreen)
        
        self.lblLogin.font(font: .semibold, size: .size16)
        self.lblLogin.color(color: .themeBlack)
        
        self.txtEmail.txtType = .normal
        self.txtEmail.txt.keyboardType = .emailAddress
        self.txtEmail.imgleft.image = UIImage.iconMail
        
        self.txtPassword.txtType = .password
        self.txtPassword.imgleft.image = UIImage.iconPassword
        
        self.btnForgotPwd.font(font: .medium, size: .size16)
        self.btnForgotPwd.color(color: .themeBlack)
        
        self.activeBioLbl.font(font: .medium, size: .size16)
        self.activeBioLbl.color(color: .themeBlack)
        
        self.lblOr.font(font: .regular, size: .size14)
        self.lblOr.color(color: .themeGray)
        
        self.lblAple.font(font: .regular, size: .size14)
        self.lblAple.color(color: .themeLightGray)
        
        self.lblFacebook.font(font: .regular, size: .size14)
        self.lblFacebook.color(color: .themeLightGray)
        
        self.lblGoogle.font(font: .regular, size: .size14)
        self.lblGoogle.color(color: .themeLightGray)
        
        self.lblContinue.font(font: .regular, size: .size14)
        self.lblContinue.color(color: .themeBlack)
        
    }
    
    private func dataSet() {
        
        self.btnSignup.setAttributeText(str1: Labels.newUsers + " ", str2: Labels.signUp)
        self.lblLogin.text = Labels.pleaseLoginToYourAccount
        self.lblOr.text = Labels.oR
        self.lblContinue.text = Labels.continueWith
        self.lblAple.text = Labels.apple
        self.lblFacebook.text = Labels.facebook
        self.lblGoogle.text = Labels.google
        self.btnSkip.setTitle(Labels.skip, for: .normal)
        self.btnLogin.setTitle(Labels.login, for: .normal)
        self.btnForgotPwd.setTitle(Labels.forgotPasswordQue, for: .normal)
        self.txtEmail.placeholder = Labels.emailPlaceholder
        self.txtPassword.placeholder = Labels.passwordPlaceholder
        self.activeBioLbl.text = Labels.activeBiometric
        let isBiometricEnabled = UserSessionManager.shared.getBiometricStatus()
        if isBiometricEnabled {
            self.activeBioSwitchBtn.isOn = true
        } else {
            self.activeBioSwitchBtn.isOn = false
        }
        self.activeBioSwitchBtn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
    }
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.dataSet()
    }
    
    private func checkForBiometricLogin() {
        if UserSessionManager.shared.getBiometricStatus() {
            BiometricAuthManager.shared.authenticateUser { (success, error) in
                if success, let token = UserSessionManager.shared.getSavedToken() {
                    guard let email = UserSessionManager.shared.getSavedEmail() else { return }
                    guard let password = UserSessionManager.shared.getSavedPassword() else { return }
                    self.performLoginWithToken(token, password: password, email: email)
                }
            }
        }
    }
    
    private func performLoginWithToken(_ token: String, password: String, email: String) {
        self.viewModel.checkLoginData(email: email, password: password, firebaseToken: APP_DEL.firebaseDeviceToken) { isDone, code, data  in
            if isDone, let token = data.first?.token, let userName = data.first?.username, let userImage = data.first?.userProfile {
                
                UserSessionManager.shared.saveUserSession(token: token,email: email, password: password,username: userName,userImage: userImage, enableBiometric: self.activeBioSwitchBtn.isOn)
                self.setLoginFlow(code: code, data: data)
            }
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnForgotTapped(_ sender: Any) {
        self.coordinator?.navigateToForgotPassword()
    }
    
    // --------------------------------------------
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
//        UserSessionManager.shared.saveUserSession(token: UserDefaults.accessToken,email: self.txtEmail.txt.text ?? "", password: self.txtPassword.txt.text ?? "", enableBiometric: sender.isOn)
        if !sender.isOn {
            UserSessionManager.shared.saveBioMetric(enableBiometric: false)
            UserDefaults.isBiometricOn = false
        } else {
            UserDefaults.isBiometricOn = true
            UserSessionManager.shared.saveBioMetric(enableBiometric: true)
        }
     }
    
    // --------------------------------------------
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        self.viewModel.checkLoginData(email: self.txtEmail.txt.text ?? "", password: self.txtPassword.txt.text ?? "", firebaseToken: APP_DEL.firebaseDeviceToken) { isDone, code, data  in
            if isDone, let token = data.first?.token, let username = data.first?.firstName, let userImage = data.first?.userProfile {
                UserSessionManager.shared.saveUserSession(token: token,email: self.txtEmail.txt.text ?? "", password: self.txtPassword.txt.text ?? "", username: username, userImage: userImage, enableBiometric: self.activeBioSwitchBtn.isOn)
                self.setLoginFlow(code: code, data: data)
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnSkipTapped(_ sender: Any) {
        appUserDefaults.setValue(.isGuestUser, to: true)
        self.coordinator?.setTabbar()
        //self.coordinator?.navigateToAutoLoginVC()
    }
    
    // --------------------------------------------
    
    @IBAction func btnGoogleTapped(_ sender: Any) {
        
        appDelegate.googleLogin(viewController: self, userType: LoginType.google.rawValue, isCompany: false) { loggedIn in
            if loggedIn {
                self.viewModel.socialLogin(email: kSocialLoginData.email, password: "", firebaseToken: appDelegate.firebaseDeviceToken, socialType: appDelegate.selectedSocialLoginType.rawValue, socialRegisterId: kSocialLoginData.socialId) { status, code, data in
                    if status {
                        self.setLoginFlow(code: code, data: data)
                        print("User Login via google...")
                        kSocialLoginData = SocialLoginData(socialId: "", authToken: "", userName: "", name: "", givenName: "", familyName: "", email: "", dob: "", gender: "", mobile: "", countryCode: "")
                        }
                    }
                }
                
            
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnFaceBookTapped(_ sender: Any) {
        appDelegate.fbLogin(viewController: self, userType: "2") { loggedIn in
            if loggedIn {
                print("User Login via facebook...")
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnAppletapped(_ sender: Any) {
        handleAppleIdRequest()
    }
    
    // --------------------------------------------
    
    @IBAction func btnSignupTapped(_ sender: Any) {
        self.coordinator?.navigateToSignUp(fromAutoLogin: false)
    }
    
    // --------------------------------------------
    
    func setLoginFlow(code: String, data: [CurrentUserModel]) {
        if let userDetails = data.first {
            if code == "-6" {
                let token = userDetails.token ?? ""
                let userID = userDetails.userID ?? ""
                let mobile = userDetails.mobile ?? ""
                let email = userDetails.email ?? ""
                self.coordinator?.navigateToOTPVarification(token: token, userID: userID, mobile: mobile, email: email, isProUser: (userDetails.isGoodzPro == "2"))
            }else{
                if userDetails.isVerified == "1" {
                    UserDefaults.accessToken = userDetails.token ?? ""
                    UserDefaults.userID = userDetails.userID ?? ""
                    UserDefaults.isLogin = true
                    UserDefaults.isGuestUser = false
                    appUserDefaults.setValue(.isProUser, to: userDetails.isGoodzPro == Status.two.rawValue)
                    appUserDefaults.setCodableObject(userDetails, forKey: .currentUser)
                    if userDetails.isGoodzPro == "2" {
                        if userDetails.isUpdateProfile == Status.zero.rawValue {
                            print("🧢🧢🧢🧢🧢")
                            self.coordinator?.navigateToProBenefitList(comeFormSignup: true)
                        } else if userDetails.isUpdateProfile == Status.one.rawValue {
                            
                            print("💧💧💧💧💧")
                            if userDetails.documentsSubmitted == "0" || userDetails.documentsValidated == "0" {
                                self.coordinator?.navigateToProBenefitList(comeFormSignup: true)
                            } else {
                                print("🧤🧤🧤🧤🧤")
                                self.coordinator?.setTabbar()
                            }
                        }
                    } else {
                        self.coordinator?.setTabbar()
                    }
                } else {
                    let token = userDetails.token ?? ""
                    let userID = userDetails.userID ?? ""
                    let mobile = userDetails.mobile ?? ""
                    let email = userDetails.email ?? ""
                    self.coordinator?.navigateToOTPVarification(token: token, userID: userID, mobile: mobile, email: email, isProUser: (userDetails.isGoodzPro == "1"))
                }
            }
        }
    }
}

//MARK: - Apple Social Login
extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @objc func handleAppleIdRequest() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self as ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
 
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        var mStr = ""
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            var userIdentifier = appleIDCredential.user
            var familyName = appleIDCredential.fullName?.familyName ?? ""
            var givenName = appleIDCredential.fullName?.givenName ?? ""
            var email = appleIDCredential.email ?? ""
            
            var fullName = givenName+" "+familyName
            
            mStr = "\(userIdentifier)-\(familyName)-\(givenName)-\(email)"
            
            let keychainItem = KeychainItemWrapper(identifier: userIdentifier, accessGroup: nil)
            
            if email == "" {
                let mixString = (keychainItem[kSecValueData as String] as? String) ?? ""
                
                print("Password = ", mixString)
                let strArray = mixString.components(separatedBy: "-")
                
                if strArray.count == 4 {
                    userIdentifier = strArray[0]
                    familyName = strArray[1]
                    givenName = strArray[2]
                    email = strArray[3]
                    fullName = givenName+" "+familyName
                } else {
                    
                    familyName = ""
                    givenName = ""
                    email = ""
                    fullName = ""
                }
            } else {
                keychainItem[kSecValueData as String] = mStr as AnyObject // .setObject(mStr, forKey: kSecValueData)
            }
            
            let socialUserData = SocialLoginData(
                socialId: userIdentifier,
                authToken: "",
                userName: fullName,
                name: fullName,
                givenName: givenName,
                familyName: familyName,
                email: email,
                dob: "",
                gender: "",
                mobile: "",
                countryCode: ""
            )
            
            appDelegate.selectedSocialLoginType = .apple
            
            appDelegate.appleLogin(viewController: self, socialUserData: socialUserData, userType: LoginType.apple.rawValue, isCompany: false) { loggedIn in
                self.viewModel.socialLogin(email: kSocialLoginData.email, password: "", firebaseToken: appDelegate.firebaseDeviceToken, socialType: appDelegate.selectedSocialLoginType.rawValue, socialRegisterId: kSocialLoginData.socialId) { status, code, data in
                    if status {
                        self.setLoginFlow(code: code, data: data)
                        print("User Login via google...")
                        kSocialLoginData = SocialLoginData(socialId: "", authToken: "", userName: "", name: "", givenName: "", familyName: "", email: "", dob: "", gender: "", mobile: "", countryCode: "")
                    }
                }
            }
            
         } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let userIdentifier = passwordCredential.user
            let password = passwordCredential.password
            
            print("userIdentifier: \(userIdentifier)")
            print("password: \(password)")
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
 
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return appDelegate.window!
    }
}
