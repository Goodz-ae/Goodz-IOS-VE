//
//  ChatDetailSeller+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 21/12/23.
//

import UIKit

extension ChatDetailSellerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
