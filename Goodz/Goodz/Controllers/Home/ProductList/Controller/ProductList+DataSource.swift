//
//  ProductList+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

// MARK: CollectionView DataSource Methods
extension ProductListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case clvFilter:
            return arrFilter.count
        case clvProductList:
            return self.viewModel.numberOfRows()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case clvFilter:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as CategoryViewCell
            let data = arrFilter[indexPath.row]
            
            if data.icon == nil {
                cell.ivCategory.isHidden = true
                cell.ivDropDown.isHidden = false
            } else {
                cell.ivCategory.image = data.icon
                cell.ivCategory.isHidden = false
                cell.ivDropDown.isHidden = true
            }
            
            cell.lblTitle.text = data.title
            
            /// Default first item selected
            if data.isSelected ?? false {
                cell.viewBg.backgroundColor = .themeGreen
                cell.ivCategory.tintColor = .white
                cell.lblTitle.textColor = .white
                cell.ivDropDown.tintColor = .white
            } else {
                cell.viewBg.backgroundColor = .white
                cell.ivCategory.tintColor = .black
                cell.lblTitle.textColor = .black
                cell.ivDropDown.tintColor = .black
            }
            
            return cell
        case clvProductList:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as MyProductCell
            let data = self.viewModel.setSubCategories(row: indexPath.row)
            cell.setProductData(data: data)
            cell.vwLike.superview?.addTapGesture {
                
                if UserDefaults.isGuestUser {
                    appDelegate.setLogin()
                } else {
                    self.viewModel.addRemoveFavourite(isFav: (data.isFav == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue) ?? Status.zero.rawValue, productId: data.productID ?? "") { isDpne in
                        if isDpne {
                            self.page = 1
                            if let indexForCellClicked = collectionView.indexPath(for: cell) {
                                if data.isFav == "0" {
                                    cell.ivHeart.image = .icHeartFill
                                    self.viewModel.arrProducts[indexForCellClicked.row].isFav = "1"
                                    // Increment the totalLikes value
                                    if let currentLikes = Int(self.viewModel.arrProducts[indexForCellClicked.row].totalLike ?? "0") {
                                        self.viewModel.arrProducts[indexForCellClicked.row].totalLike = "\(currentLikes + 1)" // Increment by 1
                                    }
                                } else {
                                    cell.ivHeart.image = .icHeart
                                    self.viewModel.arrProducts[indexForCellClicked.row].isFav = "0"
                                    // Decrement the totalLikes value
                                    if let currentLikes = Int(self.viewModel.arrProducts[indexForCellClicked.row].totalLike ?? "0") {
                                        self.viewModel.arrProducts[indexForCellClicked.row].totalLike = "\(currentLikes - 1)" // Decrement by 1
                                    }
                                }
                                collectionView.reloadItems(at: [indexForCellClicked])
                            } else {
                                print("Index is not there")
                            }
                        }
                    }
                }
                
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
