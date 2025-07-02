//
//  MyFavouriteVC.swift
//  Goodz
//
//  Created by Akruti on 01/12/23.
//

import Foundation
import UIKit

class MyFavouriteVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var collectionProductList: UICollectionView!
    @IBOutlet weak var btnRemoveAll: UIButton!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    var viewModel : MyFavouriteVM?
    //var viewModel : MyFavouriteVM = MyFavouriteVM()
    
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
        viewModel = MyFavouriteVM()
        self.apiCalling()
        print("MyFavouriteVC")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel = nil
       
    }
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.setUp()
        self.setTopViewAction()
        
    }
    
    // --------------------------------------------
    
    private func setTopViewAction() {
        self.appTopView.textTitle = Labels.myFavorites
        self.appTopView.btnBack.isHidden = true
        self.appTopView.btnRight.isHidden = true
        self.appTopView.btnRight.setImage(.icFavFilter, for: .normal)
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        self.btnRemoveAll.isHidden = true
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.collectionProductList.delegate = self
        self.collectionProductList.dataSource = self
        self.collectionProductList.register(MyProductCell.nib, forCellWithReuseIdentifier: MyProductCell.reuseIdentifier)
        self.btnRemoveAll.setTitleColor(.themeBlack, for: .normal)
        self.collectionProductList.addRefreshControl(target: self, action: #selector(refreshData))
        
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.apiCalling()
    }
    // --------------------------------------------
    
    func apiCalling() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewModel?.fetchMyFavouriteProductList { [weak self] isDone in
                guard let self = self else { return }
                if !isDone || self.viewModel?.numberOfProduct() == 0 {
                    self.setNoData(scrollView: self.collectionProductList, noDataType: .productEmptyData)
                   
                }
                self.btnRemoveAll.isHidden = !isDone
                self.collectionProductList.reloadData()
                self.collectionProductList.endRefreshing()
            }
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionBtnRemoveAll(_ sender: UIButton) {
        self.viewModel?.removeAll { [weak self] isDone in
            guard let self = self else { return }
            if isDone {
                self.apiCalling()
            }
        }
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------------------
// MARK: - UICollectionView Delegate And DataSource Methods
// --------------------------------------------------------

extension MyFavouriteVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.numberOfProduct() ?? 0
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductCell", for: indexPath) as! MyProductCell
        guard let data = self.viewModel?.setProduct(row: indexPath.row) else {return cell}
        cell.setFavProductData(data: data)
        cell.vwLike.superview?.addTapGesture {
            self.viewModel?.addFavRemoveFavAPI(isFav: "0", productID: data.productID ?? "") { status in
                if status {
                    self.apiCalling()
                }
            }
        }
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

        return CGSize(width: wid , height: wid + 95)
   
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.viewModel?.setProduct(row: indexPath.row) else {return }
        if data.isOwner == "1" {
            self.coordinator?.navigateToSellProductDetail(storeId: "", productId: (data.productID ?? ""), type: .sell)
        } else {
            self.coordinator?.navigateToProductDetail(productId: (data.productID ?? "") ,type: .goodsDefault)
        }
    }
    
    // --------------------------------------------
    
}
