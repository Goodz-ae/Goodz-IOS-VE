//
//  ChatDropDown+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 20/12/23.
//

import UIKit

extension ChatDropDownVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            self.viewModel.blockUserAPI(toId: self.userId, chatId: self.chatId) { status in
//                if status {
                    self.dismiss()
//                }
//            }
            let  block = self.isBlock == "1" ? Labels.unblock : Labels.block
            let msg = self.isBlock == "1" ? Labels.areYouSureYouWantToUnBlockThisUser : Labels.areYouSureYouWantToBlockThisUser
            self.coordinator?.showChatPopUp(title: block, description: msg, chatID: self.chatId, toID: self.userId, isBlock : self.isBlock, type: .chatBlock) { status in}
        } else if indexPath.row == 1 {
//            self.viewModel.reportUserAPI(toId: self.userId, chatId: self.chatId) { status in
//                if status {
                    self.dismiss()
//                }
//            }
            self.coordinator?.showChatPopUp(title: Labels.reportUser, description: Labels.areYouSureYouWantToReportThisUser, chatID: self.chatId, toID: self.userId, type: .chatReport) { status in}
        } else if indexPath.row == 2 {
//            self.viewModel.deleteChatAPI(toId: self.userId, chatId: self.chatId) { status in
//                if status {
                    self.dismiss()
//                }
//            }
            self.coordinator?.showChatPopUp(title: Labels.deleteChat, description: Labels.areYouSureYouWantToDeleteThisChat, chatID: self.chatId, toID: self.userId, type: .chatDelete) { status in}
        } else {}
        
    }
    
}
