//
//  SearchVC+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 12/12/23.
//

import UIKit

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.btnStore.isSelected {
            if let id = self.viewModel.setStore(row: indexPath.row).storeID {
                self.coordinator?.navigateToPopularStore(storeId: id)
            }
        } else {
            switch indexPath.section {
            case 0:
                self.pageStore = 1
                self.coordinator?.navigateToSearchProductList(search: self.viewModel.setDataOfRecentSearch(row: indexPath.row)) { status in}
            case 1:
                self.coordinator?.navigateToProductList(title: Labels.goodzDeals, isGoodzDeal: Status.one.rawValue)
            case 2:
                let catData  = self.viewModel.getCategories(row: indexPath.row)
                self.coordinator?.navigateToSubCategory(openType: .other, title: catData.categoriesMainTitle ?? "", categoryMain: catData, completion: nil)
            default: break
            }
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let recentSearchData = self.viewModel.searchData.recentData ?? []
        if self.btnProduct.isSelected, section == 0, !recentSearchData.isEmpty {
            /// Recent search header view
            let viewHeader = UIView(frame: CGRect(x: 0, y: 16, width: screenWidth, height: 36))
            
            let lblRecentSearch = UILabel(frame: CGRect(x: 15, y: 16, width: screenWidth/2, height: 24))
            lblRecentSearch.text = Labels.recentSearch
            lblRecentSearch.textColor = .themeBlack
            lblRecentSearch.font(font: .semibold, size: .size16)
            
            let lblClearAll = UILabel(frame: CGRect(x: screenWidth/2, y: 16, width: screenWidth/2 - 24, height: 24))
            lblClearAll.text = Labels.clearAll
            lblClearAll.textColor = .themeBlack
            lblClearAll.textAlignment = .right
            lblClearAll.font(font: .medium, size: .size16)
            
            lblClearAll.addTapGesture {
                UserDefaults.standard.clearRecentSearch()
                self.page = 1
                self.apiCalling()
                tableView.reloadData()
            }
            
            viewHeader.addSubview(lblRecentSearch)
            viewHeader.addSubview(lblClearAll)
            return viewHeader
        } else {
            return nil
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let recentSearchData = self.viewModel.searchData.recentData ?? []
        // Determine section header height
        if self.btnProduct.isSelected, section == 0 {
            /// Return height for the Recent Search header section
            /// `52` = `16`(section space) + `36`(Header View Height)
            return recentSearchData.isEmpty ? 0.1 : 52
        } else {
            /// Return the space between two sections
            return 16
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.btnProduct.isSelected {
            let total = self.viewModel.numberOfCategoryMain()
            if indexPath.section == 2 {
                if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
                    self.page += 1
                    self.apiCalling()
                }
            }
        } else {
            let totalRecords = self.viewModel.numberOfStore()
            // Check if the last row is visible and if the total store records are greater than the current count
            if indexPath.row == totalRecords - 1 && self.viewModel.totalStore > totalRecords {
                self.pageStore += 1
                self.storeApiCalling(search: self.strSearch)
            }
        }
    }
    
    // --------------------------------------------
    
}
