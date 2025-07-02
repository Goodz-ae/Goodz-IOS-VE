//
//  NewHomeVC+DataSource.swift
//  Goodz
//
//  Created by on 27/03/25.
//

import UIKit

// --------------------------------------------
// MARK: Collection View DataSource Methods
// --------------------------------------------

extension NewHomeVC: UICollectionViewDataSource {
    
    fileprivate var _viewModel : HomeVM {
        return   self.viewModel ?? HomeVM()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case clvCategories:
            return _viewModel.numberOfCategories()
        case clvMain:
            print(_viewModel.goodzDealProductsArr.count)
            return _viewModel.goodzDealProductsArr.count >= 6 ? 6 : _viewModel.goodzDealProductsArr.count
        case clvCustomSelection:
            print(_viewModel.customSelectionArr.count)
            return _viewModel.customSelectionArr.count >= 4 ? 4 : _viewModel.customSelectionArr.count
        case clvOurSelection:
            print(_viewModel.ourSelectionArr.count)
            return _viewModel.ourSelectionArr.count >= 4 ? 4 : _viewModel.ourSelectionArr.count
        case clvPopularStores:
            return _viewModel.numberOfStore() >= 2 ? 2 : _viewModel.numberOfStore()
        case clvLatestArrivals:
            print(_viewModel.latestArrivalsProductsArr.count)
            return _viewModel.latestArrivalsProductsArr.count >= _viewModel.latestArrivalLoadCount ? _viewModel.latestArrivalLoadCount : _viewModel.latestArrivalsProductsArr.count
        default:
            return 0
        }
    }
    
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case clvCategories:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as CategoryViewCell
            let data = self._viewModel.setSubCategories(row: indexPath.row)
            if indexPath.row == 0 {
                cell.ivCategory.image =  UIImage(named: "ic_all")
            } else {
                if let img = data.categoriesMainImage, let url = URL(string: img) {
                    cell.ivCategory.sd_setImage(with: url, placeholderImage: .product)
                    cell.ivCategory.contentMode = .scaleAspectFill
                }else {
                    cell.ivCategory.image = .product
                }
            }
            cell.lblTitle.text = data.categoriesMainTitle
            cell.viewBg.backgroundColor = indexPath.row == 0 ? .themeGreen : .white
            cell.ivCategory.tintColor = indexPath.row == 0 ? .white : .black
            cell.lblTitle.textColor = indexPath.row == 0 ? .white : .black
            return cell
            
        case clvMain:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NewHomeProductCVC
            
            let dic = _viewModel.goodzDealProductsArr[indexPath.row]
            
            if indexPath.row == 5 {
                cell.imgBG.isHidden = false
                cell.imgBG.image = UIImage(named: "T1VM" )
                
            }else {
                
                if let img = dic.imgProduct, let url = URL(string: img) {
                    cell.productImage.sd_setImage(with: url, placeholderImage: .product)
                    cell.productImage.contentMode = .scaleAspectFill
                }else {
                    cell.productImage.image = .product
                }
                
                cell.imgBG.isHidden = true
                 
                cell.productName.text = dic.name
            }
            return cell
        
        case clvCustomSelection:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NewHomeProductCVC
            let dic = _viewModel.customSelectionArr[indexPath.row]
            cell.imgBG.isHidden = true
            //cell.productImage.image = //UIImage(named: dic.imgStr ?? "" )
            if let img = dic.imgProduct, let url = URL(string: img) {
                cell.productImage.sd_setImage(with: url, placeholderImage: .product)
                cell.productImage.contentMode = .scaleAspectFill
            }else {
                cell.productImage.image = .product
            }
            cell.productName.text = dic.name
            return cell
        
        case clvOurSelection:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NewHomeProductCVC
            let dic = _viewModel.ourSelectionArr[indexPath.row]
            cell.imgBG.isHidden = true
           // cell.productImage.image = UIImage(named: dic.imgStr ?? "" )
            if let img = dic.imgProduct, let url = URL(string: img) {
                cell.productImage.sd_setImage(with: url, placeholderImage: .product)
                cell.productImage.contentMode = .scaleAspectFill
            }else {
                cell.productImage.image = .product
            }
            cell.productName.text = dic.name
            return cell
        case clvPopularStores:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NewPopularStoresCVC
            let data = self._viewModel.setStoreData(row: indexPath.row)
            
            cell.completion = { isDone in
                if isDone ?? false {
                    self.pageCat = 1
                    self.pageStore = 1
                    self.homeAPI(isProfile: false)
                }
            }
            cell.parentVC = self
            cell.setData(data: data, isMyProduct: data.storeID == (appUserDefaults.codableObject(dataType : CurrentUserModel.self, key: .currentUser)?.storeID) ?? "0")
            cell.followLbl.addTapGesture {
                if UserDefaults.isGuestUser {
                    appDelegate.setLogin()
                } else {
                    self._viewModel.followUnfollow(storeId: data.storeID ?? "", isFollow: data.isFollow == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue) { isDone in
                        if isDone {
                            self.pageCat = 1
                            self.pageStore = 1
                            self.homeAPI(isProfile: false)
                        }
                    }
                }
            }
            cell.storeDetailBackView.addTapGesture {
                self.coordinator?.navigateToPopularStore(storeId: data.storeID ?? "")
            }
            return cell
        
        case clvLatestArrivals:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NewHomeProductCVC
            
            let dic = _viewModel.latestArrivalsProductsArr[indexPath.row]
            
            cell.imgBG.isHidden = true
            if let img = dic.imgProduct, let url = URL(string: img) {
                cell.productImage.sd_setImage(with: url, placeholderImage: .product)
                cell.productImage.contentMode = .scaleAspectFill
            }else {
                cell.productImage.image = .product
            }
           // cell.productImage.image = UIImage(named: dic.imgStr ?? "" )
            cell.productName.text = dic.name
            return cell
 
            
        default:
            return UICollectionViewCell()
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionBtnStoreViewMore(_ sender : UIButton) {
        self.coordinator?.navigateToPopularStoreVC()
    }
    
    // --------------------------------------------
    
    @IBAction func actionBtnProductViewMore(_ sender : UIButton) {
        let data = self._viewModel.setHomeData(row: sender.tag)
        if let title = data.title {
            switch  HomeDataTitle(rawValue: title) {
            case .goodzDeals :
                self.coordinator?.navigateToProductList(title: data.title ?? "", isGoodzDeal: Status.one.rawValue)
            case .popularStore :
                self.coordinator?.navigateToPopularStoreVC()
            case .popularProducts :
                self.coordinator?.navigateToProductList(title: data.title ?? "", isPopular: Status.one.rawValue)
            default :
                break
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.clvCategories {
            let total = self._viewModel.numberOfCategories()
            
            if (total - 1) == indexPath.row && self._viewModel.totalCategories > total {
                self.pageCat += 1
                self.apiCategories()
            }
        } else if collectionView == self.clvPopularStores {
            let totalStore  =  _viewModel.numberOfStore() >= 2 ? 2 : _viewModel.numberOfStore()
            if (totalStore - 1)  == indexPath.row  {
                // self.pageStore += 1
               // self.homeAPI(isProfile: false)
            }
        }
    }
}

