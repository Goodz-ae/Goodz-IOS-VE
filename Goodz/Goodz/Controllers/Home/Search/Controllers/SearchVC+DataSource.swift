//
//  SearchVC+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 12/12/23.
//

import UIKit

extension SearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.btnProduct.isSelected {
            return self.viewModel.numberOfSection()
        } else {
            return 1
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.btnProduct.isSelected {
            /// `Products`
            switch section {
            case 0 :
                return self.viewModel.numberOfRecentSearch()
            case 1:
                return 1
            case 2:
                return self.viewModel.numberOfCategoryMain()
            default:
                return 0
            }
        } else {
            /// `Stores`
            return self.viewModel.numberOfStore()
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.btnProduct.isSelected {
            /// `Products`
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(indexPath: indexPath) as RecentSearchCell
                let data = self.viewModel.setDataOfRecentSearch(row: indexPath.row)
                let arrRecentSearch = self.viewModel.searchData.recentData ?? []
                cell.setData(data: data)
                cell.ivCross.addTapGesture {
                    let removeId = self.viewModel.removeRecentSearch(row: indexPath.row)
                    UserDefaults.standard.clearRecentSearch()
                    UserDefaults.recentSearch = self.viewModel.searchData.recentData ?? []
                    self.page = 1
                    self.apiCalling()
                    tableView.reloadData()
                    
                }
                return cell
            case 1,2:
                let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MyAccountCell
                if indexPath.section == 1 {
                    cell.lblTitle.text = Labels.goodzDeals
                    cell.imgTitle.image = .iconGoodz
                    cell.lblTitle.color(color: .themeGoodz)
                    cell.btnRight.isHidden = true
                } else {
                    let catData = self.viewModel.getCategories(row: indexPath.row)
                    cell.setCategory(data: catData, lastRow: self.viewModel.numberOfCategoryMain(), currentRow: indexPath.row)
                    cell.lblTitle.color(color: .themeBlack)
                }
                return cell
            default:
                return UITableViewCell()
                
            }
        } else {
            /// `Stores`
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as FollowerCell
            let data = self.viewModel.setStore(row: indexPath.row)
            cell.setStoreData(data: data, lastRow: self.viewModel.numberOfStore(), currentRow: indexPath.row)
            return cell
        }
    }
    
    // --------------------------------------------
    
}
