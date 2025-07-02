//
//  SubCategory+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

extension SubCategoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.setSubCategories(row: indexPath.row)
        self.categorySubId = data
        self.coordinator?.navigateToCategory(selectedData: self.selectedData, openType: self.opeonType, title: data.categoriesSubTitle ?? "", categoryMain: self.categoryMain, subCategory: data, customizationModels: customizationModel, completion: completion)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfRows()
        
        if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
            self.page += 1
            self.apiCalling()
        }
        
    }
}
