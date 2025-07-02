//
//  OrderTrackVC.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import Foundation
import UIKit

class OrderTrackVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var scrollViewData: UIScrollView!
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwOrder: UIView!
    @IBOutlet weak var tblStatus: UITableView!
    @IBOutlet weak var consHeightOfStatusTable: NSLayoutConstraint!
    @IBOutlet weak var lblLiveChat: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblEstimate: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderIdValue: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : OrderTrackVM = OrderTrackVM()
    var orderID = ""
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.apiCalling()
        self.tblStatus.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblStatus.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.lblEstimate.font(font: .semibold, size: .size16)
        self.lblEstimate.color(color: .themeBlack)
        self.lbldate.font(font: .regular, size: .size14)
        self.lbldate.color(color: .themeGray)
        self.lblOrderId.font(font: .semibold, size: .size16)
        self.lblOrderId.color(color: .themeBlack)
        self.lblOrderIdValue.font(font: .regular, size: .size14)
        self.lblOrderIdValue.color(color: .themeDarkGray)
        
       
        let nib = UINib(nibName: "OrderTrackCell", bundle: nil)
        self.tblStatus.register(nib, forCellReuseIdentifier: "OrderTrackCell")
        self.tblStatus.delegate = self
        self.tblStatus.dataSource = self
        self.tblStatus.reloadData()
    }
    
    func apiCalling() {
        self.viewModel.trackOrderStatusAPI(orderID: self.orderID) { status in
            if status {
                self.scrollViewData.isHidden = false
                self.lblLiveChat.isHidden = false
                self.lbldate.text = self.viewModel.arrOderStatuts.first?.deliveryDate ?? ""
                self.lblOrderIdValue.text = self.viewModel.arrOderStatuts.first?.orderID ?? ""
                self.tblStatus.reloadData()
            }else{
                self.scrollViewData.isHidden = true
                self.lblLiveChat.isHidden = true
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text : String = Labels.youCanReachOurCustomerServiceOurLiveChat
        let termsRange = (text as NSString).range(of: Labels.liveChat)
        if gesture.didTapAttributedTextInLabel(label: lblLiveChat, inRange: termsRange) {
            print("Tapped live chat")
        } else {
            print("Tapped none")
        }
    }
    
    // --------------------------------------------
    
    func setData() {
        self.lblLiveChat.setAttributeText(fulltext: Labels.youCanReachOurCustomerServiceOurLiveChat, range1: Labels.youCanReachOurCustomerServiceOur, range2: Labels.liveChat, range3: "")
        self.lblLiveChat.isUserInteractionEnabled = true
        self.lblLiveChat.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        self.lblEstimate.text = Labels.estimationDelivery
        self.lblOrderId.text = Labels.oOrderId
        
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.trackMyOrder
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblStatus && keyPath == "contentSize" {
            self.consHeightOfStatusTable.constant = self.tblStatus.contentSize.height
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
// MARK: - UITableView Delegate And DataSource
// --------------------------------------------

extension OrderTrackVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.setNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTrackCell", for: indexPath) as! OrderTrackCell
        cell.setData(data: self.viewModel.setRowData(row: indexPath.row), lastRow: (self.viewModel.setNumberOfRows() - 1), currentRow: indexPath.row)
        return cell
    }
}
