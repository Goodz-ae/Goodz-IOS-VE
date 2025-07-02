//
//  OrderVC.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
import UIKit

class OrderVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var btnMyOrder: ThemeBlackGrayButton!
    @IBOutlet weak var btnMySales: ThemeBlackGrayButton!
    @IBOutlet weak var tblOrder: UITableView!
    @IBOutlet weak var btnSort: SmallGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : OrderVM = OrderVM()
    var arrSort : [SortModel] = []
    var selectSort : SortModel?
    var page : Int = 1
    
    var isMyOrder = false
    var orderID: String?
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
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.btnSort.isHidden = true
        self.btnMyOrder.isSelected = isMyOrder
        self.btnMySales.isSelected = !isMyOrder
        self.setTopButtons()
        self.tblOrder.cornerRadius(cornerRadius: 4.0)
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        self.tblOrder.register(nib, forCellReuseIdentifier: "OrderCell")
        self.tblOrder.delegate = self
        self.tblOrder.dataSource = self
        self.btnSort.cornerRadius(cornerRadius: self.btnSort.frame.height / 2)
        self.tblOrder.addRefreshControl(target: self, action: #selector(refreshData))
        self.arrSort = [
            SortModel(sortTitle: "Sort by: Newest First", sortId: "2"),
            SortModel(sortTitle: "Sort by: Oldest First", sortId: "1")
        ]
        self.selectSort = self.arrSort.first
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @objc func refreshData() {
        self.apiCalling()
        self.page = 1
        if self.btnMyOrder.isSelected {
            self.apiCallingOrderList()
        } else {
            self.apiCallingSellList()
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.myOrders
        self.btnMyOrder.title(title: Labels.myOrders)
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func apiCalling() {
       
//        GlobalRepo.shared.sortListAPI(btnMyOrder.isSelected ? .order : .sales, isShowLoader: true) { [self] status, data, error in
//            if status, let sortList = data {
//                self.arrSort = sortList
        self.btnSort.setTitle(self.selectSort?.sortTitle ?? "", for: .normal)
//            }
            
            self.btnMyOrder.isSelected ? self.apiCallingOrderList() : self.apiCallingSellList()
//        }
     }
    
    func apiCallingOrderList() {
        self.viewModel.fetchOrderList(pageNo: self.page,sortID: self.selectSort?.sortId ?? "") { [self] status in
            if status {
                if (self.viewModel.arrOrderList.count == 0) {
                    self.btnSort.isHidden = true
                    self.setNoData(scrollView: self.tblOrder, noDataType: .nothingHereOrder)
                    self.tblOrder.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                } else {
                    self.btnSort.isHidden = false
                }
                self.tblOrder.reloadData()
            } else  {
                self.btnSort.isHidden = true
                self.setNoData(scrollView: self.tblOrder, noDataType: .nothingHereOrder)
                self.tblOrder.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            }
            self.tblOrder.reloadData()
            self.tblOrder.endRefreshing()
            if isMyOrder {
                self.checkNotitficationNavigation()
            }
            
        }
    }
    
    func apiCallingSellList() {
        self.viewModel.fetchSellList(pageNo: self.page,sortID: selectSort?.sortId ?? "") { [self] status  in
            if status {
                if (self.viewModel.arrSellList.count == 0) {
                    self.btnSort.isHidden = true
                    self.setNoData(scrollView: self.tblOrder, noDataType: .nothingHereOrder)
                    self.tblOrder.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                } else {
                    self.btnSort.isHidden = false
                }
            } else {
                self.btnSort.isHidden = true
                self.setNoData(scrollView: self.tblOrder, noDataType: .nothingHereOrder)
                self.tblOrder.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            }
            
            self.tblOrder.reloadData()
            self.tblOrder.endRefreshing()
            if isMyOrder == false {
                self.checkNotitficationNavigation()
            }
        }
    }
    
    func checkNotitficationNavigation() {
        if let orderID = orderID {
            if self.btnMyOrder.isSelected {
                let dataOrder = self.viewModel.findMyOrderData(orderID: orderID)
                self.orderID = nil
                dataOrder?.status == "Waiting For Delivery" ? self.coordinator?.navigateToOrderDetailsInTransit() : self.coordinator?.navigateToOrderDetailsDelivered(orderListResultModel: dataOrder)
            } else {
                if  let dataSale = self.viewModel.findMySalesData(orderID: orderID) {
                    self.orderID = nil
                    dataSale.status == "Waiting For Delivery" ? self.coordinator?.navigateToSalesDetailsInTransit() : self.coordinator?.navigateToSalesDetailsDelivered(sellListResultModel: dataSale)
                }
            }
            
        }
    }
    
    // --------------------------------------------
    
    func setTopButtons() {
    
        DispatchQueue.main.async {
            self.btnSort.isHidden = true
            self.btnMyOrder.addBottomBorderWithColor(color: self.btnMyOrder.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.btnMySales.addBottomBorderWithColor(color: self.btnMySales.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.tblOrder.reloadData()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.setTopViewAction()
        self.getData()
    }
    
    func getData() {
        self.page = 1
        self.viewModel.totalRecords = 0
        self.applyStyle()
        self.apiCalling()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnSortTapped(_ sender: Any) {
        self.coordinator?.presentSort(data: self.arrSort) { [self] data in
            self.btnSort.setTitle(data.sortTitle, for: .normal)
            self.selectSort = data
            self.apiCalling()
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnMySalesTapped(_ sender: Any) {
        self.btnMyOrder.isSelected = false
        self.btnMySales.isSelected = true
        self.setTopButtons()
        self.page = 1
        self.viewModel.totalRecords = 0
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    @IBAction func btnMyOrderTapped(_ sender: Any) {
        self.btnMyOrder.isSelected = true
        self.btnMySales.isSelected = false
        self.setTopButtons()
        self.page = 1
        self.viewModel.totalRecords = 0
        self.apiCalling()
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITableView delegate and datasource
// --------------------------------------------

extension OrderVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.btnMyOrder.isSelected {
            return self.viewModel.numberOfMyOrder()
        } else {
            return self.viewModel.numberOfMySales()
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as OrderCell
        if self.btnMyOrder.isSelected {
            let dataOrder = self.viewModel.setMyOrderData(row: indexPath.row)
            cell.setOrderData(data: dataOrder, lastRow: self.viewModel.numberOfMyOrder(), currentRow: indexPath.row)
            cell.btnOrderDetails.addTapGesture {
                dataOrder.status == "Waiting For Delivery" ? self.coordinator?.navigateToOrderDetailsInTransit() : self.coordinator?.navigateToOrderDetailsDelivered(orderListResultModel: dataOrder)
            }
        } else {
            let dataSale = self.viewModel.setMySalesData(row: indexPath.row)
            cell.setSellData(data: dataSale, lastRow: self.viewModel.numberOfMySales(), currentRow: indexPath.row)
            cell.btnOrderDetails.addTapGesture {
                dataSale.status == "Waiting For Delivery" ? self.coordinator?.navigateToSalesDetailsInTransit() : self.coordinator?.navigateToSalesDetailsDelivered(sellListResultModel: dataSale)
            }
        }
        
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.btnMyOrder.isSelected {
            let dataOrder = self.viewModel.setMyOrderData(row: indexPath.row)
            dataOrder.status == "Waiting For Delivery" ? self.coordinator?.navigateToOrderDetailsInTransit() : self.coordinator?.navigateToOrderDetailsDelivered(orderListResultModel: dataOrder)
        } else {
            let dataSale = self.viewModel.setMySalesData(row: indexPath.row)
            dataSale.status == "Waiting For Delivery" ? self.coordinator?.navigateToSalesDetailsInTransit() : self.coordinator?.navigateToSalesDetailsDelivered(sellListResultModel: dataSale)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.btnMyOrder.isSelected {
            let total = self.viewModel.numberOfMyOrder()
            if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
                self.page += 1
                apiCallingOrderList()
            }
        }else {
            let total = self.viewModel.numberOfMySales()
            if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
                self.page += 1
                apiCallingSellList()
            }
        }
    }
}
