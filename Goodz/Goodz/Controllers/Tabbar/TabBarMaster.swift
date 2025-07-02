//
//  TabBarMaster.swift
//
//
//
//  Copyright © 2022 All rights reserved.
//

import UIKit

fileprivate struct TabItemVC {
    
    var vc: UIViewController
    var title: String
    var selectedImage: String
    var normalImage: String
}

var lastSelTabIndex = 0

class TabBarMaster: UITabBarController, UIGestureRecognizerDelegate {
    
    fileprivate var arrTabItemVC: [TabItemVC] = []
    fileprivate var arrNavVC: [UIViewController] = []
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var selectedIndex: Int { // Mark 1
        
        didSet {
            guard let selectedViewController = viewControllers?[selectedIndex] else { return }
            
            selectedViewController.tabBarItem.setTitleTextAttributes([.font:  UIFont(name: FontName.regular.rawValue, size: 0)!], for: .normal)
            
        }
    }
    
    override var selectedViewController: UIViewController? { // Mark 2
        didSet {
            
            guard let viewControllers = viewControllers else { return }
            for viewController in viewControllers {
                if UserDefaults.isGuestUser {
//                    if selectedViewController is MyFavouriteVC || selectedViewController is SellVC || selectedViewController is ChatVC {
//                        UserDefaults.standard.clearUserDefaults()
//                        appDelegate.setLogin()
//                    }
                } else {
                        if viewController == selectedViewController {
                        viewController.tabBarItem.setTitleTextAttributes([.font:  UIFont(name: FontName.regular.rawValue, size: 0)!], for: .normal)
                        
                    } else {
                        viewController.tabBarItem.setTitleTextAttributes([.font:  UIFont(name: FontName.regular.rawValue, size: 0)!], for: .normal)
                        
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        self.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func addVC(vc: UIViewController, title: String, selectedImage: String, normalImage: String) {
        self.arrTabItemVC.append(TabItemVC(vc: vc, title: title, selectedImage: selectedImage, normalImage: normalImage))
    }
    
    public func getTabBar(selectedIndex: Int, selectedColor: UIColor, normalColor: UIColor) -> UITabBarController {
        self.tabBar.tintColor = selectedColor
        self.tabBar.unselectedItemTintColor = normalColor
       
        for tabItem in self.arrTabItemVC {
            self.arrNavVC.append(tabItem.vc)
        }
        
        self.viewControllers = self.arrNavVC
        let tabBar: UITabBar = self.tabBar
       
        for i in 0..<(tabBar.items ?? []).count {
            let tabBarItem: UITabBarItem = tabBar.items![i]
            let tab = self.arrTabItemVC[i]
                tabBarItem.selectedImage = UIImage(named: tab.selectedImage) ?? UIImage()
                tabBarItem.image = UIImage(named: tab.normalImage) ?? UIImage()
            tabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -13, right: 0)

//            tabBarItem.title = tab.title
            tabBarItem.setTitleTextAttributes([.font : UIFont(name: FontName.regular.rawValue, size: 12.0)!], for: .normal)
        }
        
        self.selectedIndex = selectedIndex
        
        self.tabBar.backgroundColor = .themeGreen
        self.tabBar.layer.borderWidth = 0.0
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowOpacity = 0.22
        self.tabBar.layer.shadowRadius = 10.0
        self.tabBar.layer.shadowPath = UIBezierPath(rect: self.tabBar.bounds).cgPath
        self.tabBar.layer.masksToBounds = false
        
        return self
    }
    
}

extension TabBarMaster: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let arrVC = tabBarController.viewControllers ?? []
        let selIndex = arrVC.firstIndex(of: viewController)!
        
        if UserDefaults.isGuestUser {
            if viewController is MyFavouriteVC || viewController is SellVC || viewController is ChatVC {
                UserDefaults.standard.clearUserDefaults()
                appDelegate.setLogin()
                return false
            }
        }
        if let onevc = viewController as? HomeVC {
            onevc.scrollToTop(animated: true)
        }else if let onevc = viewController as? MyFavouriteVC {
            onevc.scrollToTop(animated: true)
        } else if let onevc = viewController as? SellVC {
            onevc.scrollToTop(animated: true)
        } else if let onevc = viewController as? ChatVC {
            onevc.scrollToTop(animated: true)
            onevc.clearTextFields()
        } else if let onevc = viewController as? AccountVC {
            onevc.scrollToTop(animated: true)
        }
        clearTextFieldsInViewController(viewController)
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    private func clearTextFieldsInViewController(_ viewController: UIViewController) {
        if let textFieldsClearableVC = viewController as? TextFieldsClearable {
            textFieldsClearableVC.clearTextFields()
        }
    }
}

protocol TextFieldsClearable {
    func clearTextFields()
}

class TABBAR {
    
    static let shared = TABBAR()
    
    private init() {
        
    }
    
    func getTabBar(selectedIndex: Int = 0) -> UITabBarController {
        let tabbar = TabBarMaster()
        
        let home = AppStoryBoards.home.load.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let favourite = AppStoryBoards.favourite.load.instantiateViewController(withIdentifier: "MyFavouriteVC") as! MyFavouriteVC
        let sell = AppStoryBoards.sell.load.instantiateViewController(withIdentifier: "SellVC") as! SellVC
        let chat = AppStoryBoards.chat.load.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        let account = AppStoryBoards.myAccount.load.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        
        tabbar.addVC(vc: home, title: "", selectedImage: "black_home", normalImage: "gray_home")
        tabbar.addVC(vc: favourite, title: "", selectedImage: "black_heart", normalImage: "gray_heart")
        tabbar.addVC(vc: sell, title: "", selectedImage: "black_sell", normalImage: "gray_sell")
        tabbar.addVC(vc: chat, title: "", selectedImage: "black_mail", normalImage: "gray_mail")
        tabbar.addVC(vc: account, title: "", selectedImage: "black_profile", normalImage: "gray_profile")
        
        let tab = tabbar.getTabBar(selectedIndex: selectedIndex, selectedColor: .themeGreen, normalColor: .themeGray)
       
        return tab
    }
}
extension UIViewController {

  func scrollToTop(animated: Bool) {
    if let tv = self as? UITableViewController {
        tv.tableView.setContentOffset(CGPoint.zero, animated: animated)
    } else if let cv = self as? UICollectionViewController{
        cv.collectionView?.setContentOffset(CGPoint.zero, animated: animated)
    } else {
        for v in view.subviews {
            if let sv = v as? UIScrollView {
                sv.setContentOffset(CGPoint.zero, animated: animated)
            }
        }
    }
  }
}
