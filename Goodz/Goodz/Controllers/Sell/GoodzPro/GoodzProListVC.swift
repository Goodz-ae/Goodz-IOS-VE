//
//  GoodzProListVC.swift
//  Goodz
//
//  Created by vtadmin on 19/12/23.
//

import UIKit

class GoodzProListVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var scrllView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewPlan: UIView!
    @IBOutlet weak var viewPurchasedPlan: UIView!
    @IBOutlet weak var viewBenefits: UIView!
    
    @IBOutlet weak var lblTitleBenefits: UILabel!
    @IBOutlet weak var collectionBenefits: UICollectionView!
    @IBOutlet weak var constraintBenefitsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitleGoodzProBenefitz: UILabel!
    @IBOutlet weak var btnSubscribeNow: ThemeGreenButton!
    @IBOutlet weak var lblProBenefitsPrice: UILabel!
    
    @IBOutlet weak var lblYourPlan: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var btnDashboard: ThemeGreenButton!
    @IBOutlet weak var btnPriority: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrBenefits : [BenefitsListModel] = []
    private var viewModel  : GoodzProListVM = GoodzProListVM()
    let currentUser = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)
    var comeFromSignup = false
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUi()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applyStyle()
        self.collectionBenefits.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.collectionBenefits.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // --------------------------------------------
    
    func applyStyle() {
        GlobalRepo.shared.getProfileAPI { _, _, _ in }
        if /*self.comeFromSignup ||*/ (self.currentUser?.isUpdateProfile ?? "0") == "0" {
            self.btnSubscribeNow.setTitle(Labels.updateYourProfile , for: .normal)
            self.lblProBenefitsPrice.text = ""
            self.viewPurchasedPlan.isHidden = true
            self.viewPlan.isHidden = false
        } else if (self.currentUser?.isUpdateProfile ?? "0") == "1" {
            self.viewPurchasedPlan.isHidden = false
            self.viewPlan.isHidden = true
        } else {
            self.viewPurchasedPlan.isHidden = !(appUserDefaults.getValue(.isProUser) ?? false)
            self.viewPlan.isHidden = appUserDefaults.getValue(.isProUser) ?? false
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionBtnSubscribeNow(_ sender: UIButton) {
        if comeFromSignup || (appUserDefaults.getValue(.currentUser)?.isUpdateProfile ?? "0") == "0" {
            self.coordinator?.navigateToEditProfile(isPro: true, comeFromSignup: true)
        } else {
            self.viewModel.fetchData { status in
                if status {
                    self.coordinator?.navigateToOrderCompletePopup(storeId: "", productId: "", type: .subscription)
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionBtnDashboard(_ sender: UIButton) {
        GlobalRepo.shared.getProfileAPI { _, _, _ in }
        if currentUser?.documentsSubmitted == "0" {
            showAlert(title: Labels.goodzPro, message: Labels.pleaseUploadYourDocumentForSubscription) {
                self.coordinator?.navigateToDocumentHelpCenter(isPro: appUserDefaults.getValue(.isProUser) ?? false)
                
            }
        } else if currentUser?.documentsValidated == "0" {
            showAlert(title: Labels.goodzPro, message: Labels.YourDocumentsAreUnderReviewOnceTheyAreApprovedYouWillBeAbleToAccessTheDashboard) {
                if self.comeFromSignup {
                    self.coordinator?.setTabbar()
                } else {
                    self.coordinator?.popToRootVC()
                }
            }
        } else {
            self.coordinator?.navigateToDashboard()
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionBtnPriority(_ sender: UIButton) {
        self.coordinator?.navigateToPriorityContact()
    }
    
    // --------------------------------------------
    // MARK: - Custo methods
    // --------------------------------------------
    
    private func setTopViewAction() {
        self.appTopView.textTitle = Labels.goodzPro.capitalized
        self.appTopView.backButtonClicked = { [] in
            if self.comeFromSignup {
                print("☢️☢️☢️☢️")
                self.coordinator?.setTabbar()
            } else {
                print("❌❌❌❌❌❌")
                self.coordinator?.popToRootVC()
            }
        }
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let collView = object as? UICollectionView {
            if collView == self.collectionBenefits {
                collView.layer.removeAllAnimations()
                self.constraintBenefitsHeight.constant = collView.contentSize.height
                view.layoutIfNeeded()
            }
        }
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - Data set
// --------------------------------------------

extension GoodzProListVC {
    
    func setUi() {
        
        self.arrBenefits.removeAll()
        
        self.arrBenefits.append(BenefitsListModel(img: "undraw_discount", title: Labels.integratedLogisticSolution, descr: Labels.reduceYourBuyerProductionFee))
        self.arrBenefits.append(BenefitsListModel(img: "undraw_verified", title: Labels.gainVisibility, descr: Labels.accessToAnUnlimitedOnlineCommunityIfCativeBuyers))
        self.arrBenefits.append(BenefitsListModel(img: "undraw_unboxing_pbm", title: Labels.generateAdditionalRevenue, descr: Labels.boostEarningsWith_a_simplifiedOnlinePresence))
        self.arrBenefits.append(BenefitsListModel(img: "undraw_stepping_up_g6oo", title: Labels.customizedDashboard, descr: Labels.accessToDetailedInsightsAndAnalyseYourStorePerformance))
        self.arrBenefits.append(BenefitsListModel(img: "undraw_Gifts_0ceh", title: Labels.addStocks, descr: Labels.unlockYourStockListingPossibilitiesForMultipleItems))
        self.arrBenefits.append(BenefitsListModel(img: "undraw_Active_support_re_b7sj", title: Labels.prioritySupport, descr: Labels.enjoy_a_dedicatedPriorityProSupport))
        
        self.btnDashboard.setTitle(Labels.dashboard, for: .normal)
        self.btnPriority.setTitle(Labels.priorityContact, for: .normal)
        self.btnSubscribeNow.setTitle(Labels.subscribeNow, for: .normal)
        
        self.lblYourPlan.text = Labels.enjoyGoodzProBenefits
        self.lblTitleGoodzProBenefitz.text = Labels.enjoyGoodzProBenefits
        self.lblTitleBenefits.text = Labels.enjoyGoodzProBenefits
        
        self.collectionBenefits.delegate = self
        self.collectionBenefits.dataSource = self
        self.collectionBenefits.register(ProBenefitCell.nib, forCellWithReuseIdentifier: ProBenefitCell.reuseIdentifier)
        self.collectionBenefits.reloadData()
        
        self.viewPurchasedPlan.cornerRadius(cornerRadius: 15.0)
        self.viewPlan.cornerRadius(cornerRadius: 15.0)
        
        self.lblTitleBenefits.font(font: .semibold, size: .size16)
        self.lblProBenefitsPrice.font(font: .medium, size: .size12)
        
        self.lblYourPlan.font(font: .semibold, size: .size18)
        self.lblDueDate.font(font: .medium, size: .size12)
        
        self.lblTitleGoodzProBenefitz.font(font: .semibold, size: .size18)
        
    }
    
}

// --------------------------------------------
// MARK: - UICollectionView Delegate & DataSource
// --------------------------------------------

extension GoodzProListVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBenefits.count
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProBenefitCell", for: indexPath) as! ProBenefitCell
        let data = arrBenefits[indexPath.row]
        cell.lblTitle.text = data.title
        cell.lblDescription.text = data.descr
        cell.imgLogo.image = UIImage(named: data.img ?? "")
        return cell
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            
        } else if indexPath.row == 3 {
        }
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let wid = ((collectionBenefits.frame.size.width)/2)-8
        return CGSize(width: wid , height: wid + 85)
        
    }
    
    // --------------------------------------------
    
}
