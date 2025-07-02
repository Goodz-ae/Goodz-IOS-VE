//
//  SearchVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 12/12/23.
//

import UIKit

class SearchVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var ivBack: UIImageView!
    @IBOutlet weak var tbvProductsType: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnProduct: ThemeBlackGrayButton!
    @IBOutlet weak var btnStore: ThemeBlackGrayButton!
    @IBOutlet weak var imgCross: UIImageView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel  : SearchVM = SearchVM()
    var page : Int = 1
    var pageStore : Int = 1
    var strSearch : String = ""
    
    // --------------------------------------------
    // MARK: - Initial Methds
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    override func viewDidAppear(_ animated: Bool) {
        self.txtSearch.becomeFirstResponder()
    }
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    private func applyStyle() {
        self.txtSearch.autocorrectionType = .no
        self.txtSearch.delegate = self
        self.btnProduct.isSelected = true
        self.btnStore.isSelected = false
        self.txtSearch.placeholder = Labels.searchProduct
        self.setTopButtons(isStoreSelected: false)
        self.tbvProductsType.delegate = self
        self.tbvProductsType.dataSource = self
        self.ivBack.addTapGesture {
            self.txtSearch.text = ""
            self.coordinator?.setTabbar(selectedIndex: 0)
        }
        self.imgCross.addTapGesture {
            self.imgCross.isHidden = true
            self.txtSearch.text = ""
            if self.btnStore.isSelected {
                self.pageStore = 1
                self.strSearch = self.txtSearch.text ?? ""
                self.storeApiCalling(search: self.strSearch)
            }
        }
    }
    
    // --------------------------------------------
    
    func setTopButtons(isStoreSelected: Bool) {
        self.txtSearch.resignFirstResponder()
        self.txtSearch.text = ""
        self.imgCross.isHidden = true
        DispatchQueue.main.async {
            self.btnStore.addBottomBorderWithColor(color: self.btnStore.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.btnProduct.addBottomBorderWithColor(color: self.btnProduct.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.tbvProductsType.reloadData()
            self.tbvProductsType.restore()
            if isStoreSelected {
                self.txtSearch.removeTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingDidEnd)
                self.txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            } else {
                self.txtSearch.removeTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                self.txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingDidEnd)
            }
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.registerTableView()
        self.applyStyle()
        
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        DispatchQueue.main.async {
            self.viewModel.fetchData(pageNo: self.page) { isDone in
                if !isDone {
                    self.setNoData(scrollView: self.tbvProductsType, noDataType: .productEmptyData)
                    self.tbvProductsType.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                    self.tbvProductsType.reloadData()
                    self.tbvProductsType.endRefreshing()
                } else {
                    self.tbvProductsType.reloadData()
                    self.tbvProductsType.endRefreshing()
                }
//                self.txtSearch.becomeFirstResponder()
            }
        }
    }
    
    // --------------------------------------------
    
    func storeApiCalling(search: String) {
        self.viewModel.fetchStoreList(pageNo: self.pageStore, search: search, isPopular: "0") { isDone in
            if !isDone {
                self.setNoData(scrollView: self.tbvProductsType, noDataType: .productEmptyData)
                self.tbvProductsType.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            }
            self.tbvProductsType.reloadData()
            self.tbvProductsType.endRefreshing()
//            self.txtSearch.becomeFirstResponder()
        }
    }
    
    // --------------------------------------------
    
    func registerTableView() {
        
        self.tbvProductsType.automaticallyAdjustsScrollIndicatorInsets = false
        self.tbvProductsType.registerReusableCell(MyAccountCell.self)
        self.tbvProductsType.registerReusableCell(RecentSearchCell.self)
        self.tbvProductsType.registerReusableCell(FollowerCell.self)
        self.tbvProductsType.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        if self.btnProduct.isSelected {
            self.page = 1
            self.apiCalling()
        } else {
            self.pageStore = 1
            self.storeApiCalling(search: self.strSearch)
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnProductTapped(_ sender: Any) {
        self.txtSearch.text = ""
        self.txtSearch.placeholder = Labels.searchProduct
        self.btnStore.isSelected = false
        self.btnProduct.isSelected = true
        self.setTopButtons(isStoreSelected: false)
        self.txtSearch.becomeFirstResponder()
    }
    
    // --------------------------------------------
    
    @IBAction func btnStoreTapped(_ sender: Any) {
        self.storeApiCalling(search: self.strSearch)
        self.txtSearch.placeholder = Labels.searchStores
        self.btnStore.isSelected = true
        self.btnProduct.isSelected = false
        self.setTopButtons(isStoreSelected: true)
        self.txtSearch.becomeFirstResponder()
    }
    
    // --------------------------------------------
    
    @IBAction func btnCartTapped(_ sender: Any) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            self.coordinator?.navigateToCart()
        }
    }
}

// --------------------------------------------
// MARK: - Extension search api
// --------------------------------------------

extension SearchVC : UITextFieldDelegate {
    @objc func textFieldNoChange(_ textField: UITextField) {
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.btnStore.isSelected {
            self.pageStore = 1
            self.strSearch = self.txtSearch.text ?? ""
            self.storeApiCalling(search: self.strSearch)
        } else {
            let search = self.txtSearch.text ?? ""
            var arr : [String] = UserDefaults.recentSearch
            if !search.trim().isEmpty {
                if !arr.contains(search) {
                    if arr.count == 5 {
                        arr.removeFirst()
                    }
                    arr.append(search)
                    UserDefaults.recentSearch = arr
                }
                self.coordinator?.navigateToSearchProductList(search: self.txtSearch.text ?? "") { status in
                    if status {
                        self.txtSearch.text = ""
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let search = self.txtSearch.text ?? ""
        if self.btnProduct.isSelected {
            if !search.isEmpty {
                textField.resignFirstResponder()
                return true
            }
        } else {
            if !search.isEmpty {
                self.pageStore = 1
                self.strSearch = self.txtSearch.text ?? ""
                self.storeApiCalling(search: self.strSearch)
                textField.resignFirstResponder()
                return true
            }
        }
        return false
    }
    
    // --------------------------------------------
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        self.imgCross.isHidden = newText.isEmpty
        return true
    }
    
    // --------------------------------------------
    
}
