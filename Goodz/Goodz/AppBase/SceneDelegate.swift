//
//  SceneDelegate.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//

import UIKit
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
        
        if let urlContext = connectionOptions.urlContexts.first {
            self.scene(scene, openURLContexts: Set([urlContext]))
        }
        
        if let response = connectionOptions.notificationResponse {
            
            AppDelegate.dictNotificationData = response.notification.request.content.userInfo as NSDictionary
        }
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //MARK:- PLEASE DO NOT REMOVE FOR IOS 13.0, ITS REFERENCE WINDOW FOR SCENE DELEGATE
        APP_DEL.window = self.window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
         
            FaceIDManager.shared.facIDVerify()
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
     /*   let isBio = UserDefaults.isBiometricOn
        if isBio {
            appUserDefaults.set(false, forKey: Labels.HasAuthenticatedWithFaceID)
        }*/
    }
}

extension SceneDelegate {
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamiclink, error) in
                guard error == nil else {
                    print("Error handling dynamic link: \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamiclink {
                    (UIApplication.shared.delegate as? AppDelegate)?.handleDynamicLink(dynamicLink)
                }
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        DynamicLinks.dynamicLinks().handleUniversalLink(url) { (dynamiclink, error) in
            guard error == nil else {
                print("Error handling dynamic link: \(error!.localizedDescription)")
                return
            }
            if let dynamicLink = dynamiclink {
                (UIApplication.shared.delegate as? AppDelegate)?.handleDynamicLink(dynamicLink)
            }
        }
    }
}
