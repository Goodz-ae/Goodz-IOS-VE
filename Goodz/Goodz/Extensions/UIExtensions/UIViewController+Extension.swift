//
//  UIViewController+Extension.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit

extension UIViewController {
    static func load<T: UIViewController>() -> T {
        T(nibName: String(describing: T.self), bundle: nil)
    }
    
    class func loadController<T: UIViewController>(storyBoardName: String) -> T {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    func hideNavigationBar(shouldHide: Bool = true) {
        navigationController?.navigationBar.isHidden = shouldHide
    }
    
    func popToRootViewController() {
        AppDelegate.instance.applicationNavController.popToRootViewController(animated: true)
    }
    
    func popViewController(animate: Bool = false) {
        AppDelegate.instance.applicationNavController.popViewController(animated: animate)
    }
    
    func dissMissController(withCompletion: Bool = false, completion: (() -> Void)? = nil) {
        dismiss(animated: true) {
            if withCompletion { completion?() }
        }
    }
    
    func pushToViewController<T: UIViewController>(controller: T.Type) {
        let viewController = T(nibName: String(describing: T.self), bundle: nil)
        AppDelegate.instance.applicationNavController.pushViewController(viewController, animated: true)
    }
    
}

extension UIViewController {
    
    func push(_ controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
        //        AppDelegate.instance.applicationNavController.pushViewController(controller, animated: true)
    }
    
    func present(_ controller: UIViewController,_ animated: Bool = true) {
        present(controller , animated: animated, completion: nil)
    }
    
    func dismiss(_ animated: Bool = false) {
        dismiss(animated: animated, completion: nil)
    }
    
    func popTo(controller: UIViewController) {
        AppDelegate.instance.applicationNavController.popToViewController(controller, animated: true)
    }
    
    //    func gotoHome(_ message : String = Constants.EmptyString){
    //        RootControllers.shared.changeRootViewController(HomeViewController.getInstance(message), rootType: .home)
    //    }
    //
    //    func gotoLogin(){
    //        RootControllers.shared.changeRootViewController(SignInController.getInstance(), rootType: .login)
    //    }
    
}

extension UIViewController {
    
    /* To check if a view controller is presented modally or pushed
     onto a navigation controller stack */
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
}

// MARK: Header Extension
extension UIViewController {
    
//    func defineHeader(headerView: UIView, titleText: String, btnBackHidden: Bool = false, btnRightImage: UIImage? = nil, btnRightAction: ( () -> Void)? = nil) {
//
//        let header = Bundle.main.loadNibNamed("NavigationView", owner: nil, options: nil)?.first as? NavigationView
//        header?.currentViewController = self.navigationController ?? UINavigationController()
//
//        header?.lblTitle.text = titleText
//        header?.btnBack.isHidden = btnBackHidden
//
//        header?.btnRight.setImage(btnRightImage, for: .normal)
//
//        if let rightViewAction = btnRightAction {
//            header?.btnRight.addTarget(self, action: #selector(handleBtnGraphTap(_:)), for: .touchUpInside)
//            // Store the graph action closure in the button's tag
//            header?.btnRight.tag = 1
//            // Associate the closure with the view controller
//            objc_setAssociatedObject(self, &AssociatedKeys.graphActionClosure, rightViewAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//
//        headerView.addSubview(header ?? UIView())
//        header?.translatesAutoresizingMaskIntoConstraints = false
//        header?.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
//        header?.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
//        header?.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
//        header?.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
//
//    }
    
    @objc private func handleBtnGraphTap(_ sender: UIButton) {
        if sender.tag == 1 {
            // Retrieve the associated closure and invoke it
            if let graphAction = objc_getAssociatedObject(self, &AssociatedKeys.graphActionClosure) as? () -> Void {
                graphAction()
            }
        }
    }
    private struct AssociatedKeys {
        static var graphActionClosure = "graphActionClosure"
    }
}
