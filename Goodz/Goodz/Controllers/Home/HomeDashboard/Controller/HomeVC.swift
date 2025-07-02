//
//  HomeVC.swift
//  Goodz
//
//  Created by Priyanka on 11/12/23.
//

import Foundation
import UIKit


class HomeVC : BaseVC {
    /// An authentication context stored at class scope so it's available for use during UI updates.
  
    /// The available states of being logged in or not.
    
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var clvCategories: UICollectionView!
    @IBOutlet weak var clvBuySellFurniture: UICollectionView!
    @IBOutlet weak var clvMain: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var constMainclvHeight: NSLayoutConstraint!
    @IBOutlet weak var colStores: UICollectionView!
    @IBOutlet weak var constHeightColStore: NSLayoutConstraint!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrBuySellGoods: [BuySellFurnitureData] = BuySellFurnitureData.arrCategories()
    var viewModel : HomeVM? = HomeVM()
    var pageCat : Int = 1
    var pageStore : Int = 1
    // --------------------------------------------
    // MARK: - Deinit methods
    //
    deinit {
        self.clvMain.removeObserver(self, forKeyPath: "contentSize")
        self.colStores.removeObserver(self, forKeyPath: "contentSize")
    }
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.setUpdatePopup()
//        self.pageCat = 1
//        self.pageStore = 1
        self.homeAPI(isProfile: true)
        self.apiCategories()
       
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //viewModel = HomeVM()
       
        self.clvMain.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colStores.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.vwScroll.setContentOffset(.zero, animated: false)
        self.checkNotification()
        
    }
  /*  override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpdatePopup()
//        self.pageCat = 1
//        self.pageStore = 1
        self.homeAPI(isProfile: true)
        self.apiCategories()
        print("HomeVC")
        self.clvMain.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colStores.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.vwScroll.setContentOffset(.zero, animated: false)
        self.checkNotification()
        
    }*/
    
    func checkNotification() {
        
        if AppDelegate.dictNotificationData != nil {
            
            APP_DEL.managePushNavigation(dict: AppDelegate.dictNotificationData!)
        }
    }
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func setUpdatePopup() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let v = Int(version) ?? 0
            let v1 = Int(appUserDefaults.getValue(.appUpdateVersion) ?? "") ?? 0
            let isForce = appUserDefaults.getValue(.forceUpdate) ?? "0"
            if v < v1 {
                self.coordinator?.showChatPopUp(title: Labels.updateAvailable, description: Labels.aNewVerisonOfGoodzAppIsAvailable, type: (isForce == "1") ? .forceUpdate : .appUpadate ) { status in}
            }
        }
    }
    
    private func applyStyle() {
        self.headerView.addTapGesture {
            self.coordinator?.navigateToSearch()
        }
    }
    
    // --------------------------------------------
     
    func homeAPI(isProfile: Bool) {
        if isProfile {
            if !((appUserDefaults.getValue(.isGuestUser)) ?? false) && self.pageStore < 2 {
                GlobalRepo.shared.getProfileAPI { _, data, _ in
                    let hasExecutedProfileLogic = UserDefaults.profileCheckExecutedInSession
                    if !hasExecutedProfileLogic {
                        if let data = data?.first {
                            if data.userType == "0" && data.documentsSubmitted == "0" && data.bankAdded == 0{
                                UserDefaults.isDocumentsSubmitted = false
                                self.coordinator?.navigateToDocsPendingVC(fromSellVC: false)
                            } else if data.userType == "0" && data.documentsSubmitted == "1" && data.bankAdded == 1{
                                UserDefaults.isDocumentsSubmitted = true
                            }
                        }
                        UserDefaults.profileCheckExecutedInSession = true
                        
                    }
                }
            }
        }
        self.viewModel?.fetchHomeData(pageNo: self.pageStore) { [weak self] isDone in
            if isDone {
                guard let self = self else { return }
                if let data = self.viewModel?.arrHome.first {
                    self.arrBuySellGoods[1].background = data.buyBannerImg ?? ""
                    self.arrBuySellGoods[0].background = data.sellBannerImg ?? ""
                    DispatchQueue.main.async {
                        self.clvBuySellFurniture.reloadData()
                        self.clvMain.reloadData()
                        self.colStores.reloadData()
                    }
                    self.vwScroll.endRefreshing()
                }
            }
//            self.stopLoader()
            
        }
    }
    
    // --------------------------------------------
    
    func apiCategories() {
        self.viewModel?.fetchCategoryData(pageNo: self.pageCat) {[weak self] isDone in
            guard let self =  self else { return }
            if isDone {
                self.clvCategories.reloadData()
            }
        }
    }
    
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.registerCollection()
    }
    
    // --------------------------------------------
    
    func registerCollection() {
        self.clvCategories.delegate = self
        self.clvCategories.dataSource = self
        self.clvCategories.register(CategoryViewCell.nib, forCellWithReuseIdentifier: CategoryViewCell.reuseIdentifier)
        
        self.clvBuySellFurniture.delegate = self
        self.clvBuySellFurniture.dataSource = self
        self.clvBuySellFurniture.register(SellBuyFurnitureViewCell.nib, forCellWithReuseIdentifier: SellBuyFurnitureViewCell.reuseIdentifier)
        
        self.clvMain.delegate = self
        self.clvMain.dataSource = self
        self.clvMain.register(ProductViewCell.nib, forCellWithReuseIdentifier: ProductViewCell.reuseIdentifier)
        self.clvMain.register(AdvertiseCell.nib, forCellWithReuseIdentifier: AdvertiseCell.reuseIdentifier)
        self.clvMain.register(MarketingCell.nib, forCellWithReuseIdentifier: MarketingCell.reuseIdentifier)
        
        self.colStores.delegate = self
        self.colStores.dataSource = self
        self.colStores.register(ProductViewCell.nib, forCellWithReuseIdentifier: ProductViewCell.reuseIdentifier)
        self.clvMain.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        self.vwScroll.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.pageCat = 1
        self.pageStore = 1
        self.homeAPI(isProfile: true)
        self.apiCategories()
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let collectionView = object as? UICollectionView {
            if collectionView == self.clvMain {
                self.constMainclvHeight.constant = self.clvMain.contentSize.height
                view.layoutIfNeeded()
            } else if collectionView == self.colStores {
                self.constHeightColStore.constant = self.colStores.contentSize.height
                view.layoutIfNeeded()
            }
        }
        
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.clvMain.removeObserver(self, forKeyPath: "contentSize")
        self.colStores.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionCart(_ sender: Any) {
        
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            self.coordinator?.navigateToCart()
        }
    }
    
    // --------------------------------------------
    
}

class ScrollViewDelegateHandler: NSObject, UIScrollViewDelegate {
    
    static let shared = ScrollViewDelegateHandler()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.bounds.size.height
        
        if offsetY > contentHeight - screenHeight * 2 {
            // Trigger additional loading logic here
            // For example, load more data or trigger a pagination API call
        }
    }
}
