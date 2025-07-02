//
//  FAQDetailsVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class FAQDetailsVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblHelpCenter: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var arrData : [SubFAQModel] = [SubFAQModel]()
    var strTitle : String = ""
    
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
        self.tblHelpCenter.cornerRadius(cornerRadius: 4.0)
        let nib = UINib(nibName: "HelpCenterCell", bundle: nil)
        self.tblHelpCenter.register(nib , forCellReuseIdentifier: "HelpCenterCell")
        self.tblHelpCenter.delegate = self
        self.tblHelpCenter.dataSource = self
        self.tblHelpCenter.reloadData()
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = self.strTitle
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

extension FAQDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HelpCenterCell
        cell.setData(data: self.arrData[indexPath.row].title ?? "", lastRow: (self.arrData.count - 1), currentRow: indexPath.row)
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.arrData[indexPath.row]
        self.coordinator?.navigateToCMS(title: data.title ?? "", description: data.descriptions ?? "")
        self.tblHelpCenter.reloadData()
    }
    
    // --------------------------------------------
    
}
