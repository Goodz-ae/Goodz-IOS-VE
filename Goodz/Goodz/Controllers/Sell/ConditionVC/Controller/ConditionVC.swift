//
//  ConditionVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

class ConditionVC: BaseVC {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var headerView: AppStatusView!
    @IBOutlet weak var tbvCategory: UITableView!
    @IBOutlet weak var btnDone: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : ConditionVM = ConditionVM()
    var selectedIndex : Int = -1
    var completion : (([ConditionModel]?) -> Void) = { _ in }
    var isMultipleSelection : Bool = false
    var arrSelectCondition : [ConditionModel] = []
    var selectedID : String = ""
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }

    // --------------------------------------------
    
    private func setUp() {
        self.headerView.lblTitle.text = Labels.conditions
        self.btnDone.setTitle(Labels.done, for: .normal)
        self.headerView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        self.registerTableView()
        
    }
    
    // --------------------------------------------
    
    private func registerTableView() {
        self.apiCalling()
        self.tbvCategory.delegate = self
        self.tbvCategory.dataSource = self
        self.tbvCategory.register(SingleSelectionCell.nib, forCellReuseIdentifier: SingleSelectionCell.reuseIdentifier)
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchConditionsData { isDone in
            if isDone {
                self.tbvCategory.reloadData()
            }
        }
    }
    
    // --------------------------------------------
    // MARK: - Action methods
    // --------------------------------------------
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        if self.isMultipleSelection {
            self.completion(self.arrSelectCondition)
        } else {
            if self.selectedIndex > -1 {
                self.completion([self.viewModel.setCondition(row: self.selectedIndex)])
            }
        }
        self.coordinator?.popVC()
    }
}
