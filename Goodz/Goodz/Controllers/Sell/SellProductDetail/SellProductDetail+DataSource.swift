//
//  SellProductDetail+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit
import AVKit

extension SellProductDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfProductImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ProductImagesCell
        let data = self.viewModel.setProductImages(row: indexPath.row)
      
        if let img  = data.productImg, let url = URL(string: img) {
            if data.mediaType == Status.one.rawValue {
                cell.ivProduct.sd_setImage(with: url, placeholderImage: .product)
                
            } else {
                let imgs: ()? = img.createVideoThumbnail(completion: { image in
                    cell.ivProduct.image = image
                })
            }
            
        } else {
            cell.ivProduct.image = .product
        }
        cell.imgPlay.isHidden = !(data.mediaType == "2")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data  = self.viewModel.setProductImages(row: indexPath.row)
        if data.mediaType != "2" {
            if let img  = data.productImg, let url = URL(string: img) {
                self.coordinator?.navigateToOpenMedia(type: .image, url: url)
            }

        } else {
            if let madia = data.productImg, let url = URL(string: madia) {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
}
