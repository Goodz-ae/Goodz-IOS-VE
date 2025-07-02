//
//  MyAddressVC.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
import UIKit

class MyAddressVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var btnAddNew: UIButton!
    @IBOutlet weak var btnSelect: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : MyAddressVM = MyAddressVM()
    var selectedIndex : Int = -1
    var isSelectType = false
    var page : Int = 1
    var completion : (_ address : MyAddressModel) -> Void = { _ in}
    var addressId : String = ""
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = self.viewModel.getAddressIndex(addressId: self.addressId)
        self.page = 1
        self.apiCalling()
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        let nib = UINib(nibName: "MyAddressCell", bundle: nil)
        self.tblAddress.register(nib, forCellReuseIdentifier: "MyAddressCell")
        self.tblAddress.delegate = self
        self.tblAddress.dataSource = self
        self.btnAddNew.font(font: .medium, size: .size16)
        self.btnAddNew.color(color: .themeBlack)
        self.tblAddress.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        self.btnSelect.setTitle(Labels.select, for: .normal)
        self.btnSelect.isHidden = true
        
        self.tblAddress.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchData(pageNo: self.page) { isDone in
            if isDone {
                if self.viewModel.numberOfAddress() == 0 {
                    self.setNodataView()
                } else {
                    self.btnSelect.isHidden = !self.isSelectType
                }
                self.tblAddress.reloadData()
                self.tblAddress.endRefreshing()
            } else {
                self.setNodataView()
            }
            self.tblAddress.reloadData()
        }
    }
    
    // --------------------------------------------
    
    func setNodataView() {
        self.setNoData(scrollView: self.tblAddress, noDataType: .productEmptyData)
        self.tblAddress.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = self.isSelectType ? Labels.selectAddress :  Labels.myAddress
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    func setString(str: String) -> String {
        return String(str.prefix(1)).uppercased() + String(str.dropFirst())
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnAddNewTapped(_ sender: Any) {
        self.coordinator?.navigateToAddAddress()
    }
    
    // --------------------------------------------
    
    @IBAction func btnSelectTapped(_ sender: Any) {
        if self.selectedIndex >= 0 {
            completion(self.viewModel.setAddressData(row: self.selectedIndex))
            self.viewModel.setDefaultAddress(addressId: self.viewModel.setAddressData(row: self.selectedIndex).addressId ?? "") { isDone in
                if isDone {
                    self.coordinator?.popVC()
                }
            }
        } else {
            notifier.showToast(message: "Please select address")
        }
        
    }
}

// --------------------------------------------
// MARK: - UITableView datasource and delegate
// --------------------------------------------

extension MyAddressVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfAddress()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MyAddressCell
        let data = self.viewModel.setAddressData(row: indexPath.row)
        cell.btnEdit.addTapGesture {
            self.coordinator?.navigateToEditAddress(data: data,id: data.addressId ?? "")
        }
        
        cell.btnDelete.addTapGesture {
            self.showAlert(title: "", message: Labels.areYouSureYouWantToDeleteAddress) {
                self.viewModel.deleteAddress(addressId: data.addressId ?? "") { status in
                    if status {
                        self.page = 1
                        self.apiCalling()
                    }
                }
            }
        }
        cell.btnSelect.isUserInteractionEnabled = false
//        cell.vwSelect.addTapGesture {
//            
//            self.selectedIndex = indexPath.row
//            
//        }
        
        cell.btnSelect.isSelected = selectedIndex == indexPath.row
        cell.setData(data: data, isSelectType: self.isSelectType)
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfAddress()
        if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
            self.page += 1
            self.apiCalling()
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSelectType {
            self.selectedIndex = indexPath.row
            self.tblAddress.reloadData()
        } else {
            self.selectedIndex = indexPath.row
            
            DispatchQueue.main.async {
                self.viewModel.setDefaultAddress(addressId: self.viewModel.setAddressData(row: self.selectedIndex).addressId ?? "") { isDone in
                    if isDone {
                        self.page = 1
                        self.apiCalling()
                        self.tblAddress.reloadData()
                    }                    
                }
            }
        }
    }
}

