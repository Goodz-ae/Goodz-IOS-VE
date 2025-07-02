//
//  HelpCenterVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class HelpCenterVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblHelpCenter: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : HelpCenterVM = HelpCenterVM()
    
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
        self.viewModel.setData()
        self.tblHelpCenter.cornerRadius(cornerRadius: 4.0)
        let nib = UINib(nibName: "HelpCenterCell", bundle: nil)
        self.tblHelpCenter.register(nib , forCellReuseIdentifier: "HelpCenterCell")
        self.tblHelpCenter.delegate = self
        self.tblHelpCenter.dataSource = self
        self.tblHelpCenter.reloadData()
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.helpCenter
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
}

// --------------------------------------------
// MARK: - UITableView Delegate and DataSorce
// --------------------------------------------

extension HelpCenterVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.setNumberOfHelpCenter()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HelpCenterCell
        cell.setData(data: self.viewModel.setRowData(row: indexPath.row), lastRow: self.viewModel.setNumberOfHelpCenter() - 1, currentRow: indexPath.row)
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setTap(row: self.viewModel.setRowData(row: indexPath.row))
        self.tblHelpCenter.reloadData()
    }
    
    // --------------------------------------------
    
    func setTap(row: String) {
        switch (row) {
        case "About us" :
            self.coordinator?.navigateToWebView(id: 1)
        case "How It works" :
            self.coordinator?.navigateToWebView(id: 33)
        case "Our Commitments" :
            self.coordinator?.navigateToWebView(id: 39)
           // self.coordinator?.navigateToOurCommitments()
        case "FAQ" :
            self.coordinator?.navigateToFAQ()
        case "Legal" :
            self.coordinator?.navigateToLegal()
        case "Contact Us" :
            self.coordinator?.navigateToContactus()
        default:
            break
        }
    }
    
    // --------------------------------------------
    
}
