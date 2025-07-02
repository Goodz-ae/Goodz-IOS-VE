//
//  StoreVC.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import Foundation
import UIKit

class StoreVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var btnMystore: ThemeBlackGrayButton!
    @IBOutlet weak var btnReview: ThemeBlackGrayButton!
    @IBOutlet weak var btnFollowers: ThemeBlackGrayButton!
    
    // firstview
    @IBOutlet weak var vwMainMystore: UIView!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var vwMystore: UIView!
    @IBOutlet weak var imgStore: ThemeGreenBorderImage!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgSellerPro: UIImageView!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var isProImgV : UIImageView!
    
    @IBOutlet weak var vwBoost: UIView!
    @IBOutlet weak var imgBoost: UIImageView!
    @IBOutlet weak var lblBoostTitle: UILabel!
    @IBOutlet weak var lblBoostDes: UILabel!
    @IBOutlet weak var btnBoost: UIButton!
    
    @IBOutlet weak var vwHighlight: UIView!
    @IBOutlet weak var imgHighlight: UIImageView!
    @IBOutlet weak var lblHighlightTitle: UILabel!
    @IBOutlet weak var lblHighlightDes: UILabel!
    @IBOutlet weak var btnHighlight: UIButton!
    
    @IBOutlet weak var colProducts: UICollectionView!
    @IBOutlet weak var constHightCollection: NSLayoutConstraint!
    
    // Second view
    @IBOutlet weak var vwMainTbl: UIView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    // sellers and buyer
    @IBOutlet weak var vwBoostInfo: UIStackView!
    @IBOutlet weak var vwButtons: UIStackView!
    @IBOutlet weak var btnMessage: SmallGreenBorderButton!
    @IBOutlet weak var btnFollow: SmallGreenButton!
    @IBOutlet weak var vwBundle: UIStackView!
    @IBOutlet weak var lblBundle: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var btnBuy: SmallGreenButton!
    @IBOutlet weak var lblTotalItmes: UILabel!
    
    @IBOutlet weak var vwReview: UIView!
    @IBOutlet weak var btnTotalRate: UIButton!
    @IBOutlet weak var lblTotalReview: UILabel!
    @IBOutlet weak var btnSort: SmallGreenButton!
    
    @IBOutlet weak var svMyStore: UIStackView!
    @IBOutlet weak var btnSell: ThemeGreenButton!
    
    @IBOutlet weak var vwRating: UIStackView!
    @IBOutlet weak var vwAddress: UIStackView!
    @IBOutlet weak var vwItemCount: UIStackView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : StoreVM = StoreVM()
    var states = [Bool]()
    var openType : OrderDetials = .myOrderList
    var page : Int = 1
    var pageReview : Int = 1
    var pageFollow : Int = 1
    var storeId : String = ""
    var arrSort : [SortModel] = []
    var strSearch : String = ""
    var isMyStore : Bool = false
    var viewModelMakeAnOffer : MakeAnOfferVM = MakeAnOfferVM()
    var isReview : Bool = false

    var sortID : String = ""
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.page = 1
        self.pageReview = 1
        self.pageFollow = 1
        self.setStyle()
        self.imgStore.image = .avatarStore
        self.apiCalling()
        self.isReview ? self.apiReviewData() : self.apiStoreDetials()
        self.setTopButtons()
        self.colProducts.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
        
    }
    
    // --------------------------------------------
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tblSearch.reloadData()
    }
    
    // --------------------------------------------
    
    func featchData() {
        self.setUp()
        self.apiCalling()
        self.apiStoreDetials()
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.colProducts.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    func setStyle() {
        self.btnMystore.isSelected = true
        self.btnFollowers.isSelected = false
        self.btnReview.isSelected = false
        self.setMystoreView()
        let isMyOrderList = (self.openType == .myOrderList)
        
        self.vwBundle.isHidden = true
        self.vwButtons.isHidden = isMyOrderList
        self.vwBoostInfo.isHidden = true
        
        self.btnMystore.setTitle(isMyOrderList ? Labels.myStore : Labels.store, for: .normal)
        if self.isReview {
            self.btnMystore.isSelected = false
            self.btnReview.isSelected = true
            self.btnFollowers.isSelected = false
            self.btnSell.isHidden = true
            self.pageReview = 1
            self.apiReviewData()
            self.setTopButtons()
        }
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.vwBoost.border(borderWidth: 1, borderColor: .themeGreen)
        self.vwBoost.cornerRadius(cornerRadius: 4.0)
        
        self.vwHighlight.border(borderWidth: 1, borderColor: .themeGreen)
        self.vwHighlight.cornerRadius(cornerRadius: 4.0)

        
        self.btnReview.setTitle(Labels.reviews, for: .normal)
        self.btnFollowers.setTitle(Labels.followers, for: .normal)
        self.txtSearch.placeholder = Labels.searchFollowers
        self.lblBoostTitle.text = Labels.boostNowYourProduct
        self.lblBoostDes.text = Labels.promoteYourProductAndSellFaster
        self.lblHighlightTitle.text = Labels.highlightYourStore
        self.lblHighlightDes.text = Labels.getRidOfAllYourItemQuickly
        self.imgStore.image = .icongoodz
        self.vwBoostInfo.isHidden = true
        self.vwBoost.addTapGesture {
            self.coordinator?.navigateToMyAds()
        }
        self.vwHighlight.addTapGesture {
            self.coordinator?.navigateToMyAds(store: true)
        }
    }
    
    // --------------------------------------------
    
    func setTableStyle() {
        // search
        
        self.tblSearch.cornerRadius(cornerRadius: 4.0)
        let nibReview = UINib(nibName: "ReviewCell", bundle: nil)
        self.tblSearch.register(nibReview, forCellReuseIdentifier: "ReviewCell")
        
        let nib = UINib(nibName: "FollowerCell", bundle: nil)
        self.tblSearch.register(nib, forCellReuseIdentifier: "FollowerCell")
        
        self.tblSearch.delegate = self
        self.tblSearch.dataSource = self
        self.tblSearch.addRefreshControl(target: self, action: #selector(refreshData))
        self.vwScroll.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    
    // --------------------------------------------
    
    @objc func refreshData() {
        if self.btnMystore.isSelected {
            self.page = 1
            self.apiStoreDetials()
        } else if self.btnReview.isSelected {
            self.pageReview = 1
            self.apiReviewData()
        } else if self.btnFollowers.isSelected {
            self.pageReview = 1
            self.apiFollowData()
        }
        
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UICollectionView,
           obj1 == self.colProducts && keyPath == "contentSize" {
            if self.viewModel.numberOfProducts() > 0 {
                self.constHightCollection.constant = self.colProducts.contentSize.height
            } else {
                self.constHightCollection.constant = screenHeight * 0.3
            }
            
        }
        
    }
    
    // --------------------------------------------
    
    func setMystoreView() {
        // my store view
        self.vwMystore.cornerRadius(cornerRadius: 4.0)
        
        self.lblName.font(font: .semibold, size: .size18)
        self.lblName.color(color: .themeBlack)
        
        self.btnRate.font(font: .medium, size: .size12)
        self.btnRate.color(color: .themeBlack)
        self.btnRate.cornerRadius(cornerRadius: 2.0)
        
        self.lblItem.font(font: .medium, size: .size12)
        self.lblItem.color(color: .themeGray)
        
        self.lblLocation.font(font: .medium, size: .size12)
        self.lblLocation.color(color: .themeBlack)
        
        self.lblDescription.font(font: .regular, size: .size12)
        self.lblDescription.color(color: .themeGray)
        
        // boost view
        self.vwBoost.cornerRadius(cornerRadius: 4)
        
        self.lblBoostTitle.font(font: .semibold, size: .size14)
        self.lblBoostTitle.color(color: .themeBlack)
        
        self.lblBoostDes.font(font: .regular, size: .size12)
        self.lblBoostDes.color(color: .themeDarkGray)
        
        // hightlight view
        
        self.vwHighlight.cornerRadius(cornerRadius: 4)
        
        self.lblHighlightTitle.font(font: .semibold, size: .size14)
        self.lblHighlightTitle.color(color: .themeBlack)
        
        self.lblHighlightDes.font(font: .regular, size: .size12)
        self.lblHighlightDes.color(color: .themeDarkGray)
        
        // colloection view
        self.colProducts.cornerRadius(cornerRadius: 4.0)
        
        let nib = UINib(nibName: "MyProductCell", bundle: nil)
        self.colProducts.register(nib, forCellWithReuseIdentifier: "MyProductCell")
        self.colProducts.delegate = self
        self.colProducts.dataSource = self
        
        self.lblBundle.font(font: .semibold, size: .size16)
        self.lblBundle.color(color: .themeBlack)
        self.lblDiscount.font(font: .regular, size: .size12)
        self.lblDiscount.color(color: .themeDarkGray)
        self.lblTotalItmes.font(font: .medium, size: .size14)
        self.lblTotalItmes.color(color: .themeBlack)
        
        self.lblTotalReview.font(font: .regular, size: .size12)
        self.lblTotalReview.color(color: .themeGray)
        self.btnTotalRate.font(font: .medium, size: .size20)
        self.btnTotalRate.color(color: .themeBlack)
        self.btnTotalRate.cornerRadius(cornerRadius: 4.0)
        
        self.btnFollow.cornerRadius(cornerRadius: 4.0)
        self.btnFollow.border(borderWidth: 1.0, borderColor: .themeGreen)
        self.btnSort.addTapGesture {
            self.coordinator?.presentSort(data: self.arrSort, completion: { data in
                self.btnSort.setTitle(data.sortTitle, for: .normal)

                self.sortID = data.sortId ?? ""
                self.apiReviewData()
            })
        }
        self.btnSort.isHidden = true
        self.txtSearch.delegate = self
        self.txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.vwMainMystore.isHidden = true
        self.btnSell.isHidden = true
        self.imgSellerPro.isHidden = true
    }
    
    // --------------------------------------------
    
    func setTopButtons() {
        DispatchQueue.main.async {
            self.btnSort.cornerRadius(cornerRadius: self.btnSort.frame.height / 2)
            if self.btnMystore.isSelected {
              //  self.vwMainMystore.isHidden = false
                self.vwMainTbl.isHidden = true
            } else {
                self.vwMainMystore.isHidden = true
                self.vwMainTbl.isHidden = false
            }
            if self.openType == .sellerBuyList {
                self.btnEdit.isHidden = true
                if self.btnReview.isSelected {
                    self.vwReview.isHidden = true
                } else {
                    self.vwReview.isHidden = true
                }
            } else {
                self.vwReview.isHidden = true
            }
            
            // self.btnSort.isHidden = !self.btnReview.isSelected
            self.btnReview.addBottomBorderWithColor(color: self.btnReview.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.btnMystore.addBottomBorderWithColor(color: self.btnMystore.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.btnFollowers.addBottomBorderWithColor(color: self.btnFollowers.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.vwSearch.isHidden =  true
            self.vwSearch.isHidden = true
            self.constHightCollection.constant = 0
            self.colProducts.reloadData()
            self.tblSearch.reloadData()
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = self.viewModel.arrStoreDetails.first?.storeOwnerName ?? ""
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.arrSort = [
            SortModel(sortTitle: "Sort by: Newest First", sortId: "2"),
            SortModel(sortTitle: "Sort by: Oldest First", sortId: "1")
        ]
        self.sortID = self.arrSort.first?.sortId ?? ""
//        GlobalRepo.shared.sortListAPI(.review) { status, data, error in
//            if status, let lists = data {
//                self.arrSort = lists
                self.btnSort.setTitle(self.arrSort.first?.sortTitle ?? "", for: .normal)
//            }
//        }

    }
    
    // --------------------------------------------
    
    func apiStoreDetials() {
        if self.openType == .myOrderList {
            self.viewModel.myStoreDetailsData(pageNo: self.page, storeId: self.storeId) { isDone in
                if isDone {

                    if self.viewModel.numberOfProducts() == 0 {
                        self.setNoData(scrollView: self.colProducts, noDataType: .nothingHere)
                        self.colProducts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                        self.vwBoostInfo.isHidden = true
                        self.btnSell.isHidden = false
                    } else {
                        self.vwBoostInfo.isHidden = false
                        self.btnSell.isHidden = true
                    }
                    self.vwMainMystore.isHidden = false
                    self.setMyStoreAPIData()
                    self.colProducts.reloadData()
                    self.vwScroll.endRefreshing()
                } else {
                    self.btnSell.isHidden = false
                    self.vwBoostInfo.isHidden = true
                    self.setNoData(scrollView: self.colProducts, noDataType: .nothingHere)
                    self.colProducts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                }
            }
        } else {
            self.viewModel.fetchData(pageNo: self.page, storeId: self.storeId) { isDone in
                if isDone {

                    if self.viewModel.numberOfProducts() == 0 {
                        self.setNoData(scrollView: self.colProducts, noDataType: .nothingHere)
                        self.colProducts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                        self.vwBundle.isHidden = true
                    } else {
                        self.vwBundle.isHidden = self.viewModel.numberOfProducts() < 2
                    }
                    self.vwMainMystore.isHidden = false
                    self.setOtherStoreAPIData()
                    self.colProducts.reloadData()
                    self.vwScroll.endRefreshing()
                } else {
                    self.vwBundle.isHidden = true
                    self.setNoData(scrollView: self.colProducts, noDataType: .nothingHere)
                    self.colProducts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                }
            }
        }
    }
    
    // --------------------------------------------
    
    func apiReviewData() {
       

            self.viewModel.fetchReviewsData(sortId: self.sortID, pageNo: self.pageReview, storeId: self.storeId) { isDone in
                if isDone {
                    
                    if self.viewModel.numberOfReviews() == 0 {
                        self.btnSort.isHidden = true
                        self.setNoData(scrollView: self.tblSearch, noDataType: .noReview)
                        self.vwReview.isHidden = true
                        self.tblSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                    } else {
                       // self.apiCalling()
                        self.vwReview.isHidden = false
                        self.btnSort.isHidden = false
                        self.states = [Bool](repeating: true, count: self.viewModel.numberOfReviews())
                        self.tblSearch.estimatedRowHeight = 100
                        self.tblSearch.rowHeight = UITableView.automaticDimension
                    }
                    let str = self.viewModel.numberOfReviews() > 1 ? Labels.reviews : Labels.review
                    self.lblTotalReview.text = "( " + (self.viewModel.numberOfReviews().description) + " " + str + ")"
                    DispatchQueue.main.async {
                        self.tblSearch.reloadData()
                        self.tblSearch.endRefreshing()
                    }
                } else if !isDone || self.viewModel.numberOfReviews() == 0 {
                    self.btnSort.isHidden = true
                    self.setNoData(scrollView: self.tblSearch, noDataType: .noReview)
                    self.vwReview.isHidden = true
                    self.tblSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                    self.tblSearch.reloadData()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tblSearch.reloadData()
                    self.tblSearch.endRefreshing()
                }
            }
        
    }
    
    // --------------------------------------------
    
    func apiFollowData() {
        DispatchQueue.main.async {
            self.viewModel.fetchFollowersData(search: self.strSearch, pageNo: self.pageFollow, storeId: self.storeId) { isDone in
                if isDone {
                    if self.viewModel.numberOfFollower() == 0 {
                        self.setNoData(scrollView: self.tblSearch, noDataType: .noFollowers)
                        if self.strSearch.isEmpty {
                            self.vwSearch.isHidden = true
                        }
                        self.tblSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                        self.tblSearch.reloadData()
                    } else {
                        self.vwSearch.isHidden = false
                    }
                    self.tblSearch.reloadData()
                } else if !isDone {
                    self.setNoData(scrollView: self.tblSearch, noDataType: .noFollowers)
                    if self.strSearch.isEmpty {
                        self.vwSearch.isHidden = true
                    }
                    self.tblSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                    self.tblSearch.reloadData()
                }
                self.tblSearch.endRefreshing()
            }
        }
    }
    
    // --------------------------------------------
    
    func setOtherStoreAPIData() {
        
        let data = self.viewModel.arrStoreDetails.first
        
        if (data?.productList?.count ?? 0) > 0 {
            vwRating.isHidden = false
        }else{
            vwRating.isHidden = true
        }
        
        if (data?.highestDiscount ?? "").isEmpty || data?.highestDiscount == "0" {
            self.lblDiscount.text = ""
        } else {
            let dis = data?.highestDiscount
            self.lblDiscount.text = Labels.getUpTo +  " " + (dis ?? "") + "% " + Labels.off
        }
        self.imgSellerPro.isHidden = data?.isGoodzPro != "2"
        self.appTopView.textTitle = data?.storeOwnerName ?? ""
        if let img = data?.storeImage, let url = URL(string: img) {
            self.imgStore.sd_setImage(with: url, placeholderImage: .avatarStore)
            self.imgStore.contentMode = .scaleAspectFill
        } else {
            self.imgStore.image = .avatarStore
        }
        if let isFollow = data?.isFollow {
            self.btnFollow.backgroundColor = isFollow == Status.one.rawValue ? .themeWhite  : .themeGreen
            self.btnFollow.setTitle(isFollow == Status.one.rawValue ? Labels.following : Labels.follow, for: .normal)
        }
        self.lblName.text = data?.storeOwnerName ?? ""
        if (data?.storeRating ?? "").isEmpty {
            self.btnRate.setTitle(Status.five.rawValue, for: .normal)
            self.btnTotalRate.setTitle(Status.five.rawValue, for: .normal)
        } else {
            self.btnRate.setTitle(data?.storeRating ?? Status.five.rawValue, for: .normal)
            self.btnTotalRate.setTitle(data?.storeRating ?? Status.five.rawValue, for: .normal)
        }
        
        if let count = data?.productList?.count {
            if count > 0 {
                vwItemCount.isHidden = false
                self.lblTotalItmes.text = "\(count) " + (count > 1 ? Labels.items : Labels.item)
            }else{
                vwItemCount.isHidden = true
            }
        }else{
            vwItemCount.isHidden = true
        }
        
        if (data?.numberOfReviews ?? "").isEmpty || (data?.numberOfReviews ?? "") == "0" {
            self.lblItem.text = ""
        } else {
            let rev = Int(data?.numberOfReviews ?? "0") ?? 0 < 2 ? Labels.review : Labels.reviews
            self.lblItem.text = "(\(data?.numberOfReviews ?? "") " + rev + ")"
        }
        
        isProImgV.isHidden = data?.isGoodzPro == "2" ? false : true
        
        self.lblDescription.text = data?.storeDescription
        self.lblDescription.numberOfLines = 3
        self.lblLocation.numberOfLines = 0
        var location : String = ""
        if (data?.areaTitle ?? "").isEmpty {
            location = (data?.cityTitle ?? "")
        } else if (data?.cityTitle ?? "").isEmpty {
            location = (data?.areaTitle ?? "")
        } else if !(data?.cityTitle ?? "").isEmpty && !(data?.areaTitle ?? "").isEmpty{
            location = (data?.areaTitle ?? "") + ", " + (data?.cityTitle ?? "")
        } else {
            location = ""
        }
        self.lblLocation.text = location
        
        self.btnFollow.addTapGesture {
            if appUserDefaults.getValue(.isGuestUser) ?? false {
                UserDefaults.standard.clearUserDefaults()
                appDelegate.setLogin()
            } else {
                self.viewModel.followUnfollow(storeId: self.storeId, isFollow:  (data?.isFollow == "1" ? Status.zero.rawValue : Status.one.rawValue)) { isDone in
                    if isDone {
                        self.page = 1
                        self.apiStoreDetials()
                    }
                }
            }
        }
    }
    
    func setMyStoreAPIData() {
        
        let data = self.viewModel.arrMyStoreDetails.first
        
            if (data?.productList?.count ?? 0) > 0 {
                vwRating.isHidden = false
            }else{
                vwRating.isHidden = true
            }
        
        
        self.appTopView.textTitle = data?.storeOwnerName ?? ""
        
        self.imgStore.tintColor = .themeGreenProfile
        
        if let img = data?.storeImage, let url = URL(string: img) {
            self.imgStore.sd_setImage(with: url, placeholderImage: .avatarStore)
            self.imgStore.contentMode = .scaleAspectFill
        } else {
            self.imgStore.image = .avatarStore
        }
        
        self.lblName.text = data?.storeOwnerName ?? ""
        if (data?.storeRating ?? "").isEmpty {
            self.btnRate.setTitle(Status.five.rawValue, for: .normal)
        } else {
            self.btnRate.setTitle(data?.storeRating ?? Status.five.rawValue, for: .normal)
        }
        self.lblTotalItmes.text = "\(data?.numberOfProducts ?? "") " + Labels.items
      
        if let count = Int(data?.numberOfProducts ?? "") {
            vwItemCount.isHidden = false
            self.lblTotalItmes.text = "\(count) " + (count > 1 ? Labels.items : Labels.item)
        }else{
            vwItemCount.isHidden = true
        }
        
        if (data?.numberOfReviews ?? "").isEmpty || (data?.numberOfReviews ?? "") == "0" {
            self.lblItem.text = ""
        } else {
            let rev = Int(data?.numberOfReviews ?? "0") ?? 0 < 2 ? Labels.review : Labels.reviews
            self.lblItem.text = "(\(data?.numberOfReviews ?? "") " + rev + ")"
        }
        
        self.lblDescription.text = data?.storeDescription
        self.lblLocation.numberOfLines = 0
        var location : String = ""
        if (data?.areaTitle ?? "").isEmpty {
            location = (data?.cityTitle ?? "")
        } else if (data?.cityTitle ?? "").isEmpty {
            location = (data?.areaTitle ?? "")
        } else if !(data?.cityTitle ?? "").isEmpty && !(data?.areaTitle ?? "").isEmpty{
            location = (data?.areaTitle ?? "") + ", " + (data?.cityTitle ?? "")
        } else {
            location = ""
        }
        self.lblLocation.text = location
        self.imgSellerPro.isHidden = !(appUserDefaults.getValue(.isProUser) ?? false)
        self.btnTotalRate.setTitle(data?.storeRating ?? Status.five.rawValue, for: .normal)
        self.lblTotalReview.text = "( " + (self.viewModel.numberOfReviews().description) + " " + Labels.reviews + ")"
        
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.setTopViewAction()
        self.applyStyle()
        self.setTopButtons()
        self.setTableStyle()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnMystoreTapped(_ sender: UIButton) {
        self.btnMystore.isSelected = true
        self.btnReview.isSelected = false
        self.btnFollowers.isSelected = false
        self.btnSort.isHidden = true
        self.apiStoreDetials()
        self.setTopButtons()
    }
    
    // --------------------------------------------
    
    @IBAction func btnFollowersTapped(_ sender: Any) {
        self.btnMystore.isSelected = false
        self.btnReview.isSelected = false
        self.btnFollowers.isSelected = true
        self.btnSort.isHidden = true
        self.btnSell.isHidden = true
        self.pageFollow = 1
        self.apiFollowData()
        self.setTopButtons()
    }
    
    // --------------------------------------------
    
    @IBAction func btnReviewTapped(_ sender: Any) {
        self.btnMystore.isSelected = false
        self.btnReview.isSelected = true
        self.btnFollowers.isSelected = false
        self.btnSell.isHidden = true
        self.pageReview = 1
        self.apiReviewData()
        self.setTopButtons()
        self.tblSearch.reloadData()
    }
    
    // --------------------------------------------
    
    @IBAction func btnHighlightTapped(_ sender: Any) {
    }
    
    // --------------------------------------------
    
    @IBAction func actionBtnBuy(_ sender: Any) {
        if appUserDefaults.getValue(.isGuestUser) ?? false {
            UserDefaults.standard.clearUserDefaults()
            appDelegate.setLogin()
        } else {
            self.coordinator?.navigateToBundleProductListVC(storeId: self.storeId)
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnEditTapped(_ sender: Any) {
        if let store = self.viewModel.arrMyStoreDetails.first {
            self.coordinator?.navigateToEditStore(data: EditStoreData(storeId: self.storeId, storeName: store.storeOwnerName ?? "", city: CitiesModel(cityName: store.cityTitle, cityId: Int(store.cityID ?? Status.zero.rawValue)), area: AreaModel(areaName: store.areaTitle, areaId: Int(store.areaID ?? Status.zero.rawValue)), description: store.storeDescription ?? "", storeImage: store.storeImage ?? ""))
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnMesageTapped(_ sender: Any) {
        if appUserDefaults.getValue(.isGuestUser) ?? false {
            UserDefaults.standard.clearUserDefaults()
            appDelegate.setLogin()
        } else {
//            self.coordinator?.setTabbar(selectedIndex: 3)
            self.viewModel.fetchMakeAnOfferAPI(offerType: "1", productId: "0", bundleId: "", amount: "", storeId:  self.storeId) { status,data,error in
                if status {
                    self.dismiss()
                    self.coordinator?.navigateToChatDetail(isBlock: false, chatId: data, userId: "")
                } else {
                    notifier.showToast(message: appLANG.retrive(label: error))
                }
            }
            
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnSellTapped(_ sender: Any) {
        self.coordinator?.setTabbar(selectedIndex: 2)
    }
    
    // --------------------------------------------
    
}

// ------------------------------------------------------
// MARK: - CollectionView delegate and datasource methods
// ------------------------------------------------------

extension StoreVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfProducts()
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductCell", for: indexPath) as! MyProductCell
        let data = self.viewModel.setProductsData(row: indexPath.row)
        if !cell.vwLike.isHidden {
            cell.vwLike.superview?.addTapGesture {
                self.viewModel.addRemoveFavourite(isFav: (data.isFav == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue) , productId: data.productID ?? "") { isDone in
                    if isDone {
                        self.page = 1
                        self.apiStoreDetials()
                    }
                }
            }
        }
        if !cell.vwpin.isHidden {
            cell.vwpin.superview?.addTapGesture {
                self.viewModel.fetchPinUnpinItemAPI(storeId: self.storeId, productId: data.productID ?? "", isPinUnpin: Status.zero.rawValue) { isDone in
                    if isDone {
                        self.page = 1
                        self.apiStoreDetials()
                    }
                }
            }
        }
        
        cell.btnBoost.addTapGesture {
            if data.isHidden == "1" {
                self.coordinator?.showPopUp(title: Labels.hide, description: Labels.areYouSureWantToHideProduct, storeId: self.storeId, productId: data.productID ?? "", isHide: Status.zero.rawValue, type: .hide) { status in
                    if status {
                        self.apiStoreDetials()
                    }
                }
            } else if data.isBoost == Status.zero.rawValue {
                let id = data.productID ?? ""
                let isBoosted : Bool = false
                self.coordinator?.navigateToBoostItemDetails(isBoosted: isBoosted, productID: id)
            } else if data.isBoost == "1" {
                let id = data.productID ?? ""
                let isBoosted : Bool = true
                self.coordinator?.navigateToBoostItemDetails(isBoosted: isBoosted, productID: id)
            }
        }
        
        cell.setOtherUserStoreDetailsData(data: data, type: self.openType)
        return cell
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid = ((colProducts.frame.size.width)/2)-8
        if self.openType == .myOrderList {
            return CGSize(width: wid , height: wid + 125)
        } else {
            return CGSize(width: wid , height: wid + 95)
        }
       
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfProducts()
        
        if (total - 1) == indexPath.row && self.viewModel.totalRecordsOfProductList > total {
            self.page += 1
            self.apiStoreDetials()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.viewModel.setProductsData(row: indexPath.row)
        if openType == .sellerBuyList {
            self.coordinator?.navigateToProductDetail(productId: data.productID ?? "", type: .goodsDefault)
        } else {
            self.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
        }
    }
}

// ------------------------------------------------------
// MARK: - TableView delegate and datasource methods
// ------------------------------------------------------

extension StoreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.btnReview.isSelected {
            return self.viewModel.numberOfReviews()
        } else {
            return self.viewModel.numberOfFollower()
        }
        
    }
    
    // -------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.btnReview.isSelected {
            
            let cellReview = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            
            DispatchQueue.main.async {
                let data = self.viewModel.setReviewsData(row: indexPath.row)
                cellReview.setData(data: data, lastRow: self.viewModel.numberOfReviews(), currentRow: indexPath.row)
                if self.openType == .myOrderList {
                    cellReview.btnReply.isHidden = data.isReply == "1"
                } else {
                    cellReview.btnReply.isHidden = true
                }
                cellReview.lblDescription.delegate = self
                cellReview.lblDescription.setMoreLinkWith(moreLink: "Read More", attributes: [.foregroundColor:UIColor.themeBlack], position: .left)
                cellReview.lblDescription.setLessLinkWith(lessLink: "Show less", attributes: [.foregroundColor:UIColor.themeBlack], position: .left)
                
                cellReview.lblDescription.shouldCollapse = true
//                cellReview.lblDescription.lineHeight = 40
                cellReview.lblDescription.numberOfLines = NSInteger(2.0)
                if indexPath.row < self.states.count {
                    cellReview.lblDescription.collapsed = self.states[indexPath.row]
                }
                cellReview.layoutIfNeeded()
                cellReview.contentView.layoutIfNeeded()
                cellReview.lblDescription.text = self.viewModel.setReviewsData(row: indexPath.row).reviewDescription
                cellReview.btnReply.addTapGesture {
                    self.coordinator?.navigateToReply(data: data, id : self.storeId)
                }
                cellReview.lblDescription.isUserInteractionEnabled = false
            }
            
            return cellReview
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerCell", for: indexPath) as! FollowerCell
            let data = self.viewModel.setFollowerData(row: indexPath.row)
            cell.setData(data: data, lastRow: (self.viewModel.numberOfFollower()), currentRow: indexPath.row)
            cell.btnFollowing.addTapGesture {
                if appUserDefaults.getValue(.isGuestUser) ?? false {
                    UserDefaults.standard.clearUserDefaults()
                    appDelegate.setLogin()
                } else {
                    self.viewModel.followUnfollow(storeId: data.storeID ?? "", isFollow: data.followStatus == "1" ? "0" : "1") { isDone in
                        if isDone {
                            self.apiFollowData()
                        }
                    }
                }
            }
            return cell
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.openType == .sellerBuyList || self.openType == .myOrderList {
            if self.btnReview.isSelected {
                self.coordinator?.navigateToReviewPopup(data: self.viewModel.setReviewsData(row: indexPath.row))
            }
        }
        if self.btnFollowers.isSelected {
            self.coordinator?.navigateToPopularStore(storeId: self.viewModel.setFollowerData(row: indexPath.row).storeID ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /* if self.btnReview.isSelected {
         let total = self.viewModel.numberOfReviews()
         if (total - 1) == indexPath.row && self.viewModel.totalRecordsOfReviews >= total {
         self.pageReview += 1
         self.apiReviewData()
         }
         } else if self.btnFollowers.isSelected {
         let total = self.viewModel.numberOfFollower()
         if (total - 1) == indexPath.row && self.viewModel.totalRecordsOfFollower >= total {
         self.pageFollow += 1
         self.apiFollowData()
         }
         } else {} */
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - ExpandableLabelDelegate
// --------------------------------------------

extension StoreVC : ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        self.tblSearch.beginUpdates()
    }
    
    // --------------------------------------------
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: self.tblSearch)
        if let indexPath = tblSearch.indexPathForRow(at: point) as IndexPath?, indexPath.row < states.count {
            states[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.tblSearch.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        self.tblSearch.endUpdates()
    }
    
    // --------------------------------------------
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        self.tblSearch.beginUpdates()
    }
    
    // --------------------------------------------
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: self.tblSearch)
        if let indexPath = tblSearch.indexPathForRow(at: point) as IndexPath?, indexPath.row < states.count {
            self.states[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.tblSearch.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        self.tblSearch.endUpdates()
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITextFeild delegate
// --------------------------------------------

extension StoreVC : UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.page = 1
        self.strSearch = self.txtSearch.text ?? ""
        self.apiFollowData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let search = self.txtSearch.text ?? ""
        if !search.isEmpty {
            self.page = 1
            self.strSearch = self.txtSearch.text ?? ""
            self.apiFollowData()
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
}
