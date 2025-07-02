//
//  OrderDetailsVCDataDelegate.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 02/06/25.
//
import UIKit



extension OrderDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return self.viewModel.arrChat?.count ?? 0
        } else {
            return viewModel.arrOrderItemList.count
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            
            
            let cellStep =  tableView.dequeueReusableCell(indexPath: indexPath) as SellStepView
            //let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ChatViewCell
            if let data = self.self.viewModel.arrChat?[ indexPath.row] {
                
                
                let chatID = data.productDetails?.chat_id ?? ""
                
                /*  cell.selectionStyle = .none
                 cell.setChatDetails(data: data)
                 cell.lblChange.addTapGesture {
                 self.coordinator?.navigateToMyAddress()
                 }*/
                if data.id == nil && data.productDetails != nil  {
                    cellStep.setChatDetails(data: data)
                    cellStep.firstFillBtn.addTapGesture {
                        if cellStep.firstFillBtn.tag == 101 { // Confirm abailablity
                            //self.chatId, acceptStatus: Status.two.rawValue, sellerId: self.sellerID
                            let confirAvailbelity = ConfirAvailbelity(chat_id: chatID, deliveryMethod: data.delivery_method ?? "", available: "1", user_id:  UserDefaults.userID)
                            self.viewModel.chat_update_pickup_availability(messageData: confirAvailbelity) { status in
                                print("confirm0>>",status)
                               // self.page = 1
                                self.apiCalling()
                                self.tableView.reloadData()
                            }
                        } else  if cellStep.firstFillBtn.tag == 201 { // Choose Pickup Dates
                            self.coordinator?.slotBookingViewController(_slotOptions: data.slotOptions, slot_message_id: nil, completion: { [weak self] val in
                                
                                guard let self = self ,var confirAvailbelity = val else {
                                    return
                                }
                                
                                confirAvailbelity.pickup_chat_id = chatID
                                confirAvailbelity.user_id = UserDefaults.userID
                                confirAvailbelity.token = UserDefaults.accessToken
                                
                                let jsonData = try? JSONEncoder().encode( confirAvailbelity.selected_slots  )
                                let jsonString = String(data: jsonData!, encoding: .utf8) ?? ""
                                /*
                                 let valParam = slotBookingModelStr(token: UserDefaults.accessToken, selected_slots: jsonString, pickup_chat_id: self.chatId, message_id: "", user_id: UserDefaults.userID)
                                 */
                                self.viewModel.chat_add_pickup_slots(param: confirAvailbelity ) { status in
                                    print("confirm0>>",status)
                                    //self.page = 1
                                    self.apiCalling()
                                    self.tableView.reloadData()
                                }
                                
                            })
                            
                        }else  if cellStep.firstFillBtn.tag == 301 { // Change Choose Pickup Dates
                            self.coordinator?.slotBookingViewController(_slotOptions: data.slotOptions , slot_message_id : data.slot_message_id  , completion: { [weak self] val in
                                guard let self = self ,var confirAvailbelity = val else {
                                    return
                                }
                                
                                confirAvailbelity.pickup_chat_id = chatID
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
                                    //self.page = 1
                                    self.apiCalling()
                                    self.tableView.reloadData()
                                }
                                
                            })
                        }else if cellStep.firstFillBtn.tag == 401 {
                            if cellStep.selectedPickupSlots == nil {
                                self.showSimpleAlert(Message: "Please select slots")
                                return
                            }
                            let confirPickSlotModel = ConfirPickSlotModel(chat_id: chatID, choosen_pickup_date: (cellStep.selectedPickupSlots?.date ?? ""), choosen_pickup_time: "\(cellStep.selectedPickupSlots?.id ?? 0)"  , user_id:  UserDefaults.userID)
                            self.viewModel.chat_confirm_pickup_slot(messageData: confirPickSlotModel) { status in
                                print("confirm0>>",status)
                               // self.page = 1
                              //  self.apiCalling()
                                //self.tbvChats.reloadData()
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
                                //self.page = 1
                                self.apiCalling()
                                self.tableView.reloadData()
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
                            let confirAvailbelity = ConfirAvailbelity( chat_id: chatID, deliveryMethod: data.delivery_method ?? "", available: "2", user_id:  UserDefaults.userID)
                            self.viewModel.chat_update_pickup_availability(messageData: confirAvailbelity) { status in
                                print("confirm0>>",status)
                               // self.page = 1
                              //  self.apiCalling()
                               // self.tbvChats.reloadData()
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
                                
                                let confirPickSlotModel = ConfirPickSlotModel(chat_id: chatID, choosen_pickup_date: (slots?.date ?? ""), choosen_pickup_time: "\(slots?.id ?? 0)"  , user_id:  UserDefaults.userID , messageId : "\(data.productDetails?.choosen_pickup_slot?.choosen_slot_id ?? 0 )" )
                                self.viewModel.chat_confirm_pickup_slot(messageData: confirPickSlotModel) { status in
                                    print("confirm0>>",status)
                                    //self.page = 1
                                    self.apiCalling()
                                    self.tableView.reloadData()
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
                    
                    
                }
                
            }
            return cellStep
            
            
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
            cell.configData(model: viewModel.arrOrderItemList[indexPath.row])
            return cell
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            
        } else {
            let data = viewModel.arrOrderItemList[indexPath.row]
            
            //        if self.isFromOrderList {
            //            self.coordinator?.navigateToProductDetail(productId: data.orderProductID ?? "", type: .orderDetails)
            //        } else {
            //            self.coordinator?.navigateToProductDetail(productId: data.sellProductID ?? "", type: .saleDetails)
            //        }
        }
    }
 
    
    
    /*

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.arrChat?.count ?? 0
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
    */
}
