//
//  QantityViewController.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 23/06/25.
//

import UIKit

class QantityViewController: BaseVC {
    
    @IBOutlet weak var tableView : UITableView!
    var seletedIndex :  Int?
    var arr = ["Individual Item", "Set Of Items"]
    @IBOutlet weak var headerView: AppStatusView!
    var completion : ((Int?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.backButtonClicked = { [] in
            
            self.completion?(self.seletedIndex)
            
            self.coordinator?.popVC()
        }
        self.headerView.lblTitle.text = "Quantify"
        self.tableView.register(SingleSelectionCell.nib, forCellReuseIdentifier: SingleSelectionCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func doneAction(_ sender :  UIButton!){
        self.completion?(self.seletedIndex)
        
        self.coordinator?.popVC()
    }
    
}

extension QantityViewController :  UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as SingleSelectionCell
        let data = self.arr[indexPath.row]
        cell.lblTitle.text =  data
        cell.lblDescription.text = ""
        cell.lblDescription.isHidden = true
        cell.selectionStyle = .none
            let isSelected = seletedIndex == indexPath.row
            cell.ivCheck.image = isSelected ? .icCheckboxSqr : .iconUncheckBox
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seletedIndex = indexPath.row
        tableView.reloadData()
    }
    
}
