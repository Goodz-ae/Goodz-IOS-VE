//
//  HomeVc+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 11/12/23.
//

import UIKit

// --------------------------------------------
// MARK: Collection View DataSource Methods
// --------------------------------------------

extension HomeVC: UICollectionViewDataSource {
    
    fileprivate var _viewModel : HomeVM {
        return   self.viewModel ?? HomeVM()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case clvCategories:
            return _viewModel.numberOfCategories()
        case clvBuySellFurniture:
            return arrBuySellGoods.count
        case clvMain:
            return _viewModel.numberOfRows() == 0 ? 0 : (_viewModel.numberOfRows() - 1)
        case colStores :
            return _viewModel.numberOfStore()
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
            
        case clvBuySellFurniture:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as SellBuyFurnitureViewCell
            let data = arrBuySellGoods[indexPath.row]
            cell.setData(data: data)
            return cell
            
        case self.colStores :
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ProductViewCell
            let data = self._viewModel.setStoreData(row: indexPath.row)
            cell.parentVC = self
            cell.lblTitle.text = Labels.popularStores
            
            cell.proImgView.isHidden = data.isGoodzPro == "2" ? false : true
            
            cell.lblNewArrival.text = indexPath.row == 0 ? Labels.the_latest_arrivals : ""
            
            cell.viewHeader.isHidden = !(indexPath.row == 0)
            cell.btnViewMore.isHidden = self._viewModel.numberOfStore() < 6
            cell.viewViewMore.isHidden = self._viewModel.numberOfStore() < 6
            cell.btnViewMore.addTapGesture {
                self.coordinator?.navigateToPopularStoreVC()
            }
            cell.completion = { isDone in
                if isDone ?? false {
                    //                    self.viewModel.arrHome.removeAll()
                    //                    self.viewModel.arrStore.removeAll()
                    //                    self.clvBuySellFurniture.reloadData()
                    //                    self.clvMain.reloadData()
                    //                    self.colStores.reloadData()
                    self.pageCat = 1
                    self.pageStore = 1
                    self.homeAPI(isProfile: false)
                }
            }
            cell.setData(data: data, isMyProduct: data.storeID == (appUserDefaults.codableObject(dataType : CurrentUserModel.self, key: .currentUser)?.storeID) ?? "0")
            cell.lblFollow.addTapGesture {
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
            cell.viewFollowOwner.addTapGesture {
                self.coordinator?.navigateToPopularStore(storeId: data.storeID ?? "")
            }
            return cell
        case clvMain:
            switch indexPath.row {
            case 1:
                let cell = collectionView.dequeueReusableCell(for: indexPath) as AdvertiseCell
//                cell.frame.origin.x = 0
//                cell.frame.size.width = cell.superview?.frame.size.width ?? 0
                if let img = self._viewModel.setHomeData(row: indexPath.row).bannerImgurl, let url = URL(string: img) {
                    cell.imgBG.sd_setImage(with: url, placeholderImage: .product)
                    cell.imgBG.contentMode = .scaleToFill
                } else {
                    cell.imgBG.image = .product
                }
                return cell
                
            case 3:
                let cell = collectionView.dequeueReusableCell(for: indexPath) as MarketingCell
//                cell.frame.origin.x = 0
//                cell.frame.size.width = cell.superview?.frame.size.width ?? 0
                let data = self._viewModel.setHomeData(row: indexPath.row)
                if let totalSavedWoodKg = data.totalSavedWoodKg {
                    var lnlOneText: String = "0"
                    var lblTwoText: String = "0"
                    var lblThreeText: String = "0"
                    var lblFourText: String = "0"
                    var lblFiveText: String = "0"
                    var lblSixText: String = "0"
                    /*
                    switch totalSavedWoodKg.count {
                    case 6:
                        lnlOneText = totalSavedWoodKg[0].description
                        lblTwoText = totalSavedWoodKg[1].description
                        lblThreeText = totalSavedWoodKg[2].description
                        lblFourText = totalSavedWoodKg[3].description
                        lblFiveText = totalSavedWoodKg[4].description
                        lblSixText = totalSavedWoodKg[5].description
                        cell.lblTFour.isHidden = false
                        cell.lblFive.isHidden = false
                        cell.lblSix.isHidden = false
                    case 5:
                        lnlOneText = totalSavedWoodKg[0].description
                        lblTwoText = totalSavedWoodKg[1].description
                        lblThreeText = totalSavedWoodKg[2].description
                        lblFourText = totalSavedWoodKg[3].description
                        lblFiveText = totalSavedWoodKg[4].description
                        cell.lblTFour.isHidden = false
                        cell.lblFive.isHidden = false
                        cell.lblSix.isHidden = true
                    case 4:
                        lnlOneText = totalSavedWoodKg[0].description
                        lblTwoText = totalSavedWoodKg[1].description
                        lblThreeText = totalSavedWoodKg[2].description
                        lblFourText = totalSavedWoodKg[3].description
                        cell.lblTFour.isHidden = false
                        cell.lblFive.isHidden = true
                        cell.lblSix.isHidden = true
                    case 3:
                        lnlOneText = totalSavedWoodKg[0].description
                        lblTwoText = totalSavedWoodKg[1].description
                        lblThreeText = totalSavedWoodKg[2].description
                        cell.lblTFour.isHidden = true
                        cell.lblFive.isHidden = true
                        cell.lblSix.isHidden = true
                    case 2:
                        lblTwoText = totalSavedWoodKg[0].description
                        lblThreeText = totalSavedWoodKg[1].description
                        cell.lblTFour.isHidden = true
                        cell.lblFive.isHidden = true
                        cell.lblSix.isHidden = true
                    case 1:
                        lblThreeText = totalSavedWoodKg[0].description
                        cell.lblTFour.isHidden = true
                        cell.lblFive.isHidden = true
                        cell.lblSix.isHidden = true
                    default: break
                    }
                    */
                    cell.lnlOne.text = totalSavedWoodKg
                    //lnlOneText  lblTwoText  lblThreeText lblFourText  lblFiveText  lblSixText
                    
                    
                    
                    cell.lblTwo     .isHidden = true
                    cell.lblThree   .isHidden = true
                    cell.lblTFour   .isHidden = true
                    cell.lblFive    .isHidden = true
                    cell.lblSix     .isHidden = true
                }
                cell.btnLearnMore.addTapGesture {
                    self.coordinator?.navigateToWebView(id: 39)
                    // self.coordinator?.navigateToOurCommitments()
                }
                return cell
                
            default:
                let cell = collectionView.dequeueReusableCell(for: indexPath) as ProductViewCell
                let data = self._viewModel.setHomeData(row: indexPath.row)
                cell.btnViewMore.isHidden = data.productList?.count ?? 0 < 6
                cell.viewViewMore.isHidden = data.productList?.count ?? 0 < 6
                cell.parentVC = self
                cell.lblTitle.color(color: data.title == "Goodz Deals" ? .themeGoodz : .themeBlack)
                cell.lblTitle.text = data.title
                cell.completion = { isDone in
                    if isDone ?? false {
                        self.pageCat = 1
                        self.pageStore = 1
                        self.homeAPI(isProfile: false)
                    }
                }
                cell.bottomSeperatorView.isHidden = true
                cell.profileSeparatorView.isHidden = true
                cell.btnViewMore.tag = indexPath.row
                cell.setHomeData(data: data)
                cell.btnViewMore.addTarget(self, action: #selector(actionBtnProductViewMore), for: .touchUpInside)
                cell.viewFollowOwner.addTapGesture {
                    self.coordinator?.navigateToPopularStore(storeId: data.storeList?.first?.storeID ?? "")
                }
                return cell
            }
            
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
        } else if collectionView == self.colStores {
            let totalStore  = self._viewModel.numberOfStore()
            if (totalStore - 1)  == indexPath.row && self._viewModel.totalStore > totalStore {
                self.pageStore += 1
                self.homeAPI(isProfile: false)
            }
        }
    }
}
