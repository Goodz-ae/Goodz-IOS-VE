//
//  ProductDetail+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit
import AVKit

extension ProductDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.clvProductImages:
            return self.viewModel.numberOfProductImages()
        case self.clvProducts:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.clvProductImages:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ProductImagesCell
            let data  = self.viewModel.setProductImages(row: indexPath.row)
            if let img  = data.productImg, let url = URL(string: img) {
                if data.mediaType != "2" {
                    cell.ivProduct.sd_setImage(with: url, placeholderImage: .product)
                } else {
                    let imgs: ()? = img.createVideoThumbnail(completion: { image in
                        cell.ivProduct.image = image
                    })
                }
                
            }
            cell.imgPlay.isHidden = !(data.mediaType == "2")
            return cell
        case self.clvProducts:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ProductViewCell
            cell.openStyle = .similar
            cell.lblTitle.text = Labels.similarProducts
            cell.delegate = self
            cell.parentVC = self
            cell.viewFollowOwner.isHidden = true
            self.viewModel.fetchSimilarProducts(page: 1, productId: self.productID, categoryId: self.viewModel.productDetails?.product?.subSubCategoryID ?? "") { isDone, totalRecoreds in
                cell.arrSimilarProducts = isDone ? self.viewModel.arrSimilarProduct : []
                cell.btnViewMore.isHidden =  totalRecoreds < 5
                cell.viewViewMore.isHidden =  totalRecoreds < 5
                if !isDone || self.viewModel.arrSimilarProduct.count == 0 {
                    self.clvProducts.superview?.isHidden = true
                }
                cell.clvProducts.reloadData()
            }
            cell.completion = { isDone in
                if isDone ?? false {
                    self.apiCalling()
                }
            }
            cell.btnViewMore.addTapGesture {
                self.coordinator?.navigateToSimilarProductList(productId: self.productID, cateID: self.viewModel.productDetails?.product?.subSubCategoryID ?? "")
            }
            cell.lblNewArrival.isHidden = true
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.clvProductImages{
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
   
}

/// Will redirect to Product detail screen when user click on product cell from nested collection view
extension ProductDetailVC: ProductViewCellDelegate {
    func didSelectItemInCell(at indexPath: IndexPath) {
//        self.coordinator?.navigateToProductDetail(productId: "5", type: .goodsDefault)
    }
}

// MARK: TableView DataSource Methods
extension ProductDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProductKpis()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProductDetailsKpisTableCell
        cell.configData(model: viewModel.setProductKpis(row: indexPath.row))
        return cell
    }
}
