//
//  SignUpVC.swift
//  Goodz
//
//  Created by Akruti on 30/11/23.
//

import Foundation
import UIKit
import AuthenticationServices

class SignUpVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var vwSocialLogin: UIStackView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var lblCreateAccount: UILabel!
    @IBOutlet weak var txtUsername: AppTextField!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var txtMobile: AppTextField!
    @IBOutlet weak var txtPassword: AppTextField!
    
    @IBOutlet weak var txtCompanyName: AppTextField!
    
    @IBOutlet weak var btnSigup: ThemeGreenButton!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblContinue: UILabel!
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblFaceBook: UILabel!
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var imgApple: UIImageView!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblApple: UILabel!
    @IBOutlet weak var btnAlredyLogin: UIButton!
    
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : SignUpVM = SignUpVM()
    var comeFromSocial : Bool = false
    var socialUserData : SocialLoginData?
    var isCompany = false
    var fromAutoLoginVC: Bool = false
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
        print("SignUpVC")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        txtCompanyName.isHidden = true
        self.btnSkip.font(font: .medium, size: .size16)
        self.btnSkip.color(color: .themeGreen)
      
        self.lblCreateAccount.font(font: .semibold, size: .size14)
        self.lblCreateAccount.color(color: .themeBlack)
        
        self.txtEmail.txtType = .normal
        self.txtEmail.txt.keyboardType = .emailAddress
        self.txtEmail.imgleft.image = .iconMail
        self.txtMobile.txtType = .phoneNumber
        self.txtMobile.txt.keyboardType = .numberPad
        self.txtMobile.imgleft.image = .iconMobile
        self.txtPassword.txtType = .password
        self.txtPassword.imgleft.image = .iconPassword
        self.txtUsername.txtType = .normal
        self.txtUsername.imgleft.image = .iconUser
        
        txtCompanyName.txtType = .normal
        self.txtCompanyName.imgleft.image = .iconUser
        
        self.lblOr.font(font: .regular, size: .size14)
        self.lblOr.color(color: .themeGray)
        
        self.lblApple.font(font: .regular, size: .size14)
        self.lblApple.color(color: .themeLightGray)
        
        self.lblFaceBook.font(font: .regular, size: .size14)
        self.lblFaceBook.color(color: .themeLightGray)
        
        self.lblGoogle.font(font: .regular, size: .size14)
        self.lblGoogle.color(color: .themeLightGray)
        
        self.lblContinue.font(font: .regular, size: .size14)
        self.lblContinue.color(color: .themeBlack)
        self.btnCheckBox.isSelected = false
        self.btnCheckBox.setImage(.iconUncheckBox, for: .normal)
        self.btnCheckBox.setImage(.iconCheckSquare, for: .selected)
        self.txtUsername.txt.autocapitalizationType = .words
        self.txtUsername.txt.delegate = self
        
        self.txtCompanyName.txt.autocapitalizationType = .words
        self.txtCompanyName.txt.delegate = self
        
        
        
        self.txtMobile.txt.delegate = self
        self.btnUser.isSelected = !isCompany
        self.btnCompany.isSelected = isCompany
        
        [self.btnUser, self.btnCompany].forEach {
            $0.font(font: .semibold, size: .size14)
            $0.color(color: .themeBlack)
            $0.setImage(.icCheckRound, for: .selected)
            $0.setImage(.icUncheckRound, for: .normal)
        }
        self.txtMobile.lblCode.text = kLengthMobile.countryCode
        if self.comeFromSocial {
            self.btnCompany.isHidden = true
            self.setSocialUserData()
        }else{
            self.btnCompany.isHidden = false
        }
        self.txtMobile.isHidden = true
    }
    
    // --------------------------------------------
    
    private func setSocialUserData() {
        print("⚛️⚛️⚛️⚛️⚛️⚛️⚛️⚛️⚛️")
        print(self.socialUserData)
        self.txtMobile.txt.text = self.socialUserData?.mobile
        self.txtMobile.lblCode.text = self.socialUserData?.countryCode
        self.txtEmail.txt.text = self.socialUserData?.email
        self.txtUsername.txt.text = self.socialUserData?.userName
        self.txtPassword.isHidden = true
//        self.txtEmail.txt.isUserInteractionEnabled = false
    }
    
    //MARK: - Attributes String
    func setTermsAndConditionAttributedText() {
        //elf.lblTerms.font(font: .regular, size: .size14)
        
        let fullText = Labels.byRegisteringIConfirmThatIAcceptGoodzs
        
        let range1 = (fullText as NSString).range(of: Labels.termsCondition)
        let range2 = (fullText as NSString).range(of: "Privacy Policy")

        // Define attributes
        let fullTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.themeGray, .font: FUNCTION().getFont(for: .regular, size: FontSize.size14)]
        let attributeRangeAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.themeBlack, .font: FUNCTION().getFont(for: .medium, size: FontSize.size14)]

        // Create attributed string
        let attributedString = NSMutableAttributedString(string: fullText, attributes: fullTextAttributes)

        // Apply attributes to the specified ranges
        attributedString.addAttributes(attributeRangeAttributes, range: range1)
        attributedString.addAttributes(attributeRangeAttributes, range: range2)
        self.lblTerms.attributedText = attributedString
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        self.lblTerms.isUserInteractionEnabled = true
        self.lblTerms.addGestureRecognizer(tapAction)
    }
    
    @objc private func tapLabel(gesture: UITapGestureRecognizer) {
        
        if gesture.didTapAttributedTextInLabel(label: lblTerms, targetText: Labels.termsCondition) {
            print("Terms of service")
            
            self.coordinator?.navigateToWebView(id: 5) //Terms And Condition = 5
            
        } else if gesture.didTapAttributedTextInLabel(label: lblTerms, targetText: "Privacy Policy") {
            print("Privacy Policy")
            
            self.coordinator?.navigateToWebView(id: 2) //Terms And Condition = 5
            
        }
    }
    // --------------------------------------------
    
    private func setData() {
        self.btnAlredyLogin.setAttributeText(str1: Labels.alreadyUser + " ", str2: Labels.login)
        self.btnUser.setTitle("  " + Labels.registerAsUser, for: .normal)
        self.btnCompany.setTitle("  " + Labels.registerAsCompany, for: .normal)
        self.btnSkip.setTitle(Labels.skip, for: .normal)
        self.lblOr.text = Labels.oR
        self.lblContinue.text = Labels.continueWith
        self.lblApple.text = Labels.apple
        self.lblFaceBook.text = Labels.facebook
        self.lblGoogle.text = Labels.google
        self.txtEmail.placeholder = Labels.emailPlaceholder
        self.txtPassword.placeholder = Labels.passwordPlaceholder
        self.txtMobile.placeholder = Labels.phoneNumberPlaceholder
        self.txtUsername.placeholder = Labels.fullNamePlaceholder
        self.txtCompanyName.placeholder = "Comapny Name*"
        self.lblCreateAccount.text = Labels.pleaseCreateYourAccount
        self.txtMobile.countryCodeClicked = {
            self.coordinator?.coutryCodePopup(completion: { code in
                self.txtMobile.lblCode.text = code
            })
        }
        self.setTermsAndConditionAttributedText()
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnSkipTapped(_ sender: Any) {
        appUserDefaults.setValue(.isGuestUser, to: true)
        self.coordinator?.setTabbar()
    }
    
    // --------------------------------------------
    
    @IBAction func btnSignupTapped(_ sender: Any) {
        if self.comeFromSocial {
            var social = self.socialUserData
            social?.mobile = self.txtMobile.txt.text ?? ""
            social?.countryCode = self.txtMobile.lblCode.text ?? ""
            social?.userName = (self.txtUsername.txt.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            self.socialUserData = social
            self.viewModel.checkSocialLoginData(username: self.txtUsername.txt.text ?? "", isAgree: self.btnCheckBox.isSelected) { status in
                if status {
                    if let data = self.socialUserData {
                        GlobalRepo.shared.socialRegisterAPI(data , userType: self.btnUser.isSelected ? "1" : "2") { status, data, error in
                            if status {
                                //                            UserDefaults.accessToken = data?.first?.token ?? ""
                                //                            UserDefaults.isLogin = true
                                //                            UserDefaults.userID = data?.first?.userID ?? ""
                                //                            appUserDefaults.setValue(.isGuestUser, to: false)
                                //                            self.coordinator?.setTabbar()
                                if let currentUserData = data?.first {
                                    self.coordinator?.navigateToOTPVarification(token: currentUserData.token ?? "" , userID: currentUserData.userID ?? "" , mobile: currentUserData.mobile ?? "", email: currentUserData.email ?? "", isProUser: self.btnCompany.isSelected, isDocumentsSubmitted: currentUserData.documentsSubmitted ?? "", isDocumentsValidated: currentUserData.documentsValidated ?? "")
                                }
                            } else {
                                if let errorMsg = error {
                                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                                }
                            }
                        }
                    }
                }
            }
        } else {
            let txtCompanyName = txtCompanyName.txt.text ?? ""
            let userName = self.txtUsername.txt.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.viewModel.checkLoginData(store_name: txtCompanyName, username: userName, email: self.txtEmail.txt.text ?? "", password: self.txtPassword.txt.text ?? "", isAgree: self.btnCheckBox.isSelected, firebaseToken: APP_DEL.firebaseDeviceToken, userType: self.btnUser.isSelected ? "1" : "2", isProUser: self.btnCompany.isSelected) { isDone, data in
                if isDone {
                    let userData = data?.first
                    self.coordinator?.navigateToOTPVarification(token: userData?.token ?? "" , userID: userData?.userID ?? "" , mobile: userData?.mobile ?? "", email: userData?.email ?? "", isProUser: self.btnCompany.isSelected)
                }
            }
           /* self.viewModel.checkLoginData(store_name : txtCompanyName   , username: userName, email: self.txtEmail.txt.text ?? "", store_name: "", password: self.txtPassword.txt.text ?? "", isAgree: self.btnCheckBox.isSelected, firebaseToken: APP_DEL.firebaseDeviceToken , userType: self.btnUser.isSelected ? "1" : "2") { isDone, data  in
                if isDone {
                    let userData = data?.first
                    self.coordinator?.navigateToOTPVarification(token: userData?.token ?? "" , userID: userData?.userID ?? "" , mobile: userData?.mobile ?? "", email: userData?.email ?? "", isProUser: self.btnCompany.isSelected)
                }
            }*/
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnAgreeTapped(_ sender: Any) {
        self.btnCheckBox.isSelected.toggle()
    }
    // --------------------------------------------
    
    @IBAction func btnAlreadyLoginTapped(_ sender: Any) {
        if self.fromAutoLoginVC {
            let vc = AutoLoginVC.instantiate(storyBoard: .auth)
            if let navigationController = navigationController {
                for vc in navigationController.viewControllers {
                    if let loginSignUpVC  = vc as? AutoLoginVC {
                        navigationController.popToViewController(loginSignUpVC, animated: true)
                    }
                }
            }
        } else {
            let vc = LoginVC.instantiate(storyBoard: .auth)
            if let navigationController = navigationController {
                for vc in navigationController.viewControllers {
                    if let loginSignUpVC  = vc as? LoginVC {
                        navigationController.popToViewController(loginSignUpVC, animated: true)
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnGoogleTapped(_ sender: Any) {
        appDelegate.googleLogin(viewController: self, userType: "2", isCompany: self.btnCompany.isSelected) { loggedIn in
            if loggedIn {
                print("User Login via google...")
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnFacebookTapped(_ sender: Any) {
        appDelegate.fbLogin(viewController: self, userType: "2") { loggedIn in
            if loggedIn {
                print("User Login via facebook...")
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnAppleTapped(_ sender: Any) {
        handleAppleIdRequest()
    }
    
    // --------------------------------------------
    
    
    @IBAction func btnCompanyTapped(_ sender: Any) {
        self.btnUser.isSelected = false
        self.btnCompany.isSelected = true
        self.vwSocialLogin.isHidden = true
        txtCompanyName.isHidden = false
    }
    
    // --------------------------------------------
    
    @IBAction func bnUserTapped(_ sender: Any) {
        self.btnUser.isSelected = true
        self.btnCompany.isSelected = false
        self.vwSocialLogin.isHidden = false
        txtCompanyName.isHidden = true
    }
    
    // --------------------------------------------
}

//MARK: - Apple Social Login
extension SignUpVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
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
            
            appDelegate.appleLogin(viewController: self, socialUserData: socialUserData, userType: LoginType.apple.rawValue, isCompany: self.btnCompany.isSelected) { loggedIn in
                
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

// --------------------------------------------
// MARK: - UITextField Delegate methods
// --------------------------------------------

extension SignUpVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range1 = Range(range, in: text) {
            let finaltext = text.replacingCharacters(in: range1, with: string)
            if textField == self.txtUsername.txt {
//                if string == " " {
//                           return false // Disallow space character
//                       }
                       
                       // Calculate the final text after applying the replacement
                       let finalText1 = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
                       
                       // Check if the final text exceeds the maximum length
                       if finalText1.count > TextFieldMaxLenth.productTitleMaxLength.length {
                           return false // Disallow input if it exceeds the maximum length
                       }
                
                
            } else if textField == self.txtMobile.txt {
                if textField.text == "" {
                    if string == " " {
                        return false
                    }
                }
                if finaltext.count > 15 { // (Int(kLengthMobile.phoneNumberLength ?? "7") ?? 7) {
                    return false
                }
            }
        }
        return true
    }
}
