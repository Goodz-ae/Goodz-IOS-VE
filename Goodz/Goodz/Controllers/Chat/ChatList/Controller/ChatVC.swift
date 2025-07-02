//
//  ChatVC.swift
//  Goodz
//
//  Created by Akruti on 01/12/23.
//

import Foundation
import UIKit

class ChatVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var tbvChatList: UITableView!
    @IBOutlet weak var headerView: AppStatusView!
    
    @IBOutlet weak var txtSearch: UITextField!
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : ChatListVM = ChatListVM()
    var page : Int = 1
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ChatVC")
        self.apiCalling()
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.headerView.textTitle = Labels.inbox
        self.headerView.btnBack.isHidden = true
        self.txtSearch.placeholder = Labels.searchWithUsername
        self.txtSearch.delegate = self
        self.txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.tableRegister()
    }
    
    // --------------------------------------------
    
    private func tableRegister() {
        self.tbvChatList.addRefreshControl(target: self, action: #selector(refreshData))
        self.tbvChatList.delegate = self
        self.tbvChatList.dataSource = self
        self.tbvChatList.register(ChatListCell.nib, forCellReuseIdentifier: ChatListCell.reuseIdentifier)
        
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchChatListData(search : self.txtSearch.text ?? "" ,pageNo: self.page) { isDone in
            if isDone {
                self.tbvChatList.reloadData()
                self.tbvChatList.endRefreshing()
            } else {
                self.setNoData(scrollView: self.tbvChatList, noDataType: .inBoxEmptyData)
                self.tbvChatList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                self.tbvChatList.reloadData()
            }
        }
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITextFeild delegate
// --------------------------------------------

extension ChatVC : UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.page = 1
        self.apiCalling()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let search = self.txtSearch.text ?? ""
            if !search.isEmpty {
                self.page = 1
                self.apiCalling()
                textField.resignFirstResponder()
                return true
            
        }
        return false
    }
    
}
extension ChatVC: TextFieldsClearable {
    func clearTextFields() {
        self.txtSearch.text = ""
        self.page = 1
        self.apiCalling()
        self.txtSearch.resignFirstResponder()
    }
}
