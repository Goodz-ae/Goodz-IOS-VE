//
//  SimilarProductVC.swift
//  Goodz
//
//  Created by Akruti on 10/04/24.
//

import Foundation
import UIKit

class SimilarProductVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var colProducts: UICollectionView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    var page : Int = 1
    private var viewModel : SimilarProductVM = SimilarProductVM()
    var productId = ""
    var categoryId = ""
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.page = 1
        self.apiCalling()
        super.viewWillAppear(animated)
        print("SimilarProductVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblTitle.font(font: .regular, size: .size16)
        self.lblItem.font(font: .medium, size: .size14)
        self.lblTitle.text = Labels.similarProducts
        self.lblItem.isHidden = true
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchSimilarProducts(page: self.page, productId: self.productId, categoryId: self.categoryId) { status, totalRecoerds in
            if status {
                if self.viewModel.numberOfSimiliarProducts() == 0 {
                    self.setNodataView()
                }
                self.colProducts.reloadData()
            } else {
                self.setNodataView()
            }
            self.lblItem.isHidden = self.viewModel.numberOfSimiliarProducts() == 0
            self.lblItem.text = totalRecoerds.description + " " + Labels.result.capitalizeFirstLetter()
            
            if  totalRecoerds > 1 {
                self.lblItem.text = totalRecoerds.description + " " + Labels.results.capitalizeFirstLetter()
            } else {
                self.lblItem.text = totalRecoerds.description + " " + Labels.result.capitalizeFirstLetter()
            }
            
            self.colProducts.reloadData()
            self.colProducts.endRefreshing()
        }
        
    }
   
    // --------------------------------------------
    
    func setNodataView() {
        self.setNoData(scrollView: self.colProducts, noDataType: .productEmptyData)
        self.colProducts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
   // --------------------------------------------
    
    func collectionRegister() {

        
        self.colProducts.delegate = self
        self.colProducts.dataSource = self
        self.colProducts.register(MyProductCell.nib, forCellWithReuseIdentifier: MyProductCell.reuseIdentifier)
        self.colProducts.addRefreshControl(target: self, action: #selector(refreshData))
        
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.collectionRegister()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.coordinator?.popVC()
    }
}

// --------------------------------------------
// MARK: - UICollectionViewDelegate methods
// --------------------------------------------

extension SimilarProductVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfSimiliarProducts()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid = ((self.colProducts.frame.size.width)/2)-8
        return CGSize(width: wid , height: wid + 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfSimiliarProducts()
        if collectionView == self.colProducts {
            if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
                self.page += 1
                self.apiCalling()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as MyProductCell
        let data = self.viewModel.setSimilarProducts(row: indexPath.row)
        cell.setSimilarProduct(data: data)
        cell.vwLike.superview?.addTapGesture {
            
            if UserDefaults.isGuestUser {
                appDelegate.setLogin()
            } else {
                self.viewModel.addRemoveFavourite(isFav: (data.isFav == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue), productId: data.productID ?? "") { isDpne in
                    if isDpne {
                        self.page = 1
                        self.apiCalling()
                    }
                }
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.viewModel.setSimilarProducts(row: indexPath.row)
        if data.isOwner == Status.one.rawValue {
            self.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
        } else {
            self.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
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
}
