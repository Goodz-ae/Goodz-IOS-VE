//
//  NewHomeVC+Delegate.swift
//  Goodz
//
//  Created by on 27/03/25.
//

import UIKit

// --------------------------------------------
// MARK: Delegate - Datasource Collection View
// --------------------------------------------

extension NewHomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        case clvMain:
            let data = _viewModel.goodzDealProductsArr[indexPath.row]
            if data.isOwner == Status.one.rawValue {
                self.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
            } else {
                self.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
            }
        case clvCustomSelection:
            let data = _viewModel.customSelectionArr[indexPath.row]
            if data.isOwner == Status.one.rawValue {
                self.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
            } else {
                self.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
            }
        case clvOurSelection:
            let data = _viewModel.ourSelectionArr[indexPath.row]
            if data.isOwner == Status.one.rawValue {
                self.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
            } else {
                self.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
            }
        case clvLatestArrivals:
            let data = _viewModel.latestArrivalsProductsArr[indexPath.row]
            if data.isOwner == Status.one.rawValue {
                self.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
            } else {
                self.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
            }
        default: break
        }
        
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let clvMainWidth = (clvMain.frame.size.width) // Default width
        let clvCustomWidth = (clvCustomSelection.frame.size.width) // Default width
        let clvOurSelectionWidth = (clvOurSelection.frame.size.width) // Default width
        let clvLatestArrivalsWidth = (clvLatestArrivals.frame.size.width) // Default width
        let clvPopularStoresWidth = (clvPopularStores.frame.size.width) // Default width
        
        switch collectionView {
        case clvCategories:
            return CGSize(width: 100, height: 45)
        case clvMain:
            return CGSize(width: (clvMainWidth/2 - 10), height: 220)
        case clvCustomSelection:
            return CGSize(width: (clvCustomWidth/2 - 10), height: 220)
        case clvOurSelection:
            return CGSize(width: (clvOurSelectionWidth/2 - 10), height: 220)
        case clvPopularStores:
            return CGSize(width: clvPopularStoresWidth, height: 380)
        case clvLatestArrivals:
            return CGSize(width: (clvLatestArrivalsWidth/2 - 10), height: 220)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    // --------------------------------------------
}

