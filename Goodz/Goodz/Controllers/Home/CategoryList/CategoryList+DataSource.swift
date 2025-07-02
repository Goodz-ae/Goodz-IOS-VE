//
//  CategoryList+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

extension CategoryListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !(self.openType == .comeFrromCustomization || self.openType == .comeFromFilter) {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MyAccountCell
            cell.selectionStyle = .none
            cell.setSubCollectionCategory(data: self.viewModel.setCollectionCategories(row: indexPath.row), lastRow: self.viewModel.numberOfRows(), currentRow: indexPath.row)
            
            return cell
        } else {
            let cellCustomization = tableView.dequeueReusableCell(indexPath: indexPath) as CustomizationItemCell
            cellCustomization.btnSelect.isUserInteractionEnabled = false
            cellCustomization.selectionStyle = .none
            cellCustomization.setSubCollectionCategory(data: self.viewModel.setCollectionCategories(row: indexPath.row), lastRow: self.viewModel.numberOfRows()-1, currentRow: indexPath.row)
            let subCategoryModel = self.viewModel.setCollectionCategories(row: indexPath.row)
            let commonSubIDs = Set(self.viewModel.arrSubCollectionCategory.compactMap { $0.categoryCollectionId })
                .intersection(Set(self.arrSelectedCategory.compactMap { $0.categoryCollectionId }))
            if let categoriesSubId = subCategoryModel.categoryCollectionId,
               commonSubIDs.contains(categoriesSubId) {
                cellCustomization.btnSelect.isSelected = true
            } else {
                cellCustomization.btnSelect.isSelected = false
            }
            return cellCustomization
        }
    }
    
}
