//
//  MyAdsVC.swift
//  Goodz
//
//  Created by Akruti on 12/12/23.
//

import Foundation
import UIKit
import Charts

class MyAdsVC : BaseVC, ChartViewDelegate {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var apptopView: AppStatusView!
    @IBOutlet weak var btnItems: ThemeBlackGrayButton!
    @IBOutlet weak var btnStore: ThemeBlackGrayButton!
    @IBOutlet weak var tblItems: UITableView!
//    @IBOutlet weak var constHeightItems: NSLayoutConstraint!
    
    @IBOutlet weak var vwStore: UIStackView!
    @IBOutlet weak var vwUser: UIView!
    @IBOutlet weak var imgUser: ThemeGreenBorderImage!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProUser: UIImageView!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lblFollowers: UILabel!
    
    @IBOutlet weak var vwExpand: UIStackView!
    @IBOutlet weak var vwActive: UIView!
    @IBOutlet weak var lblActive: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var vwChart: LineChartView!
    
    @IBOutlet weak var lblAppear: UILabel!
    
    @IBOutlet weak var vwPlans: UIView!
    @IBOutlet weak var lblBoostPlan: UILabel!
    @IBOutlet weak var tblBoostPlans: UITableView!
    @IBOutlet weak var consHeightBoostTable: NSLayoutConstraint!
    
    @IBOutlet weak var vwBostInfo: UIStackView!
    @IBOutlet weak var vwFaster: UIView!
    @IBOutlet weak var imgFaster: UIImageView!
    @IBOutlet weak var lblFaster: UILabel!
    @IBOutlet weak var lblFasterDes: UILabel!
    @IBOutlet weak var vwTopSearch: UIView!
    @IBOutlet weak var imgTopSearch: UIImageView!
    @IBOutlet weak var lblTopSearch: UILabel!
    @IBOutlet weak var lblTopSearchDes: UILabel!
    @IBOutlet weak var vwPerformance: UIView!
    @IBOutlet weak var imgPerformance: UIImageView!
    @IBOutlet weak var lblPerformance: UILabel!
    @IBOutlet weak var lblPerformanceDes: UILabel!
    
    @IBOutlet weak var btnBoost: ThemeGreenButton!
    @IBOutlet weak var lblReach: UILabel!
    @IBOutlet weak var lblReachCount: UILabel!
    
    @IBOutlet weak var svScrollView: UIScrollView!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : MyAdsVM = MyAdsVM()
    var selectedIndex : Int = 0
    var page : Int = 1
    let currentUser = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)
    var isStore  = false
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
        self.imgUser.image = .avatarStore
        self.tblBoostPlans.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
//        self.tblItems.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblBoostPlans.removeObserver(self, forKeyPath: "contentSize")
//        self.tblItems.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.vwChart.delegate = self
        self.vwChart.dragEnabled = true
        self.vwChart.setScaleEnabled(true)
        
        if self.isStore {
            self.btnStore.isSelected = true
            self.btnItems.isSelected = false
        } else {
            self.btnItems.isSelected = true
            self.btnStore.isSelected = false
        }
        self.setTopButtons()
        self.setItemsView()
        self.setStoreView()
        self.setLineChart()
    }
    
    // --------------------------------------------
    
    func setLineChart() {
        vwChart.delegate = self
        vwChart.dragEnabled = true
        vwChart.setScaleEnabled(false)
        
        let llXAxis = ChartLimitLine(limit: 5, label: "Index 10")
        llXAxis.lineWidth = 0
        llXAxis.labelPosition = .leftBottom
        llXAxis.lineDashLengths = [0, 0, 0]
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        vwChart.xAxis.gridLineDashLengths = [0, 0]
        
        let leftAxis = vwChart.leftAxis
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [50, 0]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        vwChart.rightAxis.enabled = false
        vwChart.xAxis.labelPosition = .bottom
        vwChart.xAxis.gridLineWidth = 0
        vwChart.legend.form = .none
    }
    
    // --------------------------------------------
    
    func setLineChartDataCount(data: [GraphInfo]) {
        var entries: [ChartDataEntry] = []
        let graphInfos = data
        
        for i in 0..<graphInfos.count {
            if let reachCount = graphInfos[i].reachCount, let reachCountDouble = Double(reachCount) {
                let entry = ChartDataEntry(x: Double(i), y: reachCountDouble)
                print(entry)
                entries.append(entry)
            }
        }
        
        // Configure x-axis
        let xAxis = vwChart.xAxis
        xAxis.valueFormatter = ChartXAxisFormatter(dates: graphInfos.map { $0.date?.dateFormateChange(currDateFormate: DateFormat.apiDateFormateymd, needStringDateFormate: DateFormat.appDateFormate_mmm_dd) ?? ""})
        xAxis.axisMinimum = 0.0
        xAxis.granularity = 1
        xAxis.axisMaximum = Double(graphInfos.count )
//        xAxis.yOffset = 8
        
        // Configure y-axis
        let leftAxis = vwChart.leftAxis
        leftAxis.axisMinimum = 0
        let maxReachCount = graphInfos.compactMap{ $0.reachCount?.toInt() }.max() ?? 0
        let axisMaximum = setGraphMaxValue(val: Int(Double(maxReachCount) * 1.25))
        leftAxis.forceLabelsEnabled = true
        leftAxis.axisMaximum = axisMaximum
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.labelXOffset = -4
        
        let set1 = LineChartDataSet(entries: entries, label: "")
        set1.drawIconsEnabled = false
        set1.mode = .cubicBezier
        set1.drawValuesEnabled = false
        set1.drawVerticalHighlightIndicatorEnabled = false
        self.setup(set1)
        
        let data = LineChartData(dataSet: set1)
        self.vwChart.data = data
        self.vwChart.setVisibleXRangeMaximum(5)
        self.vwChart.xAxis.setLabelCount(graphInfos.count, force: false)
    }
    
    // --------------------------------------------
    
    func setGraphMaxValue(val: Int) -> Double {
        let roundedAxisMaximum = val % 10
        let finalAxisMaximum = roundedAxisMaximum == 0 ? 10 : val + (10 - roundedAxisMaximum)
        return Double(finalAxisMaximum)
    }
        
    // --------------------------------------------
    
    func stringToDate(dateString: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
    
    // --------------------------------------------
    
    private func setup(_ dataSet: LineChartDataSet) {
        if dataSet.isDrawLineWithGradientEnabled {
            dataSet.lineDashLengths = nil
            dataSet.highlightLineDashLengths = nil
            dataSet.setColors(.black, .red, .white)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = [0, 40, 100]
            dataSet.lineWidth = 1
            dataSet.circleRadius = 0
            dataSet.drawCircleHoleEnabled = false
        } else {
            dataSet.lineDashLengths = [5, 0]
            dataSet.highlightLineDashLengths = [5, 0]
            dataSet.setColor(.themeGreen)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = nil
            dataSet.lineWidth = 1
            dataSet.circleRadius = 0
            dataSet.drawCircleHoleEnabled = false
        }
    }
    
    // --------------------------------------------
    
    func setStoreView() {
        let currentUser = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)
        self.btnBoost.isSelected = currentUser?.isStoreBoosted == "1"
        self.setBoostTapped()
        
        self.btnBoost.setTitle(Labels.boost, for: .normal)
        self.btnBoost.setTitle(Labels.extendYourPlan, for: .selected)
        self.btnBoost.setImage(.iconLight, for: .normal)
        self.btnBoost.setImage(UIImage(), for: .selected)
        self.btnBoost.setTitleColor(.themeWhite, for: .normal)
        
        self.vwUser.cornerRadius(cornerRadius: 4.0)
        self.lblUsername.font(font: .semibold, size: .size18)
        self.lblUsername.color(color: .themeBlack)
        
        self.btnRate.cornerRadius(cornerRadius: 2.0)
        self.btnRate.font(font: .medium, size: .size12)
        self.btnRate.color(color: .themeBlack)
        
        self.lblFollowers.font(font: .medium, size: .size12)
        self.lblFollowers.color(color: .themeBlack)
        
        self.vwActive.cornerRadius(cornerRadius: 4.0)
        self.lblActive.font(font: .semibold, size: .size14)
        self.lblActive.color(color: .themeBlack)
        self.lblDays.font(font: .regular, size: .size12)
        self.lblDays.color(color: .themeGray)
        
        self.vwChart.superview?.cornerRadius(cornerRadius: 4.0)
        self.lblAppear.font(font: .medium, size: .size14)
        self.lblAppear.color(color: .themeBlack)
        
        self.lblBoostPlan.font(font: .medium, size: .size14)
        self.lblBoostPlan.color(color: .themeBlack)
        
        let nibBoost = UINib(nibName: "BoostPlanCell", bundle: nil)
        self.tblBoostPlans.register(nibBoost, forCellReuseIdentifier: "BoostPlanCell")
        self.tblBoostPlans.delegate = self
        self.tblBoostPlans.dataSource = self
        
        self.tblBoostPlans.reloadData()
        
        self.vwFaster.cornerRadius(cornerRadius: 4.0)
        self.lblFaster.font(font: .semibold, size: .size14)
        self.lblFaster.color(color: .themeBlack)
        self.lblFasterDes.font(font: .regular, size: .size12)
        self.lblFasterDes.color(color: .themeGray)
        
        self.vwTopSearch.cornerRadius(cornerRadius: 4.0)
        self.lblTopSearch.font(font: .semibold, size: .size14)
        self.lblTopSearch.color(color: .themeBlack)
        self.lblTopSearchDes.font(font: .regular, size: .size12)
        self.lblTopSearchDes.color(color: .themeGray)
        
        self.vwPerformance.cornerRadius(cornerRadius: 4.0)
        self.lblPerformance.font(font: .semibold, size: .size14)
        self.lblPerformance.color(color: .themeBlack)
        self.lblPerformanceDes.font(font: .regular, size: .size12)
        self.lblPerformanceDes.color(color: .themeGray)
        
        self.lblReach.font(font: .regular, size: .size14)
        self.lblReach.color(color: .themeBlack)
        
        self.lblReachCount.font(font: .regular, size: .size14)
        self.lblReachCount.color(color: .themeBlack)
        
    }
    
    // --------------------------------------------
    
    func setItemsView() {
        self.tblItems.cornerRadius(cornerRadius: 4.0)
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        self.tblItems.register(nib, forCellReuseIdentifier: "OrderCell")
        self.tblItems.delegate = self
        self.tblItems.dataSource = self
        
        self.tblItems.addRefreshControl(target: self, action: #selector(refreshData))
        self.setData()
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchBoostItem(page: self.page) { isDone in
            if isDone {
                self.tblItems.reloadData()
                //self.tblItems.endRefreshing()
            } else {
                self.setNoData(scrollView: self.tblItems, noDataType: .myAdsEmptyData)
                self.tblItems.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            }
            self.tblItems.reloadData()
            self.tblItems.endRefreshing()
        }
    }
    
    func apiBoostStoreDetails() {
        self.viewModel.boostStoreInfoAPI(storeId: self.currentUser?.storeID ?? "") { isDone, response in
            if isDone {
                self.tblBoostPlans.reloadData()
                if let img = response.storeImage, let url = URL(string: img) {
                    self.imgUser.sd_setImage(with: url, placeholderImage: .avatarStore)
                    self.imgUser.contentMode = .scaleAspectFill
                } else {
                    self.imgUser.image = .avatarStore
                }
                self.lblUsername.text = response.storeName
                self.btnRate.setTitle((response.storeRate ?? "").isEmpty ? Status.five.rawValue : response.storeRate ?? "", for: .normal)
                self.lblFollowers.text = (response.followers ?? "0") + " " + Labels.followers
                self.svScrollView.isHidden = false
            }
        }
    }
    
    func apiBoostedStoreDetails() {
        
        self.viewModel.boostedStoreInfoAPI(storeId: self.currentUser?.storeID ?? "") { isDone, response in
            if isDone {
                self.tblBoostPlans.reloadData()
                if let img = response.storeImage, let url = URL(string: img) {
                    self.imgUser.sd_setImage(with: url, placeholderImage: .avatarStore)
                    self.imgUser.contentMode = .scaleAspectFill
                } else {
                    self.imgUser.image = .avatarStore
                }
                self.lblReachCount.text = response.totalReachCount
                self.setLineChartDataCount(data: response.graphInfo ?? [])
                //self.vwChart.isHidden = response.totalReachCount == "0" &&
                
                self.lblUsername.text = response.storeName
                self.btnRate.setTitle((response.storeRate ?? "").isEmpty ? Status.five.rawValue : response.storeRate ?? "", for: .normal)
                self.lblFollowers.text = (response.followers ?? "0") + " " + Labels.followers
                self.lblDays.text = (response.daysRemaining ?? "0") + "" + Labels.daysRemaining
                for (index, plan) in self.viewModel.arrBoostPlan.enumerated() {
                    if let boostID = plan.boostID, let boostIDInt = Int(boostID), boostIDInt == Int(response.planID ?? "0") {
                        self.selectedIndex = index
                        break // Exit the loop once a match is found
                    }
                }
                self.btnBoost.isSelected = true
                self.svScrollView.isHidden = false
                self.setBoostTapped()
            }
        }
    }
    
    // --------------------------------------------
    
    func setBoostTapped() {
        if self.btnBoost.isSelected {
            self.vwExpand.isHidden = false
            self.lblAppear.isHidden = true
            self.vwBostInfo.isHidden = true
        } else {
            self.vwExpand.isHidden = true
            self.lblAppear.isHidden = false
            self.vwBostInfo.isHidden = false
        }
    }
    
    // --------------------------------------------
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        
//        if let obj1 = object as? UITableView,
//           obj1 == self.tblItems && keyPath == "contentSize" {
//            if self.viewModel.arrMyAddItems.count == 0 {
//                self.constHeightItems.constant = screenHeight - 200
//            } else {
//                self.constHeightItems.constant = self.tblItems.contentSize.height
//            }
//            
//        }
//        if let obj2 = object as? UITableView,
//           obj2 == self.tblBoostPlans && keyPath == "contentSize" {
//            self.consHeightBoostTable.constant = self.tblBoostPlans.contentSize.height
//        }
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        if let tbl = object as? UITableView {
//            
//            if tbl == tblItems {
//                if self.viewModel.arrMyAddItems.count == 0 {
//                    self.constHeightItems.constant = screenHeight - 200
//                }
//            }
//        }
        
        if let tbl = object as? UITableView {
            
            if tbl == tblBoostPlans {
                self.consHeightBoostTable.constant = self.tblBoostPlans.contentSize.height
            }
        }
        
        UIView.animate(withDuration: 0.1) { }
    }
    // --------------------------------------------
    
    func setTopViewAction() {
        self.apptopView.textTitle = Labels.myAds
        self.apptopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func setTopButtons() {
        DispatchQueue.main.async {
            self.btnItems.addBottomBorderWithColor(color: self.btnItems.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.btnStore.addBottomBorderWithColor(color: self.btnStore.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.tblItems.reloadData()
        }
        if self.btnItems.isSelected {
            
            self.tblItems.isHidden = false
            self.svScrollView.isHidden = true
            self.apiCalling()
        } else {
            if self.currentUser?.isStoreBoosted == Status.one.rawValue {
                self.apiBoostedStoreDetails()
            } else {
                self.apiBoostStoreDetails()
            }
            self.tblItems.isHidden = true
        }
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblFaster.text = Labels.sellfaster
        self.lblFasterDes.text = Labels.byBoostingYourStoreYouWillDrive
        self.lblTopSearch.text = Labels.appearInUsersTopSearchResults
        self.lblTopSearchDes.text = Labels.yourStoreWillAppearInTheHomepageAndOnThe
        self.lblPerformance.text = Labels.exploreYourStorePerformance
        self.lblPerformanceDes.text = Labels.youWillBeAbleToVisualize
        self.lblActive.text = Labels.active
        self.lblAppear.text = Labels.yourStoreWillAppearInTheHomepage
        self.lblBoostPlan.text = Labels.boostPlans
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    @IBAction func btnStoreClicked(_ sender: UIButton) {
        self.coordinator?.navigateToStore()
    }
    
    @IBAction func btnBoostTapped(_ sender: Any) {
        
        let data = viewModel.boostStoreInfoModal
        
        let itemCount  = data?.storeItem?.toInt() ?? 0
        
        //            if itemCount >= 5 {
        if viewModel.totalRecoerd >= 5 {
            
            guard selectedIndex < viewModel.arrBoostPlan.count else { return }
            let data1 = viewModel.arrBoostPlan[selectedIndex]
            
            self.viewModel.boostItem(storeId: self.currentUser?.storeID ?? "", productId: "", boostID: data1.boostID ?? "", amount: data1.price ?? "") { [self] isDone, dataMain in
                if isDone {
                    //                        btnBoost.isSelected = true
                    //                        setBoostTapped()
                    //                        apiBoostedStoreDetails()
                    //                        self.coordinator?.navigateToOrderCompletePopup(storeId: "", productId: "", type: .boostStore)
                    self.coordinator?.navigateToTelrPayment(type: .boostStore,data: dataMain ?? [])
                }
            }
            
        } else {
            showOKAlert(title: Labels.goodz, message: Labels.minimumProductsRequiredBoostStoreAlert) {}
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnItemTapped(_ sender: Any) {
        self.btnStore.isSelected = false
        self.btnItems.isSelected = true
        self.setTopButtons()
    }
    
    // --------------------------------------------
    
    @IBAction func btnStoreTapped(_ sender: Any) {
        self.btnStore.isSelected = true
        self.btnItems.isSelected = false
   
        self.setTopButtons()
    }
}

// --------------------------------------------
// MARK: - UITableView delegate and datasource
// --------------------------------------------

extension MyAdsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == self.tblItems ? self.viewModel.numberOfMyAddItems() : self.viewModel.numberOfBoostplan()
        
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblItems {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as OrderCell
            let dataSale = self.viewModel.setMyAddItemsData(row: indexPath.row)
            cell.setAdsItems(data: dataSale, lastRow: self.viewModel.numberOfMyAddItems(), currentRow: indexPath.row)
            cell.btnBoost.isUserInteractionEnabled = false
            cell.btnBoost.setTitleColor(.themeWhite, for: .normal)
            return cell
        } else {
            let cellBoost = tableView.dequeueReusableCell(indexPath: indexPath) as BoostPlanCell
            let dataSale = self.viewModel.setBoostplanData(row: indexPath.row)
            //            cellBoost.btnSelect.addTapGesture {
            //                self.selectedIndex = indexPath.row
            //                self.tblBoostPlans.reloadData()
            //            }
            if self.selectedIndex == indexPath.row {
                cellBoost.btnSelect.isSelected = true
                cellBoost.vwClick.isHidden = false
            } else {
                cellBoost.btnSelect.isSelected = false
                cellBoost.vwClick.isHidden = true
            }
            cellBoost.btnSelect.isUserInteractionEnabled = false
            cellBoost.setBoostPlanData(data: dataSale)
            return cellBoost
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblItems {
            let id = self.viewModel.setMyAddItemsData(row: indexPath.row).productID ?? ""
            let isBoosted : Bool = self.viewModel.setMyAddItemsData(row: indexPath.row).isBoosted == Status.one.rawValue ? true : false
            self.coordinator?.navigateToBoostItemDetails(isBoosted: isBoosted, productID: id,myAdsModel: self.viewModel.setMyAddItemsData(row: indexPath.row))
        } else {
            self.selectedIndex = indexPath.row
            self.tblBoostPlans.reloadData()
        }
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfMyAddItems()
        if (total - 1) == indexPath.row && self.viewModel.totalRecoerd > total {
            self.page += 1
            self.apiCalling()
        }
    }
    
}
// Helper extension to convert string to Date
extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}


class ChartXAxisFormatter: NSObject, AxisValueFormatter {
    let dates: [String]
    
    init(dates: [String]) {
        self.dates = dates
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        guard index >= 0 && index < dates.count else { return "" }
       
        let number: Double = value
        let absoluteValue = abs(number)
        let isAbsolute = number == absoluteValue
        
        if isAbsolute {
            return dates[index]
        } else {
            return ""
        }
        
    }
}
