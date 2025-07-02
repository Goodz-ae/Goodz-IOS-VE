//
//  SuperCategory+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 27/12/23.
//

import UIKit

extension SuperCategoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.setSubCategories(row: indexPath.row)
        if data.categoriesMainId == "-1" {
            self.coordinator?.navigateToProductList(title: Labels.products)
        }else{
            self.coordinator?.navigateToSubCategory(selectedData: self.selectedData,openType: self.opeonType, title: data.categoriesMainTitle ?? "", categoryMain: data, completion: completion)
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfRows()
        
        if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
            self.page += 1
            self.apiCalling()
        }
    }
    
    // --------------------------------------------
    
}
