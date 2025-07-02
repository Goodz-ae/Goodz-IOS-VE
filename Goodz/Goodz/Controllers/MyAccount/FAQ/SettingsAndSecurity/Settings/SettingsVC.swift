//
//  SettingsVC.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import Foundation
import UIKit

class SettingsVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var btnDeleteAccount: ThemeGreenBorderButton!
    @IBOutlet weak var constHeightTable: NSLayoutConstraint!
    @IBOutlet weak var vwDeleteAccount: UIView!
    
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : SettingsVM = SettingsVM()
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblSettings.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblSettings.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.vwDeleteAccount.isHidden = true
        let nib = UINib(nibName: "MyAccountCell", bundle: nil)
        self.tblSettings.register(nib , forCellReuseIdentifier: "MyAccountCell")
        self.tblSettings.delegate = self
        self.tblSettings.dataSource = self
        self.tblSettings.reloadData()
        
        self.btnDeleteAccount.setTitle(Labels.deleteAccount, for: .normal)
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblSettings && keyPath == "contentSize" {
            self.constHeightTable.constant = self.tblSettings.contentSize.height
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.settings
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnDeleteAccountTapped(_ sender: Any) {
        showAlert(title: "", message: Labels.areYouSureYouWantToDeleteYourAccount) {
            self.viewModel.deleteAccount { isDone in
                if isDone {
                    UserDefaults.standard.clearUserDefaults()
                    UserSessionManager.shared.Delete()
                    appDelegate.setLogin()
                }
            }
        }
    }
    
}

// --------------------------------------------
// MARK: - UItableView Delegate and DataSource
// --------------------------------------------

extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.setNumberOfSettings()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MyAccountCell
        cell.setMyaccountData(data: self.viewModel.setRowData(row: indexPath.row), lastRow: self.viewModel.setNumberOfSettings(), currentRow: indexPath.row)
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.setRowData(row: indexPath.row)
        switch data {
      //  case .uploadYourDocuments :
        //    self.coordinator?.navigateToUploadDocument(isPro: appUserDefaults.getValue(.isProUser) ?? false)
        case .security :
            self.coordinator?.navigateToSecurity()
//        case .payment : break
                // self.coordinator?.navigateToPaymentOption()
        case .notifications :
            self.coordinator?.navigateToNotificationList()
        case .myAddress :
            self.coordinator?.navigateToMyAddress()
        case .logout :
            showAlert(title: "", message: Labels.areYouSureYouWantToLogout ) {
                let user = UserDefaults.userID
                self.viewModel.logoutAccount { isDone in
                    if isDone {
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                        UserDefaults.standard.clearUserDefaults()
                        if UserSessionManager.shared.isBiometricLoginEnabled() {
                            UserSessionManager.shared.logout()
                            self.coordinator?.navigateToAutoLoginVC()
                        } else {
                            self.coordinator?.navigateToLoginVC()
                            appDelegate.setLogin()
                        }
                    }
                }
            }
        case .deleteAccount :
            showAlert(title: "", message: Labels.areYouSureYouWantToDeleteYourAccount) {
                self.viewModel.deleteAccount { isDone in
                    if isDone {
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                        UserDefaults.standard.clearUserDefaults()
                        appDelegate.setLogin()
                    }
                }
            }
        }
        self.tblSettings.reloadData()
    }
    
    // --------------------------------------------
    
}
