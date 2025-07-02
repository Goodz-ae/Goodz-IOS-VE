//
//  SelectDateTime+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 28/12/23.
//

import UIKit

extension SelectDateAndTimeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfTimeSlots()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TimeCell
        
        cell.lblTitle.text = self.viewModel.setTimeSlots(row: indexPath.row).timeSlot
        cell.mainView.cornerRadius(cornerRadius: 4.0)
        
        if self.selectedIndex == indexPath.row {
            cell.mainView.border(borderWidth: 1.0, borderColor: .themeGreen)
        } else {
            cell.mainView.border(borderWidth: 0.5, borderColor: .lightGray)
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
