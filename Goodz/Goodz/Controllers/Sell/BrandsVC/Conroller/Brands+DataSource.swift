//
//  Brands+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

extension BrandsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as SingleSelectionCell
        let data = self.viewModel.setBrands(row: indexPath.row)
        cell.selectionStyle = .none
        cell.setData(data: data)
        if self.isMultipleSelection {
            let isSelected = self.arrSelectBrands.contains { $0.brandID == data.brandID }
            cell.ivCheck.image = isSelected ? .icCheckboxSqr : .iconUncheckBox
        } else {
            cell.ivCheck.image = (self.viewModel.setBrands(row: indexPath.row).brandID == selectedID) ? .icCheckRound : .icUncheckRound
        }
        return cell
    }
    
    // --------------------------------------------
    
}
