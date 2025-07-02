//
//  SuperCategory+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 27/12/23.
//

import UIKit

extension SuperCategoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MyAccountCell
        let data = self.viewModel.setSubCategories(row: indexPath.row)
        let row = self.viewModel.numberOfRows()
        
        cell.selectionStyle = .none
        
        cell.setCategory(data: data, lastRow: row, currentRow: indexPath.row)
        
        return cell
    }
    
    // --------------------------------------------
    
}
