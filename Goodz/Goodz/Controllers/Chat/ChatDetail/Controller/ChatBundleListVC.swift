//
//  ChatBundleListVC.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 06/06/24.
//

import UIKit

class ChatBundleListVC: BaseVC {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var tbvChatList: UITableView!
    @IBOutlet weak var headerView: AppStatusView!
    
    var isSeller = false
    var productList = [ChatProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        // Do any additional setup after loading the view.
    }
    
    private func applyStyle() {
        self.headerView.textTitle = Labels.bundleProducts
        self.headerView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    private func setUp() {
        self.applyStyle()
        self.tableRegister()
    }
    
    private func tableRegister() {
        self.tbvChatList.delegate = self
        self.tbvChatList.dataSource = self
        self.tbvChatList.register(OrderDetailCell.nib, forCellReuseIdentifier: OrderDetailCell.reuseIdentifier)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChatBundleListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = productList[indexPath.row]
        
        if self.isSeller == false {
            self.coordinator?.navigateToProductDetail(productId: String(format: "%d", data.productID ?? 0), type: .goodsDefault)
        } else {
            self.coordinator?.navigateToSellProductDetail(storeId: "", productId: String(format: "%d", data.productID ?? 0), type: .sell)
        }
    }
    
}
extension ChatBundleListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
        cell.configChartBundle(model: productList[indexPath.row])
        return cell
        
       
    }
}
