//
//  CategoryList+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

extension CategoryListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.setCollectionCategories(row: indexPath.row)
        self.categoryCollection = data
        switch self.openType {
        case .comeFromSell:
            self.completion?(categoryMain, categorySub, categoryCollection)
            self.coordinator?.popToSellVC(SellVC.self, animated: true, self.categoryMain, self.categorySub, self.categoryCollection)
        case .comeFrromCustomization:
            let selectedRow = self.viewModel.setCollectionCategories(row: indexPath.row)
            if let index = arrSelectedCategory.firstIndex(where: { $0.categoryCollectionId == selectedRow.categoryCollectionId }) {
                // Item is already selected, remove it {
                self.arrSelectedCategory.remove(at: index)
            } else {
                self.arrSelectedCategory.append(selectedRow)
            }
            self.tbvCategory.reloadData()
        case .comeFromFilter:
            let selectedRow = self.viewModel.setCollectionCategories(row: indexPath.row)
            if let index = arrSelectedCategory.firstIndex(where: { $0.categoryCollectionId == selectedRow.categoryCollectionId }) {
                // Item is already selected, remove it {
                self.arrSelectedCategory.remove(at: index)
            } else {
                self.arrSelectedCategory.append(selectedRow)
            }
            self.tbvCategory.reloadData()
            
        case .other:
            self.coordinator?.navigateToProductList(title: self.viewModel.setCollectionCategories(row: indexPath.row).categoryCollectionTitle ?? Labels.category, categoryMain: self.categoryMain, categorySub: self.categorySub, categoryCollection : [data])
            
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfRows()
        
        if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
            self.page += 1
            self.apiCalling()
        }
        
    }
    
}
