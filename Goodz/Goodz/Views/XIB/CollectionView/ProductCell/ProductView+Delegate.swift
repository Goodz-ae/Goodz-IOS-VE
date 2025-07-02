//
//  ProductView+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 11/12/23.
//

import UIKit

extension ProductViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemWidth = (collectionView == clvProducts) ? (screenWidth / 2.25) : ((screenWidth-40)/2)
        var itemHeight: CGFloat = itemWidth + 95

        switch openStyle {
        case .popularStoresProducts:
            itemWidth = (collectionView == clvProducts) ? (screenWidth / 2.5) : ((screenWidth-40)/2)
            itemHeight = ((collectionView == clvProducts) ? (screenWidth / 2.25) : ((screenWidth-40)/2)) + 95
        default:
            itemWidth = (collectionView == clvProducts) ? (screenWidth / 2.25) : ((screenWidth-40)/2)
            itemHeight = itemWidth + 95
        }
       
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView == clvProducts) ? 10 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  (collectionView == clvProducts) ? 0 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch openStyle {
        case .other: break
        case .similar :
            let data = self.arrSimilarProducts[indexPath.row]
            if data.isOwner == Status.one.rawValue {
                self.parentVC?.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
            } else {
                self.parentVC?.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
            }
        case .popularProduct:
            let data = self.arrPopularProduct[indexPath.row]
            if data.isOwner == Status.one.rawValue {
                self.parentVC?.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
            } else {
                self.parentVC?.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
            }
        case .popularStore:
            break
        case .goodzDeals:
            let data = self.arrGoodzProduct[indexPath.row]
            if data.isOwner == Status.one.rawValue {
                self.parentVC?.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
            } else {
                self.parentVC?.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
            }
        case .popularStoresProducts:
            
            if collectionView == clvProducts {
                let data = self.arrStorePopularProduct[indexPath.row]
                if  data.isOwner == Status.one.rawValue {
                    self.parentVC?.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
                } else {
                    self.parentVC?.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
                }
            }else{
                let data = self.arrStorePopularNewArrival[indexPath.row]
                if  data.isOwner == Status.one.rawValue {
                    self.parentVC?.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
                } else {
                    self.parentVC?.coordinator?.navigateToProductDetail(productId: data.productID ?? "",type: .goodsDefault)
                }
            }
            
           
        }
       
    }
    
}
