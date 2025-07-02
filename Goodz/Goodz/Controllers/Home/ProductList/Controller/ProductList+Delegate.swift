//
//  ProductList+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

// MARK: CollectionView Delegate Methods
extension ProductListVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case clvFilter:
            var data = arrFilter[indexPath.row]
            var selectedData = self.filterData
            switch data.title {
            case Labels.filter :
                self.coordinator?.navigateToFilter(filerData: self.filterData ?? kProductListParameter, completion: { filter in
                    self.filterData = filter
                    self.setProductListAPI()
                })
            case Labels.color:
                self.coordinator?.navigateToColor(selectedColor: self.filterData?.color ?? [], isMultipleSelection: true, id: "") { colors in
                    selectedData?.color = colors ?? []
                    self.saveData(row: indexPath.row, data: data,selectedData: selectedData)
                }
                
            case Labels.material :
                self.coordinator?.navigateToMaterial(selectedMaterial: self.filterData?.material ?? [], isMultipleSelection: true, id: "", completion: { materials in
                    selectedData?.material = materials ?? []
                    self.saveData(row: indexPath.row, data: data,selectedData: selectedData)
                })
                
            case Labels.brands :
                self.coordinator?.navigateToBrands(selectedBrands: self.filterData?.brand ?? [], isMultipleSelection: true, id: "", completion: { brands in
                    selectedData?.brand = brands ?? []
                    self.saveData(row: indexPath.row, data: data,selectedData: selectedData)
                })
                
            case Labels.condition :
                self.coordinator?.navigateToCondition(selectedConditions: self.filterData?.condition ?? [], isMultipleSelection: true, id: "", completion: { selectedMaterial in
                    selectedData?.condition = selectedMaterial ?? []
                    self.saveData(row: indexPath.row, data: data,selectedData: selectedData)
                })
                
            case Labels.category :
                self.coordinator?.navigateToSuperCategoryList(selectedData: self.filterData?.collectionCategory ?? [] ,openType: .comeFromFilter, title: Labels.categories, completion: nil)
                self.saveData(row: indexPath.row, data: data,selectedData: selectedData)
                
            case Labels.price :
                self.coordinator?.navigateToPrice(maxPrice: self.filterData?.priceMax ?? "", minPrice: self.filterData?.priceMin ?? "", isPrice: true, completion: { maxPrice, minPrice in
                    selectedData?.priceMax = maxPrice
                    selectedData?.priceMin = minPrice
                    self.saveData(row: indexPath.row, data: data,selectedData: selectedData)
                })
                
            case Labels.dimensions :
                self.coordinator?.navigateToDimension(width: self.filterData?.dimensionsWidth ?? "", weigth: self.filterData?.dimensionsWeight ?? "", heigth: self.filterData?.dimensionsHeight ?? "", length: self.filterData?.dimensionsLength ?? "", isPrice: false, completion: { kWidth, kWeigth, kHeigth, kLength in
                    selectedData?.dimensionsWidth = kWidth
                    selectedData?.dimensionsWeight = kWeigth
                    selectedData?.dimensionsHeight = kHeigth
                    selectedData?.dimensionsLength = kLength
                    
                    self.saveData(row: indexPath.row, data: data,selectedData: selectedData)
                })
                
            default: break
                
            }
            
        case clvProductList:
            let data = self.viewModel.setSubCategories(row: indexPath.row)
            if data.isOwner == "1" {
                self.coordinator?.navigateToSellProductDetail(storeId: "", productId: data.productID ?? "", type: .sell)
            } else {
                self.coordinator?.navigateToProductDetail(productId: data.productID ?? "", type: .goodsDefault)
            }
            
        default: break
            
        }
        
    }
    
    func saveData(row : Int, data : CategoryData, selectedData :ProductListParameter?) {
        //        zlf.ø̛[row] = data
        self.filterData = selectedData
        self.arrFilterTypes()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        switch collectionView {
        case clvFilter:
            return 0.0
        case clvProductList:
            return 15.0
        default:
            return 0.0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case clvFilter:
            return 0.0
        case clvProductList:
            return 15.0
        default:
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case clvFilter:
            return CGSize(width: 50, height: 45)
        case clvProductList:
            let wid = ((clvProductList.frame.size.width)/2)-8
            return CGSize(width: wid , height: wid + 95)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfRows()
        if collectionView == self.clvProductList {
            if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
                self.page += 1
                self.apiCalling()
            }
        }
    }
}
