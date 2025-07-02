//
//  AutoLoginVC.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 12/03/25.
//

import UIKit
import AuthenticationServices
import LocalAuthentication

class AutoLoginVC: BaseVC {

    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var selectAccLbl: UILabel!
    @IBOutlet weak var userBackView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var activateFaceIDSwitchBtn: UISwitch!
    @IBOutlet weak var activateFaceIdLbl: UILabel!
    @IBOutlet weak var loginWithAnotherAccBtn: ThemeGreenButton!
    @IBOutlet weak var orLbl: UILabel!
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
    
    private var viewModel : LoginVM = LoginVM()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.setUp()
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        print("LoginVC")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func applyStyle() {
        
        self.skipBtn.font(font: .medium, size: .size16)
        self.skipBtn.color(color: .themeGreen)
        
        self.selectAccLbl.font(font: .semibold, size: .size16)
        self.selectAccLbl.color(color: .themeBlack)
        
        self.userNameLbl.font(font: .semibold, size: .size16)
        self.userNameLbl.color(color: .themeBlack)
        
        self.activateFaceIdLbl.font(font: .medium, size: .size16)
        self.activateFaceIdLbl.color(color: .themeBlack)
        
        self.userEmailLbl.font(font: .regular, size: .size14)
        self.userEmailLbl.color(color: .themeBlack)
        
        self.orLbl.font(font: .regular, size: .size14)
        self.orLbl.color(color: .themeGray)
        
        self.lblAple.font(font: .regular, size: .size14)
        self.lblAple.color(color: .themeLightGray)
        
        self.lblFacebook.font(font: .regular, size: .size14)
        self.lblFacebook.color(color: .themeLightGray)
        
        self.lblGoogle.font(font: .regular, size: .size14)
        self.lblGoogle.color(color: .themeLightGray)
        
        self.userBackView.cornerRadius = 5
        self.userImageView.cornerRadius = 40
        self.userImageView.borderColor = .themeGreen
        self.userImageView.borderWidth = 1
        
        self.userBackView.isUserInteractionEnabled = true
        self.userBackView.addTapGesture {
            self.checkForBiometricLogin()
        }
    }
    
    private func checkForBiometricLogin() {
        if UserSessionManager.shared.isBiometricLoginEnabled() {
            BiometricAuthManager.shared.checkBiometricPermission(completion: { isAuthenticated in
                if isAuthenticated {
                    print("User is authenticated. Proceeding with app logic.")
                    BiometricAuthManager.shared.authenticateUser { (success, error) in
                        if success, let token = UserSessionManager.shared.getSavedToken() {
                            guard let email = UserSessionManager.shared.getSavedEmail() else { return }
                            guard let password = UserSessionManager.shared.getSavedPassword() else { return }
                            self.performLoginWithToken(token, password: password, email: email)
                            
                        }
                    }
                } else {
                    print("User denied or failed authentication.")
                    BiometricAuthManager.shared.showBiometricPermissionAlert()
                }
            })
            
        } else {
            self.showSimpleAlert(Message: "Please enable biometric or proceed to login with another account.")
        }
    }
    
    private func performLoginWithToken(_ token: String, password: String, email: String) {
        self.viewModel.checkLoginData(email: email, password: password, firebaseToken: APP_DEL.firebaseDeviceToken) { isDone, code, data  in
            if isDone, let token = data.first?.token, let userName = data.first?.firstName, let userImage = data.first?.userProfile {
                
                UserSessionManager.shared.saveUserSession(token: token,email: email, password: password, username: userName, userImage: userImage, enableBiometric: self.activateFaceIDSwitchBtn.isOn)
                self.setLoginFlow(code: code, data: data)
            }
        }
    }
    
    private func dataSet() {
        if let email = UserSessionManager.shared.getSavedEmail(), let username = UserSessionManager.shared.getSavedUsername(), let userImage = UserSessionManager.shared.getSavedUserImage() {
            self.userEmailLbl.text = email
            self.userNameLbl.text = username
            if let url = URL(string: userImage) {
                self.userImageView.sd_setImage(with: url, placeholderImage: .avatarUser) // avatar
                self.userImageView.contentMode = .scaleAspectFill
            }
        }
        self.btnSignup.setAttributeText(str1: Labels.newUsers + " ", str2: Labels.signUp)
        self.selectAccLbl.text = Labels.selectAnAccountToSigninWith
        self.orLbl.text = Labels.oR
        self.lblAple.text = Labels.apple
        self.lblFacebook.text = Labels.facebook
        self.lblGoogle.text = Labels.google
        self.skipBtn.setTitle(Labels.skip, for: .normal)
        self.loginWithAnotherAccBtn.setTitle(Labels.loginWithAnotherAcc, for: .normal)
        self.activateFaceIdLbl.text = Labels.activeBiometric
        let isBiometricEnabled = UserSessionManager.shared.getBiometricStatus()
        if isBiometricEnabled {
            self.activateFaceIDSwitchBtn.isOn = true
        } else {
            self.activateFaceIDSwitchBtn.isOn = false
        }
        self.activateFaceIDSwitchBtn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
    }
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.dataSet()
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
//        UserSessionManager.shared.saveUserSession(token: UserDefaults.accessToken, enableBiometric: sender.isOn)
        if !sender.isOn {
            UserSessionManager.shared.saveBioMetric(enableBiometric: false)
            UserDefaults.isBiometricOn = false
        } else {
            UserDefaults.isBiometricOn = true
            UserSessionManager.shared.saveBioMetric(enableBiometric: true)
        }
     }
    
    @IBAction func skipBtnAction(_ sender: Any) {
        appUserDefaults.setValue(.isGuestUser, to: true)
        self.coordinator?.setTabbar()
        //self.coordinator?.navigateToAutoLoginVC()
    }
    
    @IBAction func googleBtnAction(_ sender: Any) {
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
    
    @IBAction func faceBookBtnAction(_ sender: Any) {
        appDelegate.fbLogin(viewController: self, userType: "2") { loggedIn in
            if loggedIn {
                print("User Login via facebook...")
            }
        }
    }
    
    @IBAction func appleBtnAction(_ sender: Any) {
        handleAppleIdRequest()
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        self.coordinator?.navigateToSignUp(fromAutoLogin: true)
    }
    
    @IBAction func loginWithAnotherAccBtnAction(_ sender: Any) {
        self.coordinator?.navigateToLoginVC()
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
extension AutoLoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
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
