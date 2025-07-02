//
//  ChatDetailSeller+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 21/12/23.
//

import UIKit

extension ChatDetailSellerVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ChatViewCell
        let data = arrChats[indexPath.row]
        cell.selectionStyle = .none
        
        cell.viewReceiver.isHidden = true
        cell.viewSender.isHidden = true
        cell.viewOther.isHidden = true
        cell.viewReceiveImage.isHidden = true
        cell.viewSendImage.isHidden = true
        cell.viewContactPickUp.isHidden = true
        
        switch data.chatType {
        case .sender:
            cell.viewSender.isHidden = false
            cell.lblSenderChat.text = data.chat
            cell.lblSenderTime.text = data.chatTime
        case .receiver:
            cell.viewReceiver.isHidden = false
            cell.lblReceiverChat.text = data.chat
            cell.lblReceiverTime.text = data.chatTime
        case .receiveAttachment:
            cell.viewReceiveImage.isHidden = false
            cell.ivReceive.image = data.image
            cell.lblReceiveImageTime.text = data.chatTime
        case .sendAttachment:
            cell.viewSendImage.isHidden = false
            cell.ivSend.image = data.image
            cell.lblSendImageTime.text = data.chatTime
        case .other:
            cell.viewOther.isHidden = false
            cell.lblOther.text = data.chat
        case .checkOut:
            cell.viewContactPickUp.isHidden = false
            cell.lblPickUp.addTapGesture {
                self.coordinator?.presentToCalender(chatId: "", toId: "", isSelectPickupAddress: "")
            }
            cell.lblContactUs.addTapGesture {
                self.coordinator?.navigateToContactUsVC(chatId: "", bundleId: "", productId: "")
            }
            
        case .offerView:
            // Handle offer view case
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch arrChats.last?.chatType {
        case .offerView:
            return 401
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch arrChats.last?.chatType {
        case .offerView:
            guard let offerView = UINib(nibName: "OfferView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as? OfferView else {
                return nil
            }
            
            offerView.setUserType(userType: .seller)
            
            offerView.lblAcceptOffer.addTapGesture {
                self.viewModel.offerAcceptDeclineAPI(chatId: "2", acceptStatus: "1", sellerId: "3") { status in
                    if status {
                        self.arrChats.removeLast()
                        self.arrChats.append(ChatModel(chat: "You have accepted Alyjon Carol's offer of AED 280.", chatTime: "", chatType: .other))
                        self.arrChats.append(ChatModel(chat: "Buyer has proceed to check out Please chose a pick up date in the next 72 hours", chatTime: "", chatType: .other))
                        self.arrChats.append(ChatModel(chat: "", chatTime: "", chatType: .checkOut))
                        self.tbvChats.reloadData()
                    }
                }
            }
            
            offerView.lblDecline.addTapGesture {
                self.viewModel.offerAcceptDeclineAPI(chatId: "3", acceptStatus: "0", sellerId: "2") { status in
                    if status {
                        self.arrChats.removeLast()
                        self.arrChats.append(ChatModel(chat: "You have declined Alyjon Carol's offer of AED 280.", chatTime: "", chatType: .other))
                        self.tbvChats.reloadData()
                    }
                }
            }
            
            return offerView
        default:
            return nil
        }
        
        //        guard let suggestionChatView = UINib(nibName: "SuggestionChatView", bundle: nil)
        //            .instantiate(withOwner: self, options: nil)
        //            .first as? SuggestionChatView else {
        //            return nil
        //        }
        
    }
    
}
