//
//  ProductView+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 11/12/23.
//

import UIKit

extension ProductViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch openStyle {
        case .other :
            return 1
        case .similar :
            return self.arrSimilarProducts.count
        case .popularProduct :
            return self.arrPopularProduct.count
        case  .goodzDeals:
            return self.arrGoodzProduct.count
        case .popularStore:
            return self.arrPopularStore[section].productList?.count ?? 0
        case .popularStoresProducts:
            if collectionView == clvProducts {
                return self.arrStorePopularProduct.count
            }else if collectionView ==  clvNewArrival {
                return self.arrStorePopularNewArrival.count
            }else{
                return 0
            }
        }
        
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as MyProductCell
        switch openStyle {
        case .other :
            break
        case .similar :
            let data = self.arrSimilarProducts[indexPath.row]
            cell.setSimilarProduct(data: data)
            cell.vwLike.superview?.addTapGesture {
                
                if UserDefaults.isGuestUser {
                    appDelegate.setLogin()
                } else {
                    notifier.showLoader()
                    self.addRemoveFavourite(isFav: data.isFav == Status.one.rawValue ? Status.zero.rawValue : Status.one.rawValue, productId: data.productID ?? "") { isDone, fromFav in
                        notifier.hideLoader()
                        self.completion(isDone)
                    }
                }
            }
            cell.ivHeart.superview?.tag = indexPath.row
        case .popularProduct :
            let dataPopularStore = self.arrPopularProduct[indexPath.row]
            print("Jigzz : 2 \(dataPopularStore)")
            handleProductCell(cell, data: dataPopularStore, collectionView: collectionView)
        case .goodzDeals :
            let dataPopularStore = self.arrGoodzProduct[indexPath.row]
            handleProductCell(cell, data: dataPopularStore, collectionView: collectionView)
        case .popularStore:
            let storeProduct = self.arrPopularStore[indexPath.section].productList?[indexPath.row]
            
        case .popularStoresProducts:
            if collectionView == clvProducts {
                let dataPopularStore = self.arrStorePopularProduct[indexPath.row]
                handleProductCell(cell, data: dataPopularStore, collectionView: collectionView)
            }else if collectionView ==  clvNewArrival {
                let dataPopularStore = self.arrStorePopularNewArrival[indexPath.row]
                handleProductCell(cell, data: dataPopularStore, collectionView: collectionView)
            }
        }
        return cell
    }
    
    // --------------------------------------------
    
    func addRemoveFavourite(isFav: String, productId : String, completion: @escaping((Bool, Bool) -> Void)) {
        GlobalRepo.shared.addFavRemoveFavAPI(isFav, productId) { status, fromFav,error in
            completion(status, fromFav)
        }
    }
    
    // --------------------------------------------
    
    func handleProductCell(_ cell: MyProductCell, data: ProductList, collectionView: UICollectionView) {
        cell.setHomeData(data: data)
        cell.ivHeart.superview?.addTapGesture {
            
            if UserDefaults.isGuestUser {
                appDelegate.setLogin()
            } else {
                cell.ivHeart.isUserInteractionEnabled = false
                self.addRemoveFavourite(isFav: data.isLike == Status.zero.rawValue ? Status.one.rawValue : Status.zero.rawValue, productId: data.productID ?? "") { (isDone, fromFav) in
                    cell.ivHeart.isUserInteractionEnabled = true
                    if fromFav {
                        if let indexForCellClicked = collectionView.indexPath(for: cell) {
                            if data.isLike == "0" {
                                cell.ivHeart.image = .icHeart
                                switch self.openStyle {
                                case .other:
                                    break
                                case .similar:
                                    break
                                case .goodzDeals:
                                    self.arrGoodzProduct[indexForCellClicked.row].isLike = "1"
                                    // Increment the totalLikes value
                                    if let currentLikes = Int(self.arrGoodzProduct[indexForCellClicked.row].totalLike ?? "0") {
                                        self.arrGoodzProduct[indexForCellClicked.row].totalLike = "\(currentLikes + 1)" // Increment by 1
                                    }
                                case .popularProduct:
                                    self.arrPopularProduct[indexForCellClicked.row].isLike = "1"
                                    // Increment the totalLikes value
                                    if let currentLikes = Int(self.arrPopularProduct[indexForCellClicked.row].totalLike ?? "0") {
                                        self.arrPopularProduct[indexForCellClicked.row].totalLike = "\(currentLikes + 1)" // Increment by 1
                                    }
                                case .popularStore:
                                    break
                                case .popularStoresProducts:
                                    if collectionView == self.clvProducts {
                                        self.arrStorePopularProduct[indexForCellClicked.row].isLike = "1"
                                        // Increment the totalLikes value
                                        if let currentLikes = Int(self.arrStorePopularProduct[indexForCellClicked.row].totalLike ?? "0") {
                                            self.arrStorePopularProduct[indexForCellClicked.row].totalLike = "\(currentLikes + 1)" // Increment by 1
                                        }
                                    } else if collectionView == self.clvNewArrival{
                                        self.arrStorePopularNewArrival[indexForCellClicked.row].isLike = "1"
                                        // Increment the totalLikes value
                                        if let currentLikes = Int(self.arrStorePopularNewArrival[indexForCellClicked.row].totalLike ?? "0") {
                                            self.arrStorePopularNewArrival[indexForCellClicked.row].totalLike = "\(currentLikes + 1)" // Increment by 1
                                        }
                                    }
                                }
                                
                            } else {
                                cell.ivHeart.image = .icHeartFill
                                switch self.openStyle {
                                case .other:
                                    break
                                case .similar:
                                    break
                                case .goodzDeals:
                                    self.arrGoodzProduct[indexForCellClicked.row].isLike = "0"
                                    // Decrement the totalLikes value
                                    if let currentLikes = Int(self.arrGoodzProduct[indexForCellClicked.row].totalLike ?? "0") {
                                        self.arrGoodzProduct[indexForCellClicked.row].totalLike = "\(currentLikes - 1)" // Decrement by 1
                                    }
                                case .popularProduct:
                                    self.arrPopularProduct[indexForCellClicked.row].isLike = "0"
                                    // Decrement the totalLikes value
                                    if let currentLikes = Int(self.arrPopularProduct[indexForCellClicked.row].totalLike ?? "0") {
                                        self.arrPopularProduct[indexForCellClicked.row].totalLike = "\(currentLikes - 1)" // Decrement by 1
                                    }
                                case .popularStore:
                                    break
                                case .popularStoresProducts:
                                    if collectionView == self.clvProducts {
                                        self.arrStorePopularProduct[indexForCellClicked.row].isLike = "0"
                                        // Decrement the totalLikes value
                                        if let currentLikes = Int(self.arrStorePopularProduct[indexForCellClicked.row].totalLike ?? "0") {
                                            self.arrStorePopularProduct[indexForCellClicked.row].totalLike = "\(currentLikes - 1)" // Decrement by 1
                                        }
                                    } else if collectionView == self.clvNewArrival{
                                        self.arrStorePopularNewArrival[indexForCellClicked.row].isLike = "0"
                                        // Decrement the totalLikes value
                                        if let currentLikes = Int(self.arrStorePopularNewArrival[indexForCellClicked.row].totalLike ?? "0") {
                                            self.arrStorePopularNewArrival[indexForCellClicked.row].totalLike = "\(currentLikes - 1)" // Decrement by 1
                                        }
                                    }
                                }
                            }
                            collectionView.reloadItems(at: [indexForCellClicked])
                        } else {
                            print("Index for cell not found.")
                        }
                    } else {
                        self.completion(isDone)
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
}
