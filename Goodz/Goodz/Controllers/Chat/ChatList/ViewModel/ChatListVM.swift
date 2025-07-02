//
//  ChatListVM.swift
//  Goodz
//
//  Created by Akruti on 05/02/24.
//

import Foundation
class ChatListVM {
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ChatListRepo()
    var totalRecords = Int()
    var arrChatList = [ChatListModel]()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchChatListData(search : String, pageNo : Int, completion: @escaping((Bool) -> Void)) {
        self.repo.getChatListAPI(search: search, pageNo) { status, data, error, totalRecords  in
            if status, let mainCat = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrChatList = mainCat
                } else {
                    self.arrChatList.append(contentsOf: mainCat)
                }
                completion(true)
                return
            } else {
                if pageNo == 1 {
                    self.arrChatList = []
                }
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfChts() -> Int {
        self.arrChatList.count
    }
    
    // --------------------------------------------
    
    func setChat(row: Int) -> ChatListModel {
        self.arrChatList[row]
    }
    
    // --------------------------------------------
    
}
