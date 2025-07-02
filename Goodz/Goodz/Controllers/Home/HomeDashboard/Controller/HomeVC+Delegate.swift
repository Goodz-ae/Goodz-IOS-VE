//
//  HomeVC+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 11/12/23.
//

import UIKit

// --------------------------------------------
// MARK: Delegate - Datasource Collection View
// --------------------------------------------

extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    fileprivate var _viewModel : HomeVM {
        return   self.viewModel ?? HomeVM()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case clvCategories:
            if indexPath.row != 0 {
                if _viewModel.numberOfCategories() > indexPath.row {
                    let catData  = _viewModel.setSubCategories(row: indexPath.row)
                    self.coordinator?.navigateToSubCategory(openType: .other, title: catData.categoriesMainTitle ?? "", categoryMain: catData, completion: nil)
                }
            } else {
                self.coordinator?.navigateToSuperCategoryList(openType: .other, title: Labels.category) { _,_,_ in }
            }
        case clvBuySellFurniture:
            let data = arrBuySellGoods[indexPath.row]
            switch data.goodsType {
            case .buy:
                self.coordinator?.navigateToProductList(title: Labels.products)
            case .sell:
                if UserDefaults.isGuestUser {
                    appDelegate.setLogin()
                } else {
                    self.coordinator?.setTabbar(selectedIndex: 2)
                }
            }
            
        default: break
        }
        
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case clvBuySellFurniture:
            return 10
        default:
            return 0
        }
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case clvBuySellFurniture:
            return 10
        default:
            return 0
        }
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = _viewModel.setHomeData(row: indexPath.row)
        let wid = (clvBuySellFurniture.frame.size.width) // Default width
        let widt = self.view.frame.size.width
        
        switch collectionView {
        case clvCategories:
            return CGSize(width: 100, height: 45)
        case clvBuySellFurniture:
            let itemWidth = (wid - 10) / 2
            return CGSize(width: itemWidth, height: 150)
        case colStores:
            let storeData = _viewModel.setStoreData(row: indexPath.row)
            let commonHeight = ((((wid)/2)-8) + 95)
            switch indexPath.row {
            case 0:

                var hei = commonHeight
                let cellHeight = (((screenWidth-40)/2) + (IS_IPAD ? 95 : 100))
                var totalNewArrivalListcount = (storeData.newArrivalList?.count ?? 0)
                if totalNewArrivalListcount > 0 {
                    hei = hei + 110 // 130
                    totalNewArrivalListcount = (totalNewArrivalListcount % 2 == 0) ? totalNewArrivalListcount : (totalNewArrivalListcount + 1)
                    hei = hei + ((Double(cellHeight) * Double((totalNewArrivalListcount/2))))
                }
                return CGSize(width: widt, height: hei + 120 )
            default:
                var hei = commonHeight
                let cellHeight = (((screenWidth-40)/2) + (IS_IPAD ? 95 : 100))
                var totalNewArrivalListcount = (storeData.newArrivalList?.count ?? 0)
                if totalNewArrivalListcount > 0 {
                    hei = hei + 100 // 70
                    totalNewArrivalListcount = (totalNewArrivalListcount % 2 == 0) ? totalNewArrivalListcount : (totalNewArrivalListcount + 1)
                    hei = hei + ((Double(cellHeight) * Double((totalNewArrivalListcount/2))))
                }
                return CGSize(width: widt, height: hei + 65 )
            }

        case clvMain:

            switch indexPath.row {
            case 1:
                return CGSize(width: widt, height: wid / 2.5)
            case 3:
                return CGSize(width: widt, height: 350)
            default:
                if let title = data.title,
                   let homeDataTitle = HomeDataTitle(rawValue: title),
                   let productListCount = data.productList?.count {
                    var itemHeight: CGFloat = 0.0
                    let commonHeight = ((((wid)/2)-8) + 95)
                    switch homeDataTitle {
                        case .goodzDeals:
                        itemHeight = productListCount == 0 ? 0.0 : commonHeight + 35
                        case .popularProducts:
                            itemHeight = productListCount == 0 ? 0.0 : commonHeight + 35
                        default:
                            itemHeight = productListCount == 0 ? 0.0 : commonHeight + 55
                    }
                    return CGSize(width: widt, height: itemHeight)
                }
                return CGSize(width: widt, height: wid)
            }
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    // --------------------------------------------
}
