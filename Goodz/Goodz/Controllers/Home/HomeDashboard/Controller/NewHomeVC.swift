//
//  NewHomeVC.swift
//  Goodz
//
//  Created by on 26/03/25.
//

import UIKit

class NewHomeVC: BaseVC {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var vwScroll: UIScrollView!
    
    @IBOutlet weak var clvCategories: UICollectionView!
    @IBOutlet weak var feelGoodzTitleLbl: UILabel!
    @IBOutlet weak var buySellDescLbl: UILabel!
    
    @IBOutlet weak var buySellBackView: UIView!
    
    @IBOutlet weak var buyBackView: UIView!
    @IBOutlet weak var buyBackViewImage: UIImageView!
    @IBOutlet weak var buyTitleLbl: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    
    @IBOutlet weak var sellBackView: UIView!
    @IBOutlet weak var sellBackViewImage: UIImageView!
    @IBOutlet weak var sellTitleLbl: UILabel!
    @IBOutlet weak var sellBtn: UIButton!
    
    @IBOutlet weak var goodzDealLbl: UILabel!
    
    @IBOutlet weak var clvMain: UICollectionView!
    @IBOutlet weak var constMainclvHeight: NSLayoutConstraint!
    
    @IBOutlet weak var somethingSpecialTitleLbl: UILabel!
    @IBOutlet weak var somethingSpecialDescLbl: UILabel!
    
    @IBOutlet weak var yourCustomLbl: UILabel!
    @IBOutlet weak var selectionLbl: UILabel!
    @IBOutlet weak var foraGoodzxLbl: UILabel!
    @IBOutlet weak var customSelectionViewMoreBtn: UIButton!
    @IBOutlet weak var constCustomSelectionClvHeight: NSLayoutConstraint!
    @IBOutlet weak var clvCustomSelection: UICollectionView!
    
    @IBOutlet weak var ourSelectionLbl: UILabel!
    @IBOutlet weak var goodzItemLbl: UILabel!
    @IBOutlet weak var toMakeJealousLbl: UILabel!
    @IBOutlet weak var ourSelectionViewMoreBtn: UIButton!
    @IBOutlet weak var clvOurSelection: UICollectionView!
    @IBOutlet weak var constOurSelectionclvHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constPopularStoresViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popularStoresLbl: UILabel!
    @IBOutlet weak var popularViewMoreBtn: UIButton!
    @IBOutlet weak var clvPopularStores: UICollectionView!
    @IBOutlet weak var constPopularStoresclvHeight: NSLayoutConstraint!
    
    @IBOutlet weak var littleGestureLbl: UILabel!
    @IBOutlet weak var buyYouFurnitureLbl: UILabel!
    @IBOutlet weak var woodSaveLbl: UILabel!
    @IBOutlet weak var howMuchKGLbl: UILabel!
    @IBOutlet weak var learnMoreBtn: UIButton!
    
    @IBOutlet weak var latestArrivalsLbl: UILabel!
    @IBOutlet weak var latestArrivalsViewMoreBtn: UIButton!
    @IBOutlet weak var clvLatestArrivals: UICollectionView!
    @IBOutlet weak var constLatestArrivalsClvHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loadMoreBtn: UIButton!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : HomeVM? = HomeVM()
    var pageCat : Int = 1
    var pageStore : Int = 1
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpUI()
        self.homeAPI(isProfile: true)
        self.apiCategories()
    }
    
    //MARK: - UI Setup Functions
    private func setUpUI() {
        self.applyStyle()	    
        self.registerCollection()
        loadMoreBtn.isHidden = false
        setCollcectionViewHeight()
    }
    
    private func applyStyle() {
        self.headerView.addTapGesture {
            self.coordinator?.navigateToSearch()
        }
        
        self.buyBackView.addTapGesture {
            self.coordinator?.navigateToProductList(title: Labels.products)
        }
        
        self.sellBackView.addTapGesture {
            if UserDefaults.isGuestUser {
                appDelegate.setLogin()
            } else {
                self.coordinator?.setTabbar(selectedIndex: 2)
            }
        }
        
        let fullText = "View More >"
        let viewMoreAttributedString = NSMutableAttributedString(string: fullText)

        // Apply underline only to "View More"
        let range = (fullText as NSString).range(of: "View More")
        viewMoreAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        self.buyBackView.cornerRadius = 8
        self.sellBackView.cornerRadius = 8
        
        self.feelGoodzTitleLbl.font(font: .bold, size: .size32)
        self.buySellDescLbl.font(font: .regular, size: .size16)
        
        self.buyTitleLbl.font(font: .bold, size: .size24)
        self.buyBtn.font(font: .semibold, size: .size16)
        self.sellTitleLbl.font(font: .bold, size: .size24)
        self.sellBtn.font(font: .semibold, size: .size16)
        
        self.goodzDealLbl.font(font: .semibold, size: .size24)
        
        self.somethingSpecialTitleLbl.font(font: .bold, size: .size28)
        self.somethingSpecialDescLbl.font(font: .regular, size: .size16)
        
        self.yourCustomLbl.font(font: .bold, size: .size16)
        self.selectionLbl.font(font: .bold, size: .size24)
        self.foraGoodzxLbl.font(font: .bold, size: .size16)
        self.customSelectionViewMoreBtn.font(font: .semibold, size: .size13)
        self.customSelectionViewMoreBtn.setAttributedTitle(viewMoreAttributedString, for: .normal)
        
        self.ourSelectionLbl.font(font: .bold, size: .size16)
        self.goodzItemLbl.font(font: .bold, size: .size24)
        self.toMakeJealousLbl.font(font: .bold, size: .size16)
        self.ourSelectionViewMoreBtn.font(font: .semibold, size: .size13)
        self.ourSelectionViewMoreBtn.setAttributedTitle(viewMoreAttributedString, for: .normal)
        
        self.popularStoresLbl.font(font: .semibold, size: .size24)
        self.popularViewMoreBtn.font(font: .regular, size: .size14)
        self.popularViewMoreBtn.setAttributedTitle(viewMoreAttributedString, for: .normal)
        
        self.littleGestureLbl.font(font: .regular, size: .size14)
        self.buyYouFurnitureLbl.font(font: .bold, size: .size24)
        self.woodSaveLbl.font(font: .regular, size: .size14)
        self.howMuchKGLbl.font(font: .bold, size: .size24)
        self.learnMoreBtn.font(font: .medium, size: .size16)
        
        self.latestArrivalsLbl.font(font: .semibold, size: .size24)
        self.latestArrivalsViewMoreBtn.font(font: .regular, size: .size14)
        self.latestArrivalsViewMoreBtn.setAttributedTitle(viewMoreAttributedString, for: .normal)
        
        self.loadMoreBtn.font(font: .semibold, size: .size16)
        self.constMainclvHeight.constant = 670
        self.constCustomSelectionClvHeight.constant = 440
        self.constOurSelectionclvHeight.constant = 440
        self.constLatestArrivalsClvHeight.constant = 660
        self.constPopularStoresViewHeight.constant = 0
    }
    
    func registerCollection() {
        self.clvCategories.delegate = self
        self.clvCategories.dataSource = self
        self.clvCategories.register(CategoryViewCell.nib, forCellWithReuseIdentifier: CategoryViewCell.reuseIdentifier)
        
        self.clvMain.delegate = self
        self.clvMain.dataSource = self
        self.clvMain.register(NewHomeProductCVC.nib, forCellWithReuseIdentifier: NewHomeProductCVC.reuseIdentifier)
        
        self.clvCustomSelection.delegate = self
        self.clvCustomSelection.dataSource = self
        self.clvCustomSelection.register(NewHomeProductCVC.nib, forCellWithReuseIdentifier: NewHomeProductCVC.reuseIdentifier)
        
        self.clvOurSelection.delegate = self
        self.clvOurSelection.dataSource = self
        self.clvOurSelection.register(NewHomeProductCVC.nib, forCellWithReuseIdentifier: NewHomeProductCVC.reuseIdentifier)
        
        self.clvPopularStores.delegate = self
        self.clvPopularStores.dataSource = self
        self.clvPopularStores.register(NewPopularStoresCVC.nib, forCellWithReuseIdentifier: NewPopularStoresCVC.reuseIdentifier)
        
        self.clvLatestArrivals.delegate = self
        self.clvLatestArrivals.dataSource = self
        self.clvLatestArrivals.register(NewHomeProductCVC.nib, forCellWithReuseIdentifier: NewHomeProductCVC.reuseIdentifier)
        
        self.vwScroll.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    //MARK: - API Callings
    
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
                    DispatchQueue.main.async {
                       
                        self.setCollcectionViewHeight()
                    }
                    self.vwScroll.endRefreshing()
                }
            }
        }
    }
    
    func setCollcectionViewHeight(){
        set_sell_buy_banner()
        
        let stores = Double((self.viewModel?.numberOfStore() ?? 0) >= 2 ? 2 : (self.viewModel?.numberOfStore() ?? 0))
        if stores > 0 {
            self.constPopularStoresViewHeight.constant = 70
        } else {
            self.constPopularStoresViewHeight.constant = 0
        }
        let noOfStores = (stores * 332.5)
        print("Number of Stores are:", noOfStores)
        self.constPopularStoresclvHeight.constant = noOfStores
        
      //  self.constMainclvHeight.constant = 670
        self.goodzDealLbl.isHidden = false
        if (self.viewModel?.goodzDealProductsArr.count ?? 0) > 4 {
            self.constMainclvHeight.constant = 670
        } else if (self.viewModel?.goodzDealProductsArr.count ?? 0) > 2 {
            self.constMainclvHeight.constant = 330
        } else if (self.viewModel?.goodzDealProductsArr.count ?? 0) > 0 {
            self.constMainclvHeight.constant = 220
        } else {
            self.goodzDealLbl.isHidden = true
            self.constMainclvHeight.constant = 0
        }
        
        if (self.viewModel?.customSelectionArr.count ?? 0) > 2 {
            self.constCustomSelectionClvHeight.constant = 440
        }else if (self.viewModel?.customSelectionArr.count ?? 0) > 0 {
            self.constCustomSelectionClvHeight.constant = 220
        } else {
            self.constCustomSelectionClvHeight.constant = 0
        }
        
        if (self.viewModel?.ourSelectionArr.count ?? 0) > 2 {
            self.constOurSelectionclvHeight.constant = 440
        }else if (self.viewModel?.ourSelectionArr.count ?? 0) > 0 {
            self.constOurSelectionclvHeight.constant = 220
        } else {
            self.constOurSelectionclvHeight.constant = 0
        }
        
        
        //self.constOurSelectionclvHeight.constant = 440
        self.constLatestArrivalsClvHeight.constant = 660
        
        self.clvMain.reloadData()
        self.clvCustomSelection.reloadData()
        self.clvOurSelection.reloadData()
        self.clvLatestArrivals.reloadData()
        self.clvPopularStores.reloadData()
    }
    
    func set_sell_buy_banner() {
        
        if let dic = self.viewModel?.arrHome.first {
            
            if let url = URL(string: dic.sellBannerImg ?? "") {
                self.sellBackViewImage.sd_setImage(with: url, placeholderImage: .product)
                self.sellBackViewImage.contentMode = .scaleAspectFill
            } else {
                self.sellBackViewImage.image = .product
            }
            if let url = URL(string: dic.buyBannerImg ?? "") {
                self.buyBackViewImage.sd_setImage(with: url, placeholderImage: .product)
                self.buyBackViewImage.contentMode = .scaleAspectFill
            } else {
                self.buyBackViewImage.image = .product
            }
        }
    }
    
    // --------------------------------------------
    
    func apiCategories() {
        //self.viewModel?.createSideMenu()
        self.viewModel?.fetchCategoryData(pageNo: self.pageCat) {[weak self] isDone in
            guard let self =  self else { return }
            if isDone {
                self.clvCategories.reloadData()
                
            }
        }
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.pageCat    =   1
        self.pageStore  =   1
//        self.homeAPI(isProfile: true)
        self.apiCategories()
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let collectionView = object as? UICollectionView {
            if collectionView == self.clvMain {
                self.constMainclvHeight.constant = 470
                self.view.layoutIfNeeded()
            }else if collectionView == self.clvCustomSelection {
                self.constCustomSelectionClvHeight.constant = 470
                self.view.layoutIfNeeded()
            } else if collectionView == self.clvOurSelection {
                self.constOurSelectionclvHeight.constant = 470
                self.view.layoutIfNeeded()
            } else if collectionView == self.clvPopularStores {
                self.constPopularStoresclvHeight.constant = 570
                self.view.layoutIfNeeded()
            } else if collectionView == self.clvLatestArrivals {
                self.constLatestArrivalsClvHeight.constant = 470
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // ---------------------------------------------
    
    //MARK: - BtnActions
    @IBAction func actionCart(_ sender: Any) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            self.coordinator?.navigateToCart()
        }
    }
    
    @IBAction func loadMoreLatestArrival(_ sender : UIButton!){
        viewModel?.latestArrivalLoadCount += 4
        
        if (viewModel?.latestArrivalsProductsArr.count ?? 0 ) <= (viewModel?.latestArrivalLoadCount ?? 0) {
            viewModel?.latestArrivalLoadCount = viewModel?.latestArrivalsProductsArr.count ?? 0
            loadMoreBtn.isHidden = true
        }
        //self.constLatestArrivalsClvHeight.constant -=   self.constLatestArrivalsClvHeight.constant
        self.constLatestArrivalsClvHeight.constant = CGFloat(220 * Int(Int( viewModel?.latestArrivalLoadCount ?? 0)/2))
        clvLatestArrivals.reloadData()
    }
    
    
    
    @IBAction func viewMoreBtnActions(_ sender: UIButton) {
        
        if let data = self.viewModel?.arrHome.first {
            if sender == self.popularViewMoreBtn {
                print("Popular store view more button clicked.")
                self.coordinator?.navigateToPopularStoreVC()
            } else if sender == self.ourSelectionViewMoreBtn {
                print("Our selection view more button clicked.")
            } else if sender == self.customSelectionViewMoreBtn {
                print("Custom selection view more button clicked.")
            } else if sender == self.latestArrivalsViewMoreBtn {
                if (viewModel?.arrHome.first?.result?.count ?? 0) > 5 {
                    let dic = viewModel?.arrHome.first?.result?[5]
                    self.coordinator?.navigateToProductList(title: dic?.title ?? "", latestArrivalArr: dic?.latest_arrivals ?? [] , islatest : true )
                }
                
                print("Latest arrivals view more button clicked.")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
