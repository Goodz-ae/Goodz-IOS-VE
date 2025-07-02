//
//  Chat+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

extension ChatVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfChts()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ChatListCell
        let data = self.viewModel.setChat(row: indexPath.row)
        cell.selectionStyle = .none
        cell.setData(data: data)
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfChts()
        
        if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
            self.page += 1
            self.apiCalling()
        }
        
    }
    
    // --------------------------------------------
    
}
