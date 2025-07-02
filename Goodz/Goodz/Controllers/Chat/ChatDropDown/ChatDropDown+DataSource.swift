//
//  ChatDropDown+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 20/12/23.
//

import UIKit

extension ChatDropDownVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrDropDown.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ChatDropDownCell
        let data = arrDropDown[indexPath.row]
        cell.selectionStyle = .none
        
        cell.setUpData(data: data)
        
        return cell
    }
    
}
