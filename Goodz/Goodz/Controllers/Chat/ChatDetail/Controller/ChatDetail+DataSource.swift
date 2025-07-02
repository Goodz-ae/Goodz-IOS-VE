//
//  ChatDetail+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit

extension ChatDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.setChatMessage()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellStep =  tableView.dequeueReusableCell(indexPath: indexPath) as SellStepView
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ChatViewCell
        let data = self.viewModel.setChatRow(row: indexPath.row)
        cell.selectionStyle = .none
        cell.setChatDetails(data: data)
        cell.lblChange.addTapGesture {
            self.coordinator?.navigateToMyAddress()
        }
        if data.id == nil && data.productDetails != nil  {
            cellStep.setChatDetails(data: data)
            cellStep.firstFillBtn.addTapGesture {
                if cellStep.firstFillBtn.tag == 101 { // Confirm abailablity
                    //self.chatId, acceptStatus: Status.two.rawValue, sellerId: self.sellerID
                    let confirAvailbelity = ConfirAvailbelity(chat_id: self.chatId, deliveryMethod: data.delivery_method ?? "", available: "1", user_id:  UserDefaults.userID)
                    self.viewModel.chat_update_pickup_availability(messageData: confirAvailbelity) { status in
                        print("confirm0>>",status)
                        self.page = 1
                        self.apiCalling()
                        self.tbvChats.reloadData()
                    }
                } else  if cellStep.firstFillBtn.tag == 201 { // Choose Pickup Dates
                    self.coordinator?.slotBookingViewController(_slotOptions: data.slotOptions, slot_message_id: nil, completion: { [weak self] val in
                        
                        guard let self = self ,var confirAvailbelity = val else {
                            return
                        }
                        
                        confirAvailbelity.pickup_chat_id = self.chatId
                        confirAvailbelity.user_id = UserDefaults.userID
                        confirAvailbelity.token = UserDefaults.accessToken
                        
                        let jsonData = try? JSONEncoder().encode( confirAvailbelity.selected_slots  )
                        let jsonString = String(data: jsonData!, encoding: .utf8) ?? ""
                        /*
                        let valParam = slotBookingModelStr(token: UserDefaults.accessToken, selected_slots: jsonString, pickup_chat_id: self.chatId, message_id: "", user_id: UserDefaults.userID)
                        */
                        self.viewModel.chat_add_pickup_slots(param: confirAvailbelity ) { status in
                            print("confirm0>>",status)
                            self.page = 1
                            self.apiCalling()
                            self.tbvChats.reloadData()
                        }
                        
                    })
                    
                }else  if cellStep.firstFillBtn.tag == 301 { // Change Choose Pickup Dates
                    self.coordinator?.slotBookingViewController(_slotOptions: data.slotOptions , slot_message_id : data.slot_message_id  , completion: { [weak self] val in
                        guard let self = self ,var confirAvailbelity = val else {
                            return
                        }
                        
                        confirAvailbelity.pickup_chat_id = self.chatId
                        confirAvailbelity.user_id = UserDefaults.userID
                        confirAvailbelity.token = UserDefaults.accessToken
                        confirAvailbelity.message_id = data.slot_message_id ?? ""
                     //   let jsonData = try? JSONEncoder().encode( confirAvailbelity.selected_slots  )
                       // let jsonString = String(data: jsonData!, encoding: .utf8) ?? ""
                        /*
                        let valParam = slotBookingModelStr(token: UserDefaults.accessToken, selected_slots: jsonString, pickup_chat_id: self.chatId, message_id: "", user_id: UserDefaults.userID)
                        */
                        self.viewModel.chat_add_pickup_slots(param: confirAvailbelity ) { status in
                            print("confirm0>>",status)
                            self.page = 1
                            self.apiCalling()
                            self.tbvChats.reloadData()
                        }
                        
                    })
                }else if cellStep.firstFillBtn.tag == 401 {
                    if cellStep.selectedPickupSlots == nil {
                        self.showSimpleAlert(Message: "Please select slots")
                        return
                    }
                    let confirPickSlotModel = ConfirPickSlotModel(chat_id: self.chatId, choosen_pickup_date: (cellStep.selectedPickupSlots?.date ?? ""), choosen_pickup_time: "\(cellStep.selectedPickupSlots?.id ?? 0)"  , user_id:  UserDefaults.userID)
                    self.viewModel.chat_confirm_pickup_slot(messageData: confirPickSlotModel) { status in
                        print("confirm0>>",status)
                        self.page = 1
                        self.apiCalling()
                        self.tbvChats.reloadData()
                    }
                } else if cellStep.firstFillBtn.tag == 601 { // change address
                    self.coordinator?.navigateToMyAddress()
                }else if cellStep.firstFillBtn.tag == 701 { // add new item
                    self.coordinator?.popToSellVC(ChatVC.self, animated: true, nil, nil, nil)
                    self.coordinator?.setTabbar(selectedIndex: 2)
                }else if cellStep.firstFillBtn.tag == 801 { // Confrim PickUP
                    let confirec =  ConfrimReception(order_id: data.productDetails?.order_id ?? "" ,user_id:  UserDefaults.userID, token: UserDefaults.accessToken)
                    self.viewModel.confrimReception(param:confirec ){ status in
                        print("confirm0>>",status)
                        self.page = 1
                        self.apiCalling()
                        self.tbvChats.reloadData()
                    }
                }else if cellStep.firstFillBtn.tag == 901 { // Every Thinks is OK
                }
                else if cellStep.firstFillBtn.tag == 1001 { // change address
                    self.coordinator?.navigateToMyAddress()
                }
            }
            cellStep.secondEmptyBtn.addTapGesture {
                if cellStep.secondEmptyBtn.tag == 102 { // Confirm abailablity
                    //self.chatId, acceptStatus: Status.two.rawValue, sellerId: self.sellerID
                    let confirAvailbelity = ConfirAvailbelity( chat_id: self.chatId, deliveryMethod: data.delivery_method ?? "", available: "2", user_id:  UserDefaults.userID)
                    self.viewModel.chat_update_pickup_availability(messageData: confirAvailbelity) { status in
                        print("confirm0>>",status)
                        self.page = 1
                        self.apiCalling()
                        self.tbvChats.reloadData()
                    }
                } else if cellStep.secondEmptyBtn.tag == 202 { // Contact us
                   
                    
                    self.coordinator?.navigateToContactus()
                    
                }else if cellStep.secondEmptyBtn.tag == 302 { // Contact us
                    //self.coordinator?.slotBookingViewController()
                    self.coordinator?.navigateToContactus()
                }else if cellStep.secondEmptyBtn.tag == 402 { // Contact us
                    //self.coordinator?.slotBookingViewController()
                }else if cellStep.secondEmptyBtn.tag == 502 { // Contact us
                    //self.coordinator?.slotBookingViewController()
                    
                    self.coordinator?.showSlotChangePopup(pickup_slots: data.productDetails?.pickup_slots, selectedPickupSlots: nil) { slots in
                         
                        let confirPickSlotModel = ConfirPickSlotModel(chat_id: self.chatId, choosen_pickup_date: (slots?.date ?? ""), choosen_pickup_time: "\(slots?.id ?? 0)"  , user_id:  UserDefaults.userID , messageId : "\(data.productDetails?.choosen_pickup_slot?.choosen_slot_id ?? 0 )" )
                        self.viewModel.chat_confirm_pickup_slot(messageData: confirPickSlotModel) { status in
                            print("confirm0>>",status)
                            self.page = 1
                            self.apiCalling()
                            self.tbvChats.reloadData()
                        }
                    }
                    
                }else if cellStep.secondEmptyBtn.tag == 902 { // Every Thinks is OK
                    self.coordinator?.reportProblemViewController(_msgDate: data, completion: { status in
                        
                        self.showSimpleAlert(Message: "Reported problem successfully")
                    })
                }else if cellStep.secondEmptyBtn.tag == 802 { // report a problem
                    self.coordinator?.reportProblemViewController(_msgDate: data, completion: { status in
                        self.showSimpleAlert(Message: "Reported problem successfully")
                    })
                }
            }
            
            return cellStep
        }
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let data = self.viewModel.dataChatMainResponse
        if( data?.isSeller == Status.one.rawValue && data?.paymentDone == Status.one.rawValue && data?.offerAccepted == Status.one.rawValue  /* && data?.isSelectPickupDate == Status.one.rawValue*/) || (data?.isSeller == Status.one.rawValue && data?.isSelectPickupDate == Status.one.rawValue && data?.isSelectPickupAddress == Status.zero.rawValue) {
            return 150
        } else if data?.isSeller == Status.zero.rawValue && data?.offerAccepted == Status.one.rawValue {
            return 182
        } else if data?.offerReceived == Status.one.rawValue && (data?.offerAccepted == Status.zero.rawValue || data?.offerAccepted == Status.two.rawValue) {
            return 401
        } else if self.page == 1 && (self.viewModel.chatDetails.first?.messages?.count ?? 0) == 1 && self.viewModel.chatDetails.first?.messages?.first?.id == nil && self.isAPICalled {
            return tableView.frame.height
        } else {
            return 0
        }
        
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let data = self.viewModel.dataChatMainResponse
        let block: Int = Int(self.viewModel.chatDetails.first?.isBlocked ?? "") ?? 0
        if block == 0 && data?.isSeller == Status.one.rawValue && data?.isSelectPickupDate == Status.one.rawValue && data?.isSelectPickupAddress == Status.zero.rawValue && data?.deliveryMethod == Status.two.rawValue {
            return self.setPickUpAddressAndContactUsView()
        } else if block == 0 && data?.isSeller == Status.one.rawValue && data?.paymentDone == Status.one.rawValue && data?.offerAccepted == Status.one.rawValue && data?.deliveryMethod == Status.two.rawValue /*&& data?.isSelectPickupDate == Status.one.rawValue*/ {
            return self.setPickUpdateAndContactUsView()
        }  else if block == 0 && data?.isSeller == Status.zero.rawValue && data?.offerAccepted == Status.one.rawValue && data?.paymentDone == Status.zero.rawValue {
            return self.proceedToCheckoutView()
        } else if block == 0 && data?.offerReceived == Status.one.rawValue && (data?.offerAccepted == Status.zero.rawValue || data?.offerAccepted == Status.two.rawValue) {
            return self.offerAcceptDeclineView()
        } else if block == 0 && self.page == 1 && (self.viewModel.chatDetails.first?.messages?.count ?? 0) == 1 && self.viewModel.chatDetails.first?.messages?.first?.id == nil && self.isAPICalled {
            return self.setSuggestionChatView()
         } else {
            return UIView()
        }
    }
    
    // --------------------------------------------
    
    func setPickUpdateAndContactUsView() -> UIView {
        guard let cell = UINib(nibName: "ChatViewCell", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? ChatViewCell else {
            return UIView()
        }
        cell.viewContactPickUp.isHidden = false
        cell.lblPickUp.addTapGesture {
            self.coordinator?.presentToCalender(chatId: self.chatId, toId: self.viewModel.chatDetails.first?.userID ?? "", isSelectPickupAddress: self.viewModel.dataChatMainResponse?.isSelectPickupAddress ?? "0")
        }
        cell.lblContactUs.addTapGesture {
            self.coordinator?.navigateToContactUsVC(chatId: self.chatId, bundleId: "", productId: self.viewModel.chatDetails.first?.products?.first?.productID?.description ?? "")
        }
        return cell
    }
    
    // --------------------------------------------
    
    func setPickUpAddressAndContactUsView() -> UIView {
        guard let cell = UINib(nibName: "ChatViewCell", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? ChatViewCell else {
            return UIView()
        }
        cell.viewContactPickUp.isHidden = false
        cell.lblPickUp.text = Labels.chooseAPickupAddress
        cell.lblPickUp.addTapGesture {
            self.coordinator?.navigateToChatAddressVC(chatId: self.chatId, toId: self.sellerID)
        }
        cell.lblContactUs.addTapGesture {
            self.coordinator?.navigateToContactUsVC(chatId: self.chatId, bundleId: "", productId: self.viewModel.chatDetails.first?.products?.first?.productID?.description ?? "")
        }
        return cell
    }
    
    // --------------------------------------------
    
    func offerAcceptDeclineView() -> UIView {
        
        guard let offerView = UINib(nibName: "OfferView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? OfferView else {
            return UIView()
        }
        
        offerView.setProductDetails(chatMainResponse: self.viewModel.dataChatMainResponse, data: self.viewModel.setProductRow(row: 0), userType: .seller, name: self.viewModel.chatDetails.first?.name ?? "", productCount: self.viewModel.chatDetails.first?.products?.count ?? 0)
        offerView.lblAcceptOffer.addTapGesture {
            self.viewModel.offerAcceptDeclineAPI(chatId: self.chatId, acceptStatus: Status.one.rawValue, sellerId: self.sellerID) { status in
                if status {
                    self.page = 1
                    self.apiCalling()
                    self.tbvChats.reloadData()
                }
            }
        }
        
        offerView.lblDecline.addTapGesture {
            self.viewModel.offerAcceptDeclineAPI(chatId: self.chatId, acceptStatus: Status.two.rawValue, sellerId: self.sellerID) { status in
                if status {
                    self.page = 1
                    self.apiCalling()
                    self.tbvChats.reloadData()
                }
            }
        }
        
        return offerView
        
    }
    
    // --------------------------------------------
    
    func proceedToCheckoutView() -> UIView {
        guard let suggestionChatView = UINib(nibName: "OfferView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? OfferView else {
            return UIView()
        }
        suggestionChatView.setProductDetails(chatMainResponse: self.viewModel.dataChatMainResponse, data: self.viewModel.setProductRow(row: 0), userType: .buyer, productCount: self.viewModel.chatDetails.first?.products?.count ?? 0)
        
        suggestionChatView.lblProceedCheckout.addTapGesture {
            if self.viewModel.dataChatMainResponse?.isBundleChat == "2" {
                self.viewModel.proceedToCheckoutAPI(chatId: self.chatId, toId: self.sellerID, bundleId : self.viewModel.dataChatMainResponse?.bundleId ?? "",isFromBundle: "1" ) { status, address in
                    if status {
                        if let address = address?.first {
                            self.coordinator?.navigateToBundleCart(bundleId: self.viewModel.dataChatMainResponse?.bundleId ?? "", address: address, storeId: self.storeID)
                        }
                    }
                }
            } else {
                self.viewModel.proceedToCheckoutAPI1(chatId: self.chatId, toId: self.sellerID , productId: "\((self.viewModel.setProductRow(row: 0).productID) ?? 0)", isFromBundle: "0") { status in
                    if (status ?? false) {
                        self.coordinator?.navigateToCart()
                    }
                }
            }
        }
        return suggestionChatView
    }
    
    // --------------------------------------------
    
    func setSuggestionChatView() -> UIView {
        guard let suggestionChatView = UINib(nibName: "SuggestionChatView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? SuggestionChatView else {
            return UIView()
        }
        suggestionChatView.completion = { msg in
            self.viewModel.sendMessageAPI(messageData: SendMessage(chatId: self.chatId, toId: (self.viewModel.chatDetails.first?.userID ?? ""), messageType: self.messageType.rawValue, message: msg ?? "", url: self.mediaURL ?? nil, name: msg ?? "")) { status in
                if status {
                    self.afterSend()
                }
            }
        }
        return suggestionChatView
        
    }
    
    // --------------------------------------------
    
}
extension SuggestionChatView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSuggetion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as SuggetionCell
        cell.selectionStyle = .none
        cell.lblSuggetion.text = arrSuggetion[indexPath.row]
        cell.applyStyle()
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.didSelect {
            self.didSelect = true
            self.msg = arrSuggetion[indexPath.row]
            completion(self.msg)
            self.tbvSuggetionChat.reloadData()
        }
    }
}
