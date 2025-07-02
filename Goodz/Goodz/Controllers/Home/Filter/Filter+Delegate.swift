//
//  Filter+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

extension FilterVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = arrFilter[indexPath.row]
        var selectedData = self.filterData
        switch data.title {
            
        case Labels.color:
            
            self.coordinator?.navigateToColor(selectedColor: self.filterData?.color ?? [], isMultipleSelection: true, id: "") { colors in
                data.description = colors?.compactMap { $0.title }.joined(separator: ", ") ?? ""
                selectedData?.color = colors ?? []
                self.saveData(row: indexPath.row, selectedData: selectedData, data: data)
            }
            
        case Labels.material :
            self.coordinator?.navigateToMaterial(selectedMaterial: self.filterData?.material ?? [], isMultipleSelection: true, id: "", completion: { materials in
                selectedData?.material = materials ?? []
                data.description = materials?.compactMap { $0.title }.joined(separator: ", ") ?? ""
                self.saveData(row: indexPath.row, selectedData: selectedData, data: data)
            })
            
        case Labels.brands :
            self.coordinator?.navigateToBrands(selectedBrands: self.filterData?.brand ?? [], isMultipleSelection: true, id: "", completion: { brands in
                selectedData?.brand = brands ?? []
                data.description = brands?.compactMap { $0.brandTitle }.joined(separator: ", ") ?? ""
                self.saveData(row: indexPath.row, selectedData: selectedData, data: data)
            })
            
        case Labels.condition :
            self.coordinator?.navigateToCondition(selectedConditions: self.filterData?.condition ?? [], isMultipleSelection: true, id: "", completion: { selectedMaterial in
                selectedData?.condition = selectedMaterial ?? []
                data.description = selectedMaterial?.compactMap { $0.conditionTitle }.joined(separator: ", ") ?? ""
                self.saveData(row: indexPath.row, selectedData: selectedData, data: data)
            })
            
        case Labels.category :
            self.coordinator?.navigateToSuperCategoryList(selectedData: self.filterData?.collectionCategory ?? [] ,openType: .comeFromFilter, title: Labels.categories, completion: nil)
            self.saveData(row: indexPath.row, selectedData: selectedData, data: data)
            
        case Labels.price :
            self.coordinator?.navigateToPrice(maxPrice: self.filterData?.priceMax ?? "", minPrice: self.filterData?.priceMin ?? "", isPrice: true, completion: { maxPrice, minPrice in
                selectedData?.priceMax = maxPrice
                selectedData?.priceMin = minPrice
                data.description = maxPrice + "-" + minPrice
                self.saveData(row: indexPath.row, selectedData: selectedData, data: data)
            })
            
        case Labels.dimensions :
            self.coordinator?.navigateToDimension(width: self.filterData?.dimensionsWidth ?? "", weigth: self.filterData?.dimensionsWeight ?? "", heigth: self.filterData?.dimensionsHeight ?? "", length: self.filterData?.dimensionsLength ?? "", isPrice: false, completion: { kWidth, kWeigth, kHeigth, kLength in
                selectedData?.dimensionsWidth = kWidth
                selectedData?.dimensionsWeight = kWeigth
                selectedData?.dimensionsHeight = kHeigth
                selectedData?.dimensionsLength = kLength
                
                let demension1 = "H" + kHeigth + "; L" + kLength + "; W"
                let demension2 = kWidth + ", " + kWeigth + "kg"
                let demension3 = demension1 + "," + demension2
                data.description = demension3
                self.saveData(row: indexPath.row, selectedData: selectedData, data: data)
            })
        default: break
        }
        
    }
    
    func saveData(row : Int,selectedData :ProductListParameter?,data: FilterDataModel) {
        self.arrFilter[row] = data
        self.filterData = selectedData
        self.setUp()
        
    }
}
