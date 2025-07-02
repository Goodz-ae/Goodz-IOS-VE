//
//  NewPopularStoresCVC.swift
//  Goodz
//
//  Created by shobhitdhuria on 03/04/25.
//

import UIKit

class NewPopularStoresCVC: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var storeDetailBackView: UIView!
    @IBOutlet weak var storeProfileImage: UIImageView!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var proSellerIcon: UIImageView!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var totalItemsLbl: UILabel!
    @IBOutlet weak var followLbl: UILabel!
    @IBOutlet weak var clvPopularStoreList: UICollectionView!
    @IBOutlet weak var constClvPopularStoreListHeight: NSLayoutConstraint!
    
    var viewModel : HomeVM? = HomeVM()
    var arrPopularStoreProducts : [ProductList] = []

    var arrPopularStore : [StoreList] = []
    var openStyle : OpenStyle = .other
    var completion : ((Bool?) -> Void) = { (_) in }
    var isMyProduct : Bool = false
    var parentVC : BaseVC?
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setUp() {
      //  self.viewModel?.createSideMenu()
        
        self.storeNameLbl.font(font: .bold, size: .size14)
        self.ratingCountLbl.font(font: .medium, size: .size12)
        self.totalItemsLbl.font(font: .medium, size: .size12)
        self.followLbl.font(font: .regular, size: .size14)
        
        self.clvPopularStoreList.delegate = self
        self.clvPopularStoreList.dataSource = self
        self.clvPopularStoreList.register(NewHomeProductCVC.nib, forCellWithReuseIdentifier: NewHomeProductCVC.reuseIdentifier)
        self.constClvPopularStoreListHeight.constant = 230
    }
    
    // --------------------------------------------
    
    func setData(data: StoreList, isMyProduct : Bool) {
        print("--~--\(data.storeName ?? "") -----\(isMyProduct)")
        self.isMyProduct = isMyProduct
        self.followLbl.isHidden = isMyProduct
        self.followLbl.backgroundColor = data.isFollow == Status.one.rawValue ? .themeWhite  : .themeGreen
        self.followLbl.textColor = data.isFollow == Status.one.rawValue ? .themeBlack  : .themeWhite
        self.followLbl.text = data.isFollow == Status.one.rawValue ? Labels.following : Labels.follow
        self.followLbl.border(borderWidth: 1.0, borderColor: .themeGreen)
        self.followLbl.cornerRadius(cornerRadius: 4.0)
        self.ratingCountLbl.text = ((data.storeRate ?? "").isEmpty ? Status.five.rawValue : data.storeRate)
        self.storeNameLbl.text = data.storeName
        if (data.numberOfReviews ?? "").isEmpty || (data.numberOfReviews ?? "") == "0" {
            self.totalItemsLbl.text = ""
        } else {
            let rev = Int(data.numberOfReviews ?? "0") ?? 0 < 2 ? Labels.review : Labels.reviews
            self.totalItemsLbl.text = "(" +  (data.numberOfReviews ?? "0") + " " + rev + ")"
        }
        if let img = data.storeImg, let url = URL(string: img) {
            self.storeProfileImage.sd_setImage(with: url, placeholderImage: .avatarStore)
            self.storeProfileImage.contentMode = .scaleAspectFill
        } else {
            self.storeProfileImage.image = .avatarStore
        }
        self.proSellerIcon.isHidden = data.isGoodzPro != "2"
        self.arrPopularStoreProducts = data.productList ?? []
        self.openStyle = .popularStoresProducts
        self.clvPopularStoreList.reloadData()
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let collectionView = object as? UICollectionView {
            if collectionView == self.clvPopularStoreList {
                self.constClvPopularStoreListHeight.constant = 470
                collectionView.layoutIfNeeded()
            }
        }
    }    
}

extension NewPopularStoresCVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPopularStoreProducts.count >= 6 ? 6 : self.arrPopularStoreProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as NewHomeProductCVC
        
        let dic = self.arrPopularStoreProducts[indexPath.row]
        
        if indexPath.row == 5 {
            cell.imgBG.isHidden = false
            cell.imgBG.image = UIImage(named: "T1VM" )
        } else {
            cell.imgBG.isHidden = true
        }
        
        if let img = dic.imgProduct, let url = URL(string: img) {
            cell.productImage.sd_setImage(with: url, placeholderImage: .product)
        } else {
            cell.productImage.image = .product
        }

        cell.sellerName.text = dic.brandName
        cell.goodzAmount.text = kCurrency +  (dic.discountedPrice ?? "0")
        cell.originalAmount.attributedText = (kCurrency +  (dic.price ?? "0")).strikeThrough()
        cell.productName.text = dic.name
        
        if let np = Double(dic.discountedPrice ?? Status.zero.rawValue) , np > 0 {
            cell.goodzAmount.text = kCurrency + (dic.discountedPrice ?? Status.zero.rawValue)
        } else {
            cell.goodzAmount.text = ""
        }
        if let price = Double(dic.price ?? Status.zero.rawValue), price > 0 {
            cell.originalAmount.attributedText = (kCurrency + (dic.price ?? Status.zero.rawValue)).strikeThrough()
            cell.originalAmount.isHidden = false
        } else {
            cell.originalAmount.isHidden = true
        }
        
        if Double(dic.discountedPrice ?? Status.zero.rawValue) == Double(dic.price ?? Status.zero.rawValue) {
            cell.originalAmount.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let clvPopularStoresWidth = (clvPopularStoreList.frame.size.width) // Default width
        return CGSize(width: clvPopularStoresWidth / 2.08, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.arrPopularStoreProducts[indexPath.row]
        if  data.isOwner == Status.one.rawValue {
            self.parentVC?.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
        } else {
            self.parentVC?.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
        }
    }
}
