//
//  PopularStoreVC.swift
//  Goodz
//
//  Created by vtadmin on 18/12/23.
//

import UIKit

class PopularStoreVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblview: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    private var viewModel : PopularStoreVM = PopularStoreVM()
    var page : Int = 1
    
    // --------------------------------------------
    // MARK: - Life cycle methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    private func setTopViewAction() {
        self.appTopView.textTitle = Labels.popularStores
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchData(pageNo: page, search: "", isPopular: Status.one.rawValue) { isDone in
            if isDone {
                self.tblview.reloadData()
                self.tblview.endRefreshing()
            }
        }
    }
    
    // --------------------------------------------
    
    func setUp() {
        self.apiCalling()
        self.tblview.register(UINib(nibName: "StoreCell", bundle: nil), forCellReuseIdentifier: "StoreCell")
        self.tblview.delegate = self
        self.tblview.dataSource = self
        self.tblview.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
}

// ---------------------------------------------------
// MARK: - UItableView Delegate and Datasource methods
// ---------------------------------------------------

extension PopularStoreVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        let data = self.viewModel.setSubCategories(row: indexPath.row)
        cell.setData(data: data)
        cell.selectionStyle = .none
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.coordinator?.navigateToPopularStore(storeId: self.viewModel.setSubCategories(row: indexPath.row).storeID ?? "")
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfRows()
        
        if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
            self.page += 1
            self.apiCalling()
        }
    }
    
    // --------------------------------------------
    
}

