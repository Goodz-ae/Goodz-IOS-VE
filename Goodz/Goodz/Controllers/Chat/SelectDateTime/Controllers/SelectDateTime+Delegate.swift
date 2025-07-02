//
//  SelectDateTime+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 28/12/23.
//

import UIKit

extension SelectDateAndTimeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tblview.reloadData()
    }
}
