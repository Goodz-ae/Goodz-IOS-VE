//
//  AppDelegate+LoginAndOther.swift
//
//
//  Created by vtadmin on 02/02/23.
//

import Foundation
import GoogleSignIn
import AudioToolbox
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit
import AppTrackingTransparency
var kSocialLoginData = SocialLoginData(socialId: "", authToken: "", userName: "", name: "", givenName: "", familyName: "", email: "", dob: "", gender: "", mobile: "", countryCode: "")
// MARK: - FB Social Login
extension AppDelegate {
    
    func fbLogin(viewController: UIViewController, userType : String, handler: @escaping ((_ loggedIn: Bool)->())) {
        
        AppDelegate.instance.selectedSocialLoginType = .facebook
        
        let fbManager = LoginManager()
        fbManager.logOut()
        
        fbManager.logIn(permissions: ["public_profile", "email"], from: viewController) { result, error in
            
            AppDelegate.instance.selectedSocialLoginType = .none
            
            if error != nil {
                notifier.showToast(message: Labels.somethingWentWrong)
                handler(false)
            } else {
                if (result?.token) != nil {
                    let requestMe = GraphRequest(graphPath: "me", parameters: ["fields": "name,picture,email,first_name,last_name,location,gender,hometown,birthday"])
                    let connection = GraphRequestConnection()
                    
                    connection.add(requestMe) { connection, result, error in
                        
                        print(result as Any, error as Any)
                       
                        if let user = result as? [String: Any] {
                            
                            let socialId = (user["id"] as? String) ?? ""
                            let authToken = ""
                            let name = (user["name"] as? String) ?? ""
                            let givenName = (user["first_name"] as? String) ?? ""
                            let familyName = (user["last_name"] as? String) ?? ""
                            let email = (user["email"] as? String) ?? ""
                            
                            let socialUserData = SocialLoginData(
                                socialId: socialId,
                                authToken: authToken,
                                userName: name,
                                name: name,
                                givenName: givenName,
                                familyName: familyName,
                                email: email,
                                dob: "",
                                gender: "",
                                mobile: "",
                                countryCode: ""
                            )
                            
                            AppDelegate.instance.selectedSocialLoginType = .facebook
                            
                            if email == "" {
                                self.askForEmailIfSocialLoginEmailNotExist(viewController, socialUserData, userType: userType, handler: handler)
                            } else {
                                DispatchQueue.main.async { [self] in
                                    handler(true)
                                }
                            }
                        }
                    }
                    connection.start()
                } else {
                    handler(false)
                    fbManager.logOut()
                }
            }
        }
    }
    
    //MARK: -  ask For Email If Social Login Email Not Exist
    func askForEmailIfSocialLoginEmailNotExist(_ viewController: UIViewController, _ socialUserData: SocialLoginData, userType: String, handler: @escaping ((_ loggedIn: Bool)->())) {
        let alert = UIAlertController(title: Labels.appName, message: Labels.enterEmailId, preferredStyle: .alert)
        alert.addTextField { txt in
            txt.placeholder = Labels.enterEmailId
            txt.isSecureTextEntry = false
        }
        alert.addAction(UIAlertAction(title: Labels.submit, style: .default, handler: { act in
            if !Validation.shared.isValidEmail(alert.textFields?[0].text ?? "") {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.askForEmailIfSocialLoginEmailNotExist(viewController, socialUserData, userType: userType, handler: handler)
            } else {
                
                var newObj = socialUserData
                newObj.email = alert.textFields?[0].text ?? ""
                
                DispatchQueue.main.async { [self] in
                    handler(true)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: Labels.cancel, style: .cancel, handler: { act in
            handler(false)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Google Social Login
extension AppDelegate {
    
    func googleLogin(viewController: UIViewController,userType : String, isCompany: Bool, handler: @escaping ((_ loggedIn: Bool)->())) {
        let kData = SocialLoginData(socialId: "", authToken: "", userName: "", name: "", givenName: "", familyName: "", email: "", dob: "", gender: "", mobile: "", countryCode: "")
        AppDelegate.instance.selectedSocialLoginType = .google
        
        GIDSignIn.sharedInstance.signOut()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { userData, error in
            if error != nil {
                handler(false)
                return
            }
            
            if let user = userData {
                
                let userId = user.user.userID ?? ""
                let idToken = user.user.idToken?.tokenString ?? ""
                let fullName = user.user.profile?.name ?? ""
                let givenName = user.user.profile?.givenName ?? ""
                let familyName = user.user.profile?.familyName ?? ""
                let email = user.user.profile?.email ?? ""
                
                let socialUser = SocialLoginData(
                    socialId: userId,
                    authToken: idToken,
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
                kSocialLoginData = socialUser
                AppDelegate.instance.selectedSocialLoginType = .google
                
                if email == "" {
                    self.askForEmailIfSocialLoginEmailNotExist(viewController, socialUser, userType: userType, handler: handler)
                } else {
                    DispatchQueue.main.async { [self] in
                        if viewController is SignUpVC {
                            self.coordinator?.navigateToSocialSignUp(socialUserData: socialUser, isCompany: isCompany)
                        } else {
                            handler(true)
                            
                        }
                        //apiCallingSocialRegister(socialUser, userType: userType, handler: handler)
                    }
                }
                
            } else {
                handler(false)
            }
        }
    }
    
}

extension AppDelegate {
    func appleLogin(viewController: UIViewController, socialUserData: SocialLoginData, userType : String, isCompany: Bool, handler: @escaping ((_ loggedIn: Bool)->())) {
        kSocialLoginData = socialUserData
        AppDelegate.instance.selectedSocialLoginType = .apple
        
        if socialUserData.email == "" {
            self.askForEmailIfSocialLoginEmailNotExist(viewController, socialUserData, userType: userType, handler: handler)
        } else {
            DispatchQueue.main.async { [self] in
                if viewController is SignUpVC {
                    self.coordinator?.navigateToSocialSignUp(socialUserData: socialUserData, isCompany: isCompany)
                } else {
                    handler(true)
                    
                }
            }
        }
    }
}
