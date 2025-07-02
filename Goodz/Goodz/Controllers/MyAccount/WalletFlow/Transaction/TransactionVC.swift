//
//  TransactionVC.swift
//  Goodz
//
//  Created by Akruti on 11/12/23.
//

import Foundation
import UIKit

class TransactionVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblTransaction: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : TransactionVM = TransactionVM()
    
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
        let nib = UINib(nibName: "TrasactionCell", bundle: nil)
        self.tblTransaction.register(nib, forCellReuseIdentifier: "TrasactionCell")
        self.tblTransaction.dataSource = self
        self.tblTransaction.delegate = self
        self.tblTransaction.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    @objc func refreshData() {
        getTransactionList()
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.transactions
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func getTransactionList() {
        viewModel.fetchMyWalletDetails { isDone in
            self.tblTransaction.endRefreshing()
            self.tblTransaction.reloadData()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.getTransactionList()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITableView Delegate and DataSource
// --------------------------------------------

extension TransactionVC  : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.setNumberOfTrasaction()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionCell", for: indexPath) as! TrasactionCell
        let data = self.viewModel.setRowData(row: indexPath.row)
        cell.setData(data: data)
        return cell
    }
    
    // --------------------------------------------
    
}
