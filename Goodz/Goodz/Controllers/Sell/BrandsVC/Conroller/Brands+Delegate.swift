//
//  Brands+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

extension BrandsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isMultipleSelection {
            let selectedBrand = self.viewModel.setBrands(row: indexPath.row)
            if let index = self.arrSelectBrands.firstIndex(where: {$0.brandID == selectedBrand.brandID}) {
                self.arrSelectBrands.remove(at: index)
            } else {
                self.arrSelectBrands.append(selectedBrand)
            }
        } else {
            if self.selectedIndex == indexPath.row {
                self.selectedIndex = -1
                self.selectedID = ""
            } else {
                self.selectedID = self.viewModel.setBrands(row: indexPath.row).brandID ?? ""
                self.selectedIndex = indexPath.row
            }
        }
        self.view.endEditing(false)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if strSearch == "" {
            let total = self.viewModel.numberOfRows()
            if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
                self.page += 1
                self.apiCalling(isShowLoader: true)
            }
        }
    }
}
