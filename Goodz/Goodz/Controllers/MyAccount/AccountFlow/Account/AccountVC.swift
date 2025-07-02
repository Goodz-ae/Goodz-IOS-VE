//
//  AccountVC.swift
//  Goodz
//
//  Created by Akruti on 01/12/23.
//

import UIKit

class AccountVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblAccount: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : AccountVM = AccountVM()
    var selectedIndex = Int()
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GlobalRepo.shared.getProfileAPI { status, _, _ in
            if status {
                self.tblAccount.reloadData()
            }
        }
        print("AccountVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.viewModel.setData()
        let nib = UINib(nibName: "MyAccountCell", bundle: nil)
        self.tblAccount.register(nib , forCellReuseIdentifier: "MyAccountCell")
        self.tblAccount.delegate = self
        self.tblAccount.dataSource = self
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.account
        self.appTopView.btnBack.isHidden = true
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
}

// --------------------------------------------
// MARK: - Tableview delegate and datasource
// --------------------------------------------

extension AccountVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfsection()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfCell(section: section)
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.viewModel.setRowData(section: indexPath.section, row: indexPath.row)
        let row = self.viewModel.numberOfCell(section: indexPath.section)
        
        if indexPath.section == 0 {
            let cellProfile = tableView.dequeueReusableCell(indexPath: indexPath) as UserCell
            cellProfile.imgUser.image = UIImage()
            if let currentUser = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser) {
                cellProfile.setMyaccountData(data: currentUser)
            }
            
            cellProfile.vwMain.isHidden = UserDefaults.isGuestUser
            cellProfile.btnLogin.isHidden = !UserDefaults.isGuestUser
            
            cellProfile.btnEdit.addTapGesture {
                self.coordinator?.navigateToEditProfile(isPro: appUserDefaults.getValue(.isProUser) ?? false)
            }
            
            cellProfile.btnLogin.addTapGesture {
                appDelegate.setLogin()
            }
            
            return cellProfile
        } else if  indexPath.section == 3 {
            let cellVersion = tableView.dequeueReusableCell(indexPath: indexPath) as AppVersionCell
            return cellVersion
        } else {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MyAccountCell
            cell.setMyaccountData(data: data, lastRow : row, currentRow: indexPath.row)
            return cell
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section != 3 &&  indexPath.section != 0 {
            let data = self.viewModel.setRowData(section: indexPath.section, row: indexPath.row)
            self.setTap(row: data)
            self.tblAccount.reloadData()
        }
        
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 20
        } else if section == 3 {
            return 45
        } else {
            return 0
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return setFooterView()
        } else {
            return UIView()
        }
    }
    
    // --------------------------------------------
    
    func setFooterView() -> UIView? {
        let vw = UIView()
        vw.backgroundColor = .clear
        vw.frame = CGRect(x: 16, y: 16, width: 300, height: 20)
        return vw
    }
    
    // --------------------------------------------
    
    func setTap(row: AccountMenuOptions) {
        switch (row) {
        case .myStore :
            self.coordinator?.navigateToStore()
        case .myWallet :
            self.coordinator?.navigateToWallet()
        case .myOrders :
            self.coordinator?.navigateToMyOrder(isMyOrder: true, orderID: nil)
        case .notifications :
            self.coordinator?.navigateToNotification()
        case .bundles :
            self.coordinator?.navigateToBundlingProducts()
        case .uploadYourDocuments :
            self.coordinator?.navigateToDocumentHelpCenter(isPro: appUserDefaults.getValue(.isProUser) ?? false) //navigateToUploadDocument(isPro: appUserDefaults.getValue(.isProUser) ?? false)
        case .myAds :
            self.coordinator?.navigateToMyAds()
        case .settings :
            self.coordinator?.navigateToSettings()
        case .helpCenter :
            self.coordinator?.navigateToHelpCenter()
        case .goodzPro :
            UserDefaults.isGuestUser ? appDelegate.setLogin() : coordinator?.navigateToProSplash()
        case .customization :
            self.coordinator?.navigateToCustomization()
        default:
            break
        }
    }
    
    // --------------------------------------------
    
}
