//
//  PaymentOptionVC.swift
//  Goodz
//
//  Created by Akruti on 12/12/23.
//

import Foundation
import UIKit

class PaymentOptionVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var btnAdd: ThemeGreenButton!
    @IBOutlet weak var tblPayment: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : PaymentOptionVM = PaymentOptionVM()
    var selectedIndex : Int = Int()
    
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
        self.tblPayment.cornerRadius(cornerRadius: 4.0)
        self.viewModel.setData()
        
        let nib = UINib(nibName: "PaymentOptionCell", bundle: nil)
        self.tblPayment.register(nib, forCellReuseIdentifier: "PaymentOptionCell")
        self.tblPayment.dataSource = self
        self.tblPayment.delegate = self
        self.tblPayment.reloadData()
        
        self.btnAdd.setTitle(Labels.addPaymentOption, for: .normal)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.paymentOption
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
    
    @IBAction func btnAddTapped(_ sender: Any) {
        let cell = self.tblPayment.dequeueReusableCell(withIdentifier: "PaymentOptionCell") as! PaymentOptionCell
//        self.setValidation(row: self.selectedIndex) { isDone in
//            if isDone {
                self.coordinator?.popVC()
//            }
//        }
    }
    
}

// --------------------------------------------
// MARK: - UITableView Delegate and DataSource
// --------------------------------------------

extension PaymentOptionVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.setNumberOfPayment()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionCell", for: indexPath) as! PaymentOptionCell
        let data = self.viewModel.setRowData(row: indexPath.row)
        cell.btnSelect.setTitle(data.title, for: .normal)
        cell.imgPayment.image = data.imgCards
        cell.btnSelect.addTapGesture {
            self.selectedIndex = indexPath.row
            self.tblPayment.reloadData()
        }
        if selectedIndex == indexPath.row {
            cell.btnSelect.isSelected = true
            cell.vwAccountDetails.isHidden = false
        } else {
            cell.btnSelect.isSelected = false
            cell.vwAccountDetails.isHidden = true
        }
        return cell
    }
    
    // --------------------------------------------
    
}
