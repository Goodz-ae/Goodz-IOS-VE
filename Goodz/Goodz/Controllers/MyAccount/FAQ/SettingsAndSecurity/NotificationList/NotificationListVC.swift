//
//  NotificationListVC.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
import UIKit

class NotificationListVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblNotification: UITableView!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : NotificationListVM = NotificationListVM()
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getNotificationStatusList()
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.tblNotification.cornerRadius(cornerRadius: 4.0)
        let nib = UINib(nibName: "NotificationListCell", bundle: nil)
        self.tblNotification.register(nib , forCellReuseIdentifier: "NotificationListCell")
        self.tblNotification.delegate = self
        self.tblNotification.dataSource = self
        self.tblNotification.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.getNotificationStatusList()
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.notificationSettings
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    func getNotificationStatusList() {
        self.viewModel.getNotificationStatusList { status in
            if self.viewModel.arrNotification.count == 0 || !status {
                self.setNoData(scrollView: self.tblNotification, noDataType: .noNotificationHere)
                self.tblNotification.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            } else if status {
                self.tblNotification.reloadData()
            } else {}
            self.tblNotification.reloadData()
            self.tblNotification.endRefreshing()
        }
    }
    
    // --------------------------------------------
    
    func updateNotificationStatusAPI(notificationId : String, status : String) {
        self.viewModel.updateNotificationStatusAPI(notificationId: notificationId, status: status) { isDone in
            if isDone {
                self.getNotificationStatusList()
            }
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
}

// --------------------------------------------
// MARK: - UITableView Delegate And DataSource
// --------------------------------------------

extension NotificationListVC : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfNotification()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as NotificationListCell
        cell.setDataNotificationList(data: self.viewModel.setRowNotification(row: indexPath.row), lastRow: (self.viewModel.numberOfNotification() - 1), currentRow: indexPath.row)
        
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.setRowNotification(row: indexPath.row)
        self.updateNotificationStatusAPI(notificationId: data.notificationID ?? "", status: data.status == Status.one.rawValue ? Status.zero.rawValue : Status.one.rawValue)
        self.tblNotification.reloadData()
    }
    
    // --------------------------------------------
    
}
