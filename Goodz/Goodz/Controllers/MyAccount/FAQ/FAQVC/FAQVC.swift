//
//  FAQVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class FAQVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // ---------------------a-----------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblHelpCenter: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : FAQVM = FAQVM()
    var isFAQ : Bool = true
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
        self.viewModel.setData { isDone in
            if isDone {
                self.tblHelpCenter.reloadData()
            }
        }
        self.tblHelpCenter.cornerRadius(cornerRadius: 4.0)
        let nib = UINib(nibName: "HelpCenterCell", bundle: nil)
        self.tblHelpCenter.register(nib , forCellReuseIdentifier: "HelpCenterCell")
        self.tblHelpCenter.delegate = self
        self.tblHelpCenter.dataSource = self
       
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = isFAQ ? Labels.fAQ : Labels.legal
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

extension FAQVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFAQ ? self.viewModel.setNumberOfHelpCenter() : self.viewModel.setNumberOfCMS()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HelpCenterCell
        let data = self.isFAQ ? self.viewModel.setRowData(row: indexPath.row).faqTitle ?? "" : self.viewModel.setRowDataOfCMS(row: indexPath.row)
        let lastRow = self.isFAQ ? self.viewModel.setNumberOfHelpCenter() - 1 : self.viewModel.setNumberOfCMS() - 1
        cell.setData(data: data, lastRow: lastRow, currentRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isFAQ {
            let subFAQdata = self.viewModel.openFaqPage(id: indexPath.row)
            self.coordinator?.navigateToFAQDetails(title: self.viewModel.setRowData(row: indexPath.row).faqTitle ?? "", data: subFAQdata)
        } else {
            let id = self.viewModel.openCMS(title: self.viewModel.setRowDataOfCMS(row: indexPath.row))
            self.coordinator?.navigateToWebView(id: id)
        }
        self.tblHelpCenter.reloadData()
    }
    
}
