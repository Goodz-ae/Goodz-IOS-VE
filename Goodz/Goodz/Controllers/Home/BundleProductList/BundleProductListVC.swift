//
//  BundleProductListVC.swift
//  Goodz
//
//  Created by vtadmin on 18/12/23.
//

import UIKit

class BundleProductListVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var lblBundleProduct: UILabel!
    @IBOutlet weak var imgProductOne: UIImageView!
    @IBOutlet weak var imgProductTwo: UIImageView!
    @IBOutlet weak var imgProductThree: UIImageView!
    @IBOutlet weak var viewProducts: UIView!
    @IBOutlet weak var lblProductCount: UILabel!
    @IBOutlet weak var btnBundleInquiry: UIButton!
    
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var collectionProductList: UICollectionView!
    
    @IBOutlet weak var vwBundle: UIView!
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : BundleProductListVM = BundleProductListVM()
    var page : Int = 1
    var storeId : String = ""
    var arr : [BundleProductModel] = []
    
    // --------------------------------------------
    // MARK: - Life cycle methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUi()
        self.setTopViewAction()
        // Do any additional setup after loading the view.
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    @IBAction func actionBtnBundleProductCart(_ sender: UIButton) {
        self.coordinator?.navigateToBundleProductCartVC(storeId: self.storeId)
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.arr = []
        self.viewModel.fetchData(pageNo: self.page, storeId: self.storeId) { isDone in
            self.lblItemCount.text = self.viewModel.totalRecords.description + " Items"
            if isDone {
                self.setImages()
                self.collectionProductList.reloadData()
                self.collectionProductList.endRefreshing()
            } else {
                self.collectionProductList.reloadData()
                self.collectionProductList.endRefreshing()
            }
            
        }
    }
    
    // --------------------------------------------
    
    func setImageView(isHide: Bool) {
        self.imgProductOne.superview?.isHidden = isHide
        self.imgProductTwo.superview?.isHidden = isHide
        self.imgProductThree.superview?.isHidden = isHide
    }
    
    // --------------------------------------------
    
    func setImages() {
        DispatchQueue.main.async {
            let maxProductsToShow = 3
            self.arr = self.viewModel.arrBundleProducts.filter { $0.isAdded == Status.one.rawValue}
            self.setImageView(isHide: true)
            self.viewProducts.isHidden = true
            self.vwBundle.isHidden = self.arr.count == 0
            self.btnBundleInquiry.isHidden = self.arr.count < 2
            let imageViews = [self.imgProductOne, self.imgProductTwo, self.imgProductThree]

            for index in 0..<min(self.arr.count, maxProductsToShow) {
                guard let data = self.arr[safe: index], let img = data.storeImage, let url = URL(string: img) else {
                    continue
                }
                imageViews[index]?.sd_setImage(with: url, placeholderImage: .avatarStore)
                imageViews[index]?.superview?.isHidden = false
                imageViews[index]?.addTapGesture {
                    self.removeBundle(productId: data.productID ?? "", isAdd: data.isAdded ?? "1")
                }
            }

            if self.arr.count > maxProductsToShow {
                self.viewProducts.isHidden = false
                imageViews[maxProductsToShow - 1]?.superview?.isHidden = true
                self.lblProductCount.text = "+" + (self.arr.count - maxProductsToShow + 1).description
            }
        }
    }
    
    // --------------------------------------------
    
    func removeBundle(productId: String, isAdd: String) {
        self.viewModel.addRemoveBundle(productId: productId , isAdd: isAdd == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue) { isDone, error in
            if isDone {
                self.page = 1
                self.apiCalling()
            }else if error != "" {
                notifier.showToast(message: appLANG.retrive(label: error))
            }
        }
    }
    // --------------------------------------------
    
    func setUi() {

        [self.imgProductOne, self.imgProductTwo, self.imgProductThree].forEach {
            $0.cornerRadius(cornerRadius: 4.0)
            $0.contentMode = .scaleAspectFill
            $0.border(borderWidth: 1.0, borderColor: .themeGreen)
            $0.superview?.isHidden = true
        }
        
        self.viewProducts.cornerRadius(cornerRadius: 4.0)
        self.viewProducts.border(borderWidth: 1.0, borderColor: .themeGreen)
        
        self.lblItemCount.font(font: .medium, size: .size14)
        self.lblProductCount.font(font: .regular, size: .size12)
        self.lblBundleProduct.font(font: .medium, size: .size14)
        
        self.btnBundleInquiry.backgroundColor = .themeGreen
        self.btnBundleInquiry.cornerRadius(cornerRadius: 4.0)
        self.btnBundleInquiry.setTitleColor(.themeWhite, for: .normal)
        
        self.collectionProductList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.collectionProductList.delegate = self
        self.collectionProductList.dataSource = self
        self.collectionProductList.register(MyProductCell.nib, forCellWithReuseIdentifier: MyProductCell.reuseIdentifier)
        self.collectionProductList.reloadData()
        self.collectionProductList.addRefreshControl(target: self, action: #selector(refreshData))
        
        self.viewProducts.isHidden = true
        
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    // --------------------------------------------
    
    private func setTopViewAction() {
        self.appTopView.textTitle = Labels.buyInBundle
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
}

// ------------------------------------------------------
// MARK: - CollectionView Delegate and DataSource methods
// ------------------------------------------------------

extension BundleProductListVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
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
                    self.page = 1
                    self.apiCalling()
                }else if error != "" {
                    notifier.showToast(message: appLANG.retrive(label: error))
                }
            }
        }
        cell.vwLike.superview?.addTapGesture {
            self.viewModel.addRemoveFavourite(isFav: data.isFav == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue, productId: data.productID ?? "") { isDone in
                if isDone {
                    self.page = 1
                    self.apiCalling()
                }
            }
        }
        cell.setBundleProducts(data: data)
        return cell
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.viewModel.setCollectionCategories(row: indexPath.row)
        if data.isOwner == "1" {
            self.coordinator?.navigateToSellProductDetail(storeId: self.storeId, productId: data.productID ?? "", type: .sell)
        } else {
            self.coordinator?.navigateToProductDetail(productId: data.productID ?? "", type: .bundle, isAddedToBundle: data.isAdded == "0" ? false : true)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfRows()
        
        if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
            self.page += 1
            self.apiCalling()
        }
        
    }
    
    // --------------------------------------------
    
}
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
