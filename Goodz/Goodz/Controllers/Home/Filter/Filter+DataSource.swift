//
//  Filter+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

extension FilterVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAccountCell.reuseIdentifier) as? MyAccountCell else {
            return UITableViewCell()
        }
        
        let data = arrFilter[indexPath.row]
        let row = self.arrFilter.count
        
        cell.selectionStyle = .none
        
        cell.setFilterData(data: data, lastRow: row, currentRow: indexPath.row)
        
        return cell
    }
}
