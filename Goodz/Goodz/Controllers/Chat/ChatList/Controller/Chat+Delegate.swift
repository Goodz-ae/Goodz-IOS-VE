//
//  Chat+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

extension ChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.setChat(row: indexPath.row)
        let block : Bool = data.isBlocked == "0" ? false : true
        self.coordinator?.navigateToChatDetail(isBlock: block, chatId: data.chatID ?? "", userId: data.userID ?? "")
    }
    
}
