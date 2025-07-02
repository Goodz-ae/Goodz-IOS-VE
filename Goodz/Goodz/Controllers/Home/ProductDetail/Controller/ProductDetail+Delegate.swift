//
//  ProductDetail+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.clvProductImages:
            return CGSize(width: screenWidth, height: self.clvProductImages.frame.size.height)
        case self.clvProducts:
            let width = screenWidth-30
            let commonHeight = ((((width)/2)+30) + 140)
            return CGSize(width: width, height: commonHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
}

extension ProductDetailVC: UITableViewDelegate {
    
}
