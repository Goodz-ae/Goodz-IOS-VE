//
//  SellProductDetail+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit

extension SellProductDetailVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: self.clvProductImages.frame.size.height)
    }

}
