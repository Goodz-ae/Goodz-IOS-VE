//
//  ConnectionsVC.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
import UIKit

class ConnectionsVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var lblReviewLogin: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tblConnections: UITableView!
    @IBOutlet weak var consHeightTable: NSLayoutConstraint!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : ConnectionsVM = ConnectionsVM()
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.getData()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblConnections.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblConnections.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblReviewLogin.font(font: .medium, size: .size16)
        self.lblReviewLogin.color(color: .themeBlack)
        
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblDescription.color(color: .themeBlack)
        
        self.viewModel.setData()
        let nib = UINib(nibName: "ConnectionCell", bundle: nil)
        self.tblConnections.register(nib , forCellReuseIdentifier: "ConnectionCell")
        self.tblConnections.delegate = self
        self.tblConnections.dataSource = self
        self.tblConnections.reloadData()
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblDescription.text = Labels.eachSessionShowsADeviceLogged
        self.lblReviewLogin.text = Labels.reviewLoginActivity
    } 
    
    // --------------------------------------------
    
    private func getData() {
        viewModel.getConnectionList { isDone, msg in
            self.tblConnections.reloadData()
        }
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblConnections && keyPath == "contentSize" {
            self.consHeightTable.constant = self.tblConnections.contentSize.height
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.connections
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITableView Delegate And DataSource
// --------------------------------------------

extension ConnectionsVC : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.setNumberOfConnection()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionCell", for: indexPath) as! ConnectionCell
        cell.setData(data: self.viewModel.setRowDataOfConnection(row: indexPath.row))
        return cell
    }
    
    // --------------------------------------------
    
}
