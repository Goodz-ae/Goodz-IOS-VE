//
//  AppDelegate.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import FirebaseDynamicLinks

let APP_DEL = UIApplication.shared.delegate as! AppDelegate
@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var applicationNavController: UINavigationController!
    var coordinator: MainCoordinator?
    var window : UIWindow?
    var selectedSocialLoginType = LoginType.none
    var signInConfig: GIDConfiguration?
    var firebaseDeviceToken = "asd"
    var apnsDeviceToken = ""
    var isShowInvalidTokenAlert = false
    var arrCustomization = [CustomizationModels]()
    var isCustomizationChanges = false
    var ipInfo: IPAddressDataModel?
    var productID = ""
    var appVersion : String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    }
    var buildVersion : String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0.0"
    }
    var generalModel : SplashModel?
    
    public class var instance: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("no Application Delegate found")
        }
        return appDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let notificationPayload = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
        if notificationPayload != nil {
            AppDelegate.dictNotificationData = notificationPayload
        }
        API_S3.initializeS3()
        IQKeyboardManager.shared.isEnabled = true
        UIScrollView.appearance().showsHorizontalScrollIndicator = false
        UIScrollView.appearance().showsVerticalScrollIndicator = false
        
        // Facebook Social Login Configuration
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        FirebaseApp.configure()
        setupPushNotification(application)
        firebaseDelegateMathod()
        
        // Google Social Login Configuration
        signInConfig = GIDConfiguration(clientID: "1061598790640-puskagvtmn2gf8tp3uq8r9pb2drlnpqc.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let err = error {
                print(err) // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        
        // Handle deep link if app is launched via URL
        if let userActivity = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [String: Any],
           let incomingURL = (userActivity[UIApplication.LaunchOptionsKey.userActivityType.rawValue] as? NSUserActivity)?.webpageURL {
            DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamiclink, error) in
                self.handleDynamicLink(dynamiclink)
            }
        }
        
        if let urlContext = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            DynamicLinks.dynamicLinks().handleUniversalLink(urlContext) { (dynamiclink, error) in
                self.handleDynamicLink(dynamiclink)
            }
        }
        UserDefaults.profileCheckExecutedInSession = false
        self.clearDeliveredNotificationsAndResetBadgeCount()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func clearDeliveredNotificationsAndResetBadgeCount() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // MARK: - Handle All URLs
   func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
       if selectedSocialLoginType == .facebook { // Handle Facebook open URL

           ApplicationDelegate.shared.application(
               app,
               open: url,
               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
           )
           
       } else if selectedSocialLoginType == .google { // Handle Google open URL
           GIDSignIn.sharedInstance.handle(url)
           
       } else {

           let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { (dynamiclink, error) in
               self.handleDynamicLink(dynamiclink)
           }
           //           ApplicationDelegate.shared.application( // Handle Other open URL
           //                       app,
           //                       open: url,
           //                       sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
           //                       annotation: options[UIApplication.OpenURLOptionsKey.annotation]
           //                   )
           return handled
       }
      
       return false
   }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamiclink, error) in
                self.handleDynamicLink(dynamiclink)
            }
            if linkHandled {
                return true
            }
        }
        return false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .isFromSplash, object: nil)
    }
    
}

extension AppDelegate {
    // Handle dynamic links
    func handleDynamicLink(_ dynamicLink: DynamicLink?) {
        guard let url = dynamicLink?.url else {
            return
        }
        print("Received dynamic link: \(url.absoluteString)")
        // Handle the dynamic link and navigate in the app
        navigateToSpecificView(url: url)
    }
    
    func navigateToSpecificView(url: URL) {
        // Parse the URL and navigate to the appropriate screen
        if url.absoluteString.contains("/product") {
            // Navigate to the product view controller
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems,
               let productIdItem = queryItems.first(where: { $0.name == "product_id" }),
               let productId = productIdItem.value {
                self.productID = productId
                NotificationCenter.default.addObserver(self, selector: #selector(navigateToProductVC(_:)), name: .isFromSplash, object: nil)
                self.coordinator?.navigateToProductDetail(productId: self.productID, type: .goodsPro)
            }
        }
    }
    
    @objc private func navigateToProductVC(_ notification: Notification) {
        self.coordinator?.navigateToProductDetail(productId: self.productID, type: .goodsPro)
    }
    
    func setStartRootView() {
        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController)
        self.window = UIApplication.shared.windows.first
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        self.coordinator?.start()
    }
    
    func setRootWindow(isLogout: Bool = false) {
        
        if UserDefaults.isLogin && !UserDefaults.accessToken.isEmpty {
            
            let navController = UINavigationController()
            navController.navigationBar.isHidden = true
            coordinator = MainCoordinator(navigationController: navController)
            self.window = UIApplication.shared.windows.first
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
            self.coordinator?.setTabbar()
            
        }else if UserDefaults.isGuestUser {
            
            let navController = UINavigationController()
            navController.navigationBar.isHidden = true
            coordinator = MainCoordinator(navigationController: navController)
            self.window = UIApplication.shared.windows.first
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
            self.coordinator?.setTabbar()
            
        }else {
            let isBio = UserSessionManager.shared.getBiometricStatus()
            if isBio {
                UserDefaults.isBiometricOn = true
                if let userSession = UserSessionManager.shared.getSavedToken() {
                    let navController = UINavigationController()
                    coordinator = MainCoordinator(navigationController: navController)
                    self.window = UIApplication.shared.windows.first
                    self.window?.rootViewController = navController
                    self.window?.makeKeyAndVisible()
                    self.coordinator?.navigateToAutoLoginVC()
                } else {
                    let navController = UINavigationController()
                    coordinator = MainCoordinator(navigationController: navController)
                    self.window = UIApplication.shared.windows.first
                    self.window?.rootViewController = navController
                    self.window?.makeKeyAndVisible()
                    self.coordinator?.navigateToLoginVC()
                }
            } else {
                UserDefaults.isBiometricOn = false
                let navController = UINavigationController()
                coordinator = MainCoordinator(navigationController: navController)
                self.window = UIApplication.shared.windows.first
                self.window?.rootViewController = navController
                self.window?.makeKeyAndVisible()
                self.coordinator?.navigateToLoginVC()
            }
        }
        
        NETWORK.reachability.whenUnreachable = { reachability in
            
            if let topVC : UIViewController = UIApplication.topViewController() {
                
                let vc = OfflineVC(nibName: "OfflineVC", bundle: nil)
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                topVC.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // set login as rootviewcontroller
    func setLogin() {
        let vc = LoginVC.instantiate(storyBoard: .auth)
        let navController = UINavigationController(rootViewController: vc)
        coordinator = MainCoordinator(navigationController: navController)
        self.window = UIApplication.shared.windows.first
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
}
