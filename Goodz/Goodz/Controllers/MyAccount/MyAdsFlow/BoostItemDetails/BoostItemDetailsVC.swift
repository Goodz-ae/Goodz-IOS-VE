//
//  BoostItemDetailsVC.swift
//  Goodz
//
//  Created by Akruti on 13/12/23.
//

import Foundation
import UIKit
import Charts

class BoostItemDetailsVC : BaseVC, ChartViewDelegate {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    @IBOutlet weak var apptopView: AppStatusView!
    @IBOutlet weak var vwUser: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var vwExpand: UIStackView!
    @IBOutlet weak var vwActive: UIView!
    @IBOutlet weak var lblActive: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var vwChart: LineChartView!
    @IBOutlet weak var lblReach: UILabel!
    @IBOutlet weak var lblReachCount: UILabel!
    
    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
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
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var viewModel : BoostItemDetailsVM = BoostItemDetailsVM()
    var selectedIndex : Int = 0
    var productID : String = ""
    var storeID : String = appUserDefaults.getValue(.currentUser)?.storeID ?? ""
    var isBoosted : Bool = false
    var boostData: BoostedInfoModel?
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblBoostPlans.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblBoostPlans.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(animated)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.setStoreView()
    }
    
    // --------------------------------------------
    
    func setStoreView() {
        self.btnBoost.isSelected = false
        self.setBoostTapped()
        self.imgProduct.cornerRadius(cornerRadius: 4.0)
        self.imgProduct.border(borderWidth: 1, borderColor: .themeGreen)
        self.vwUser.cornerRadius(cornerRadius: 4.0)
        
        self.lblProductName.font(font: .regular, size: .size14)
        self.lblProductName.color(color: .themeBlack)
        self.lblStatus.font(font: .regular, size: .size12)
        self.lblStatus.color(color: .themeBlack)
        self.lblPrice.font(font: .medium, size: .size14)
        self.lblPrice.color(color: .themeBlack)
        
        self.vwActive.cornerRadius(cornerRadius: 4.0)
        self.lblActive.font(font: .semibold, size: .size14)
        self.lblActive.color(color: .themeBlack)
        self.lblDays.font(font: .regular, size: .size12)
        self.lblDays.color(color: .themeGray)
        
        self.lblReach.font(font: .regular, size: .size14)
        self.lblReach.color(color: .themeBlack)
        
        self.lblReachCount.font(font: .regular, size: .size14)
        self.lblReachCount.color(color: .themeBlack)
        
        self.vwChart.cornerRadius(cornerRadius: 4.0)
        self.lblFeature.font(font: .semibold, size: .size16)
        self.lblFeature.color(color: .themeBlack)
        self.lblDescription.font(font: .medium, size: .size14)
        self.lblDescription.color(color: .themeBlack)
        
        self.lblBoostPlan.font(font: .medium, size: .size14)
        self.lblBoostPlan.color(color: .themeBlack)
        
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
        
        self.btnBoost.border(borderWidth: 1.0, borderColor: .themeGreen)
        self.btnBoost.cornerRadius(cornerRadius: 4.0)
    }
    
    func setLineChart() {
        vwChart.delegate = self
        vwChart.dragEnabled = true
        vwChart.setScaleEnabled(true)
        
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
    
    func setLineChartDataCount(data: [GraphInfo]) {
        var entries: [ChartDataEntry] = []
        let graphInfos = data
        
        for i in 0..<graphInfos.count {
            if let reachCount = graphInfos[i].reachCount, let reachCountDouble = Double(reachCount) {
                let entry = ChartDataEntry(x: Double(i), y: reachCountDouble)
                entries.append(entry)
            }
        }
        
        // Configure x-axis
        let xAxis = vwChart.xAxis
        xAxis.valueFormatter = ChartXAxisFormatter(dates: graphInfos.map { $0.date?.dateFormateChange(currDateFormate: DateFormat.apiDateFormateymd, needStringDateFormate: DateFormat.appDateFormate_mmm_dd) ?? ""})
        xAxis.axisMinimum = 0.0
        xAxis.granularity = 1
        xAxis.axisMaximum = Double(graphInfos.count )
        
        // Configure y-axis
        let leftAxis = vwChart.leftAxis
        leftAxis.axisMinimum = 0
        let maxReachCount = graphInfos.compactMap{ $0.reachCount?.toDouble() }.max() ?? 0
        
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
    
    func setTable() {
        let nibBoost = UINib(nibName: "BoostPlanCell", bundle: nil)
        self.tblBoostPlans.register(nibBoost, forCellReuseIdentifier: "BoostPlanCell")
        self.tblBoostPlans.delegate = self
        self.tblBoostPlans.dataSource = self
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    func setBoostTapped() {
        if self.isBoosted {
            self.btnBoost.isSelected = true
        } else {
            self.btnBoost.isSelected = false
        }
        
        if self.btnBoost.isSelected {
            self.vwExpand.isHidden = false
            self.lblFeature.superview?.isHidden = true
            self.vwBostInfo.isHidden = true
        } else {
            self.vwExpand.isHidden = true
            self.lblFeature.superview?.isHidden = false
            self.vwBostInfo.isHidden = false
        }
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        if isBoosted {
            self.viewModel.boostedItemInfoAPI(productId: self.productID) { isDone,data in
                if isDone {
                    self.setBoostedAPIData(data: data)
                    self.tblBoostPlans.reloadData()
                }
            }
        } else {
            self.viewModel.boostItemInfo(productId: self.productID) { isDone,data  in
                if isDone {
                    self.setBoostItemAPIData(data: data)
                    self.tblBoostPlans.reloadData()
                }
            }
        }
    }
    
    // --------------------------------------------
    
    func setBoostedAPIData(data: BoostedInfoModel) {
        self.boostData = data
        self.lblProductName.text = data.productName
        self.lblStatus.text = Labels.active
        if let img = data.productImage , let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.lblPrice.text = kCurrency + (data.discountedPrice ?? "0")
        if let remainingDays = data.remainingBoostDays {
            self.lblDays.text = Labels.active + " - " + remainingDays  + Labels.daysRemaining
        }
        self.lblReachCount.text = data.totalReachCount
        self.setLineChartDataCount(data: data.graphInfo ?? [])
        self.btnBoost.setTitle(Labels.extendYourPlan, for: .normal)
        self.btnBoost.setImage(UIImage(), for: .normal)
    }
    
    // --------------------------------------------
    
    func setBoostItemAPIData(data: BoostInfoModal) {
        self.lblProductName.text = data.productName
        self.lblStatus.text = Labels.notActive
        if let img = data.productImage , let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.lblPrice.text = kCurrency + (data.discountedPrice ?? "0")
        if let remainingDays = data.remainingDaysOfBoost, !remainingDays.isEmpty {
            self.lblActive.text = Labels.active + remainingDays  + Labels.daysRemaining
        } else {
            self.lblActive.text = Labels.notActive
        }
        _ = data.isBoosted == "0"
        self.btnBoost.setTitle(Labels.boost, for: .normal)
        self.btnBoost.setImage(.iconLight, for: .normal)
        
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj2 = object as? UITableView,
           obj2 == self.tblBoostPlans && keyPath == "contentSize" {
            self.consHeightBoostTable.constant = self.tblBoostPlans.contentSize.height
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.apptopView.textTitle = self.btnBoost.isSelected ? Labels.boostedItem : Labels.boostItem
        self.apptopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    private func setData() {
        self.btnBoost.setTitle(Labels.boost, for: .normal)
        self.btnBoost.setTitle(Labels.extendYourPlan, for: .selected)
        self.btnBoost.setImage(.iconLight, for: .normal)
        self.btnBoost.setImage(UIImage(), for: .selected)
        self.lblFaster.text = Labels.sellfaster
        self.lblFasterDes.text = Labels.sellFasterDescItem
        self.lblTopSearch.text = Labels.appearInUsersTopSearchResults
        self.lblTopSearchDes.text = Labels.appearInUserDescItem
        self.lblPerformance.text = Labels.exploreYourStorePerformance
        self.lblPerformanceDes.text = Labels.storePerformanceDescItem
        self.lblActive.text = Labels.active
        self.lblFeature.text = Labels.featuredListing
        self.lblDescription.text = Labels.yourProductWillAppearOnTopOfPeoplesResearches
        self.lblBoostPlan.text = Labels.boostPlans
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
        self.setTable()
        setLineChart()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnProductDetailsClicked(_ sender: UIButton) {
        self.coordinator?.navigateToSellProductDetail(storeId: self.storeID, productId: boostData?.productID ?? "", type: .sell)
    }
    
    @IBAction func btnBoostTapped(_ sender: Any) {
        
        guard selectedIndex < viewModel.arrBoostPlan.count else { return }
        let data = viewModel.arrBoostPlan[selectedIndex]
        
        self.viewModel.boostItem(storeId: self.storeID, productId: self.productID, boostID: data.boostID ?? "", amount: data.price ?? "") { isDone,data  in
            if isDone {
                self.coordinator?.navigateToTelrPayment(type: .boostItem,data: data ?? [])
//                self.btnBoost.isSelected = true
//                self.setBoostTapped()
//                self.setTopViewAction()
//                self.coordinator?.navigateToOrderCompletePopup(storeId: "", productId: "", type: .boostItem)
            }
        }
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITableView delegate and datasource
// --------------------------------------------

extension BoostItemDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfBoostplan()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellBoost = tableView.dequeueReusableCell(indexPath: indexPath) as BoostPlanCell
        let data = self.viewModel.setBoostplanData(row: indexPath.row)
        //        cellBoost.btnSelect.addTapGesture {
        //            self.selectedIndex = indexPath.row
        //            self.tblBoostPlans.reloadData()
        //        }
        if self.selectedIndex == indexPath.row {
            cellBoost.btnSelect.isSelected = true
            cellBoost.vwClick.isHidden = false
        } else {
            cellBoost.btnSelect.isSelected = false
            cellBoost.vwClick.isHidden = true
        }
        
        cellBoost.btnSelect.isUserInteractionEnabled = false
        cellBoost.setBoostPlanData(data: data)
        return cellBoost
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tblBoostPlans.reloadData()
    }
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
class CustomAxisValueFormatter: AxisValueFormatter {
    private let dates: [Date]
    
    init(dates: [Date]) {
        self.dates = dates
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index >= 0 && index < dates.count {
            let date = dates[index]
            let formatter = DateFormatter()
            formatter.dateFormat = "d" // Get only day number
            return formatter.string(from: date)
        }
        return ""
    }
}
