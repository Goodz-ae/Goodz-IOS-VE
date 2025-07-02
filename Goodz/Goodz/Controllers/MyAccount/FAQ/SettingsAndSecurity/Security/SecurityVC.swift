//
//  SecurityVC.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import Foundation
import UIKit

class SecurityVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblSecurity: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : SecurityVM = SecurityVM()
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        let nib = UINib(nibName: "SecurityCell", bundle: nil)
        self.viewModel.setData()
        self.tblSecurity.register(nib , forCellReuseIdentifier: "SecurityCell")
        self.tblSecurity.delegate = self
        self.tblSecurity.dataSource = self
        self.tblSecurity.reloadData()
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.security
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
    // MARK: - Actions
    // --------------------------------------------
}

// --------------------------------------------
// MARK: - UItableView Delegate and DataSource
// --------------------------------------------

extension SecurityVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.setNumberOfSeurity()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecurityCell", for: indexPath) as! SecurityCell
        cell.setData(data: self.viewModel.setRowDataOfSeurity(row: indexPath.row))
        if indexPath.row == 0 {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.setRowDataOfSeurity(row: indexPath.row).title
        switch data {
        case Labels.email :
            self.coordinator?.navigateToSecurityEmail()
        case Labels.password :
            self.coordinator?.navigateToChangePassword()
        case Labels.twoStepsVerification :
            self.coordinator?.navigateToTwoStepVerification()
        case Labels.connections :
            self.coordinator?.navigateToConnections()
        default:
            break
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
}
