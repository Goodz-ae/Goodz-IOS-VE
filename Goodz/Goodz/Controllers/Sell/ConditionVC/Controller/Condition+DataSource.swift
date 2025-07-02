//
//  Condition+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

extension ConditionVC: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as SingleSelectionCell
        cell.selectionStyle = .none
        let data = self.viewModel.setCondition(row: indexPath.row)
        cell.setConditionData(data: data)
        if self.isMultipleSelection {
            let isSelected = self.arrSelectCondition.contains { $0.conditionID == data.conditionID }
            cell.ivCheck.image = isSelected ? .icCheckboxSqr : .iconUncheckBox
        } else {
            cell.ivCheck.image = (self.viewModel.setCondition(row: indexPath.row).conditionID == self.selectedID) ? .icCheckRound : .icUncheckRound
        }
        return cell
    }
}
