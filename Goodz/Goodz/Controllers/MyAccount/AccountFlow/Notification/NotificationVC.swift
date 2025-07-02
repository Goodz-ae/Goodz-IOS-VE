//
//  NotificationVC.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import Foundation
import UIKit

class NotificationVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var appTopView: AppStatusView!
   
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : NotificationVM = NotificationVM()
    var page : Int = 1
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self)
        apiCallingNotificationList()
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.tblNotification.delegate = self
        self.tblNotification.dataSource = self
        self.tblNotification.addRefreshControl(target: self, action: #selector(refreshData))
        self.setNoData(scrollView: tblNotification, noDataType: .noNotificationHere)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.notifications
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @objc func refreshData() {
        page = 1
        apiCallingNotificationList()
    }
    
    // --------------------------------------------
    
    func apiCallingNotificationList() {
        self.viewModel.fetchNotificationList(pageNo: self.page) { [self] _ in
            
            tblNotification.reloadData()
            tblNotification.endRefreshing()
        }
    }
    
    func pushNavigation(pushtype: String, orderID: String) {
        let type = NotifType(rawValue: pushtype) ?? .none
        if let topVC : UIViewController = UIApplication.topViewController() {
            
            let chatID = orderID
            let orderID = orderID
            
            if (type == .chatList) {
                topVC.tabBarController?.selectedIndex = 3
            } else if (type == .chatDetails) {
                self.coordinator?.navigateToChatDetail(isBlock: false, chatId: chatID, userId: UserDefaults.userID)
            } else if (type == .uploadDoc) {
                self.coordinator?.navigateToUploadDocument(isPro: appUserDefaults.getValue(.isProUser) ?? false)
            } else if (type == .myStoreDetails) {
                self.coordinator?.navigateToStore()
            } else if (type == .notificationList) {
                self.coordinator?.navigateToNotification()
            } else if (type == .orderDetails) {
                self.coordinator?.navigateToMyOrder(isMyOrder: true, orderID: orderID)
            } else if (type == .mySalesDetails) {
                self.coordinator?.navigateToMyOrder(isMyOrder: false, orderID: orderID)
            } else if ((type == .myStoreReview1) || (type == .myStoreReview2) || (type == .myStoreReview3)) {
                self.coordinator?.navigateToStoreReview()
            } else if (type == .trackOrder) {
                self.coordinator?.navigateToOrderTrack(orderID: orderID)
            } else if ((type == .myStore) || (type == .myStore2)) {
                self.coordinator?.navigateToStore()
            } else if (type == .otherNotification) {
                
            }
        }
    }
}

// --------------------------------------------
// MARK: - UITableview delegate and datasource
// --------------------------------------------

extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.setData(data: self.viewModel.setRowData(row: indexPath.row), lastRow: (self.viewModel.numberOfRows() - 1), currentRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = self.viewModel.arrNotification[indexPath.row]
        if let type = value.notificationType, let redirectionID = value.redirectionID {
                pushNavigation(pushtype: type, orderID: redirectionID)
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setFooterView()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // --------------------------------------------
    
    func setFooterView() -> UIView? {
        let vw = UIView()
        vw.backgroundColor = .clear
        vw.frame = CGRect(x: 0, y: 0, width: 300, height: 5)
        return vw
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            let total = self.viewModel.numberOfRows()
            if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
                self.page += 1
                apiCallingNotificationList()
            }
    }
}
