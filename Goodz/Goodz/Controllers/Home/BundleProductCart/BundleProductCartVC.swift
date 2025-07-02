//
//  BundleProductCartVC.swift
//  Goodz
//
//  Created by vtadmin on 18/12/23.
//

import UIKit

class BundleProductCartVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var collectionProductList: UICollectionView!
    @IBOutlet weak var constraintCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var viewPriceDetails: UIView!
    @IBOutlet weak var LblTitlePriceDetails: UILabel!
    
    @IBOutlet weak var lblTitlePrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitleDiscount: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTitleTotalPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnMakeAnOffer: ThemeGreenBorderButton!
    @IBOutlet weak var btnProceedToCheckout: ThemeGreenButton!
    
    @IBOutlet weak var lblDeliveryCost: UILabel!
    
    @IBOutlet weak var vwCartDetails: UIStackView!
    @IBOutlet weak var vwButtons: UIView!
    @IBOutlet weak var lblVAt: UILabel!
    @IBOutlet weak var lblVatDetail: UILabel!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var viewModel : BundleProductCartVM = BundleProductCartVM()
    var bundleId : String = ""
    var bundleProductCartObject : BundleProductCartModel?
    var storeId : String = ""
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCalling()
        self.collectionProductList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.collectionProductList.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.setUp()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    private func apiCalling() {
        self.viewModel.fetchData(storeID: storeId) { isDone in
            if isDone {
                self.vwButtons.isHidden = self.viewModel.numberOfRows() == 0
                self.vwCartDetails.isHidden = self.viewModel.numberOfRows() == 0
                if self.viewModel.numberOfRows() == 0 {
                    self.setNotDataCart()
                } else {
                    if let data = self.viewModel.arrBundleProducts.first {
                        self.setAPIData(data: data)
                        self.bundleProductCartObject = data
                        self.vwButtons.backgroundColor = .themeWhite
                    }
                }
            } else {
                self.vwButtons.isHidden = true
                self.vwCartDetails.isHidden = true
                self.setNotDataCart()
            }
            self.collectionProductList.reloadData()
        }
    }
    
    private func setNotDataCart() {
        self.setNoData(scrollView: self.collectionProductList, noDataType: .productEmptyData)
        self.collectionProductList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        self.vwButtons.backgroundColor = .themeBG
        
    }
    // --------------------------------------------
    
    func setAPIData(data: BundleProductCartModel) {
        if data.discountPrice == "0" || data.discountPrice == "0.0" || data.discountPrice == "0.00" || (data.discountPrice ?? "").isEmpty {
            self.lblDiscount.superview?.isHidden = true
        }
        self.lblDiscount.text = "-" + kCurrency + (data.discountPrice ?? "0")
        self.lblTitleDiscount.text = Labels.kDiscout + " (" + (data.discountPercentage ?? "") + "%)"
        self.lblPrice.text = kCurrency + (data.totalPrice ?? "0")
        self.lblTotalPrice.text = kCurrency + (data.totalPriceWithTax ?? "0")
        let strValue = (data.bundleAddedProductList?.count ?? 0).description
        self.LblTitlePriceDetails.text =  Labels.priceDetail + "( " + strValue + " " + Labels.kItem + ")"
        self.bundleId = data.bundleID ?? ""
        self.lblVAt.text = Labels.vAT + "(" + (data.vatPercentage ?? "0") + "%)"
        self.lblVatDetail.text = kCurrency + (data.vatPrice ?? "0")
//        self.btnMakeAnOffer.isHidden = data.isOfferSend == Status.one.rawValue
    }
    
    // --------------------------------------------
    
    private func setTopViewAction() {
        self.appTopView.textTitle = Labels.bundleProducts
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let collView = object as? UICollectionView {
            if collView == self.collectionProductList {
                collView.layer.removeAllAnimations()
                if self.viewModel.numberOfRows() > 0 {
                    self.constraintCollectionHeight.constant = collView.contentSize.height
                } else {
                    self.constraintCollectionHeight.constant = screenHeight - 200
                }
                view.layoutIfNeeded()
            }
        }
        
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.LblTitlePriceDetails.font(font: .semibold, size: .size16)
        self.lblTitlePrice.font(font: .regular, size: .size16)
        self.lblPrice.font(font: .regular, size: .size16)
        self.lblTitleDiscount.font(font: .regular, size: .size16)
        self.lblDiscount.font(font: .regular, size: .size16)
        self.lblTitleTotalPrice.font(font: .semibold, size: .size16)
        self.lblTotalPrice.font(font: .semibold, size: .size16)
        self.lblDeliveryCost.font(font: .regular, size: .size14)
        self.vwCartDetails.isHidden = true
        self.vwButtons.isHidden = true
        self.collectionProductList.delegate = self
        self.collectionProductList.dataSource = self
        self.collectionProductList.register(MyProductCell.nib, forCellWithReuseIdentifier: MyProductCell.reuseIdentifier)
        self.collectionProductList.reloadData()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionBtnProceedToCheckout(_ sender: UIButton) {
        if self.viewModel.numberOfRows() < 2 {
            notifier.showToast(message: Labels.ToMakeABuyInBundlePurchaseMoreThanOneProductIsRequired)
        } else {
            self.viewModel.proceedToCheckoutAPI(chatId: "", toId: "", productId: "", bundleId: self.bundleId, isFromBundle: "1") { status, address in
                if status {
                    if let address = address?.first {
                        self.coordinator?.navigateToBundleCart(bundleId: self.bundleId, address : address, priceDetails: self.bundleProductCartObject, storeId: self.storeId)
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionBtnMakeAnOffer(_ sender: UIButton) {
        if self.viewModel.numberOfRows() < 2 {
            notifier.showToast(message: Labels.ToMakeABuyInBundlePurchaseMoreThanOneProductIsRequired)
        } else {
            if self.viewModel.arrBundleProducts.first?.isOfferStatus == Status.one.rawValue {
                notifier.showToast(message: Labels.offerAlreadyAccepted)
            }else{
                self.coordinator?.presentMakeAnOffer(data: MakeAnOfferModel(offerType: "2", productId: "", bundleId: self.bundleId, amount: ""), parentvc: self, price: (bundleProductCartObject?.maxOfferPrice ?? "0"))
            }
        }
    }
    
    // --------------------------------------------
    
}

// ---------------------------------------------------------
// MARK: - UICollectionView Delegate and DataSource Methods
// ---------------------------------------------------------

extension BundleProductCartVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductCell", for: indexPath) as! MyProductCell
        let data = self.viewModel.setCollectionCategories(row: indexPath.row)
        cell.btnAdd.addTapGesture {
            self.viewModel.addRemoveBundle(productId: data.productID ?? "", isAdd: data.isAdded == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue) { isDone, error in
                if isDone {
                    self.apiCalling()
                }else if error != "" {
                    notifier.showToast(message: appLANG.retrive(label: error))
                }
            }
        }
        cell.vwLike.superview?.addTapGesture {
            self.viewModel.addRemoveFavourite(isFav: data.isFav == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue, productId: data.productID ?? "") { isDone in
                if isDone {
                    self.apiCalling()
                }
            }
            
        }
        cell.vwMain.addTapGesture {
            self.coordinator?.navigateToProductDetail(productId: data.productID ?? "", type: .goodsDefault)
        }
        cell.setBundleProducts(data: data)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let wid = ((collectionProductList.frame.size.width)/2)-8
        return CGSize(width: wid , height: wid + (screenHeight * 0.17))
        
    }
    
    // --------------------------------------------
    
}
