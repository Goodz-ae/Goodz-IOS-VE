//
//  Condition+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

extension ConditionVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isMultipleSelection {
            let selectedBrand = self.viewModel.setCondition(row: indexPath.row)
            if let index = self.arrSelectCondition.firstIndex(where: {$0.conditionID == selectedBrand.conditionID}) {
                self.arrSelectCondition.remove(at: index)
            } else {
                self.arrSelectCondition.append(selectedBrand)
            }
        } else {
            self.selectedID = self.viewModel.setCondition(row: indexPath.row).conditionID ?? ""
            self.selectedIndex = indexPath.row
        }
        tableView.reloadData()
    }
    
    // --------------------------------------------
    
}
