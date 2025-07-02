//
//  ProductViewCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 11/12/23.
//

import UIKit

class ProductViewCell: UICollectionViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    /// Outer Views
    @IBOutlet weak var viewFollowOwner: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var clvProducts: UICollectionView!
    @IBOutlet weak var heightClvProduct: NSLayoutConstraint!
    
    @IBOutlet weak var viewNewArrival: UIView!
    @IBOutlet weak var clvNewArrival: UICollectionView!
    @IBOutlet weak var lblNewArrival: UILabel!
    
    @IBOutlet weak var proImgView: UIImageView!
    
    /// Title Section
    @IBOutlet weak var viewViewMore: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblViewMore: UILabel!
    @IBOutlet weak var btnViewMore: UIButton!
    
    /// Follow View
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgPro : UIImageView!
    
    @IBOutlet weak var profileSeparatorView: UIView!
    @IBOutlet weak var bottomSeperatorView: UIView!
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    // var arrProducts: [ProductInfo] = []
    var arrSimilarProducts : [SimilarProductModel] = []
    var arrGoodzProduct  : [ProductList] = []
    var arrPopularProduct : [ProductList] = []
    var arrStorePopularProduct : [ProductList] = []
    var arrStorePopularNewArrival : [ProductList] = []

    var arrPopularStore : [StoreList] = []
    weak var delegate: ProductViewCellDelegate?
    var openStyle : OpenStyle = .other
    var parentVC : BaseVC?
    var completion : ((Bool?) -> Void) = { (_) in }
    var isMyProduct : Bool = false
    var isProductFav: String = ""
    
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgProfile.image = .avatarStore
//        let itemWidth = clvProducts.frame.width / 2.25 + (IS_IPAD ? 160 : 0)
        let itemWidth = screenWidth / 2.25 
        heightClvProduct.constant = itemWidth + 95
        contentView.layoutIfNeeded()
        self.collectionRegister()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func collectionRegister() {
        self.clvProducts.dataSource = self
        self.clvProducts.delegate = self
        self.clvProducts.register(MyProductCell.nib, forCellWithReuseIdentifier: MyProductCell.reuseIdentifier)
        
        self.clvNewArrival.dataSource = self
        self.clvNewArrival.delegate = self
        self.clvNewArrival.register(MyProductCell.nib, forCellWithReuseIdentifier: MyProductCell.reuseIdentifier)

    }
    
    // --------------------------------------------
    
    func applyStyle() {
        self.lblTitle.font(font: .semibold, size: .size18)
        self.lblViewMore.font(font: .medium, size: .size16)
        self.lblSellerName.font(font: .medium, size: .size14)
        self.lblRating.font(font: .medium, size: .size12)
        self.lblItems.font(font: .medium, size: .size12)
        self.lblFollow.font(font: .medium, size: .size12)
        self.lblNewArrival.font(font: .semibold, size: .size18)
        self.btnViewMore.isHidden = true
        self.viewViewMore.isHidden = true
        self.imgPro.isHidden = true
    }
    
    // --------------------------------------------
    
    func setData(data: StoreList, isMyProduct : Bool) {
        print("--~--\(data.storeName ?? "") -----\(isMyProduct)")
        
        self.isMyProduct = isMyProduct
        self.lblFollow.isHidden = isMyProduct
        self.lblFollow.backgroundColor = data.isFollow == Status.one.rawValue ? .themeWhite  : .themeGreen
        self.lblFollow.textColor = data.isFollow == Status.one.rawValue ? .themeBlack  : .themeWhite
        self.lblFollow.text = data.isFollow == Status.one.rawValue ? Labels.following : Labels.follow
        self.lblFollow.border(borderWidth: 1.0, borderColor: .themeGreen)
        self.lblFollow.cornerRadius(cornerRadius: 4.0)
        self.lblRating.text = ((data.storeRate ?? "").isEmpty ? Status.five.rawValue : data.storeRate)
        self.lblSellerName.text = data.storeName
        if (data.numberOfReviews ?? "").isEmpty || (data.numberOfReviews ?? "") == "0" {
            self.lblItems.text = ""
        } else {
            let rev = Int(data.numberOfReviews ?? "0") ?? 0 < 2 ? Labels.review : Labels.reviews
            self.lblItems.text = "(" +  (data.numberOfReviews ?? "0") + " " + rev + ")"
        }
        if let img = data.storeImg, let url = URL(string: img) {
            self.imgProfile.sd_setImage(with: url, placeholderImage: .avatarStore)
            self.imgProfile.contentMode = .scaleAspectFill
        } else {
            self.imgProfile.image = .avatarStore
        }
        self.imgPro.isHidden = data.isGoodzPro != "2"
        self.arrStorePopularProduct = data.productList ?? []
        self.arrStorePopularNewArrival = data.newArrivalList ?? []
        self.openStyle = .popularStoresProducts
        self.clvProducts.reloadData()
        self.clvNewArrival.reloadData()
    }
    
    // --------------------------------------------
    
    func setHomeData(data: HomeData) {
        if data.title == Labels.popularStores {
            self.viewFollowOwner.isHidden = false
            self.viewNewArrival.isHidden = false
        } else {
            self.viewFollowOwner.isHidden = true
            self.viewNewArrival.isHidden = true
        }
        
        self.lblFollow.addTapGesture {
            self.lblFollow.text = (self.lblFollow.text == Labels.follow) ? Labels.following : Labels.follow
        }
        
        if let title = data.title {
            switch HomeDataTitle(rawValue: title) {
            case .goodzDeals:
                if let productList = data.productList {
                    self.arrGoodzProduct = limitArray(productList, limit: 5)
                    self.openStyle = .goodzDeals
                }
            case .popularStore:
                if let storeList = data.storeList {
                    self.arrPopularStore = storeList 
                    self.openStyle = .popularStore
                }
            case .popularProducts:
                if let productList = data.productList {
                    print("Jigzz : \(productList)" )
                    self.arrPopularProduct = limitArray(productList, limit: 5)
                    self.openStyle = .popularProduct
                }
            default:
                break
            }
            DispatchQueue.main.async {
                self.clvProducts.reloadData()
                self.clvNewArrival.reloadData()
            }
           
        }
    }
    
    // --------------------------------------------
   
    func limitArray<T>(_ array: [T], limit: Int) -> [T] {
        return Array(array.prefix(limit))
    }
    
    // --------------------------------------------
    
}
