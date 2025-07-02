//
//  DashboardVC.swift
//  Goodz
//
//  Created by Akruti on 20/12/23.
//

import Foundation
import UIKit
import Charts

class DashboardVC : BaseVC, ChartViewDelegate {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var btnFigure: ThemeBlackGrayButton!
    @IBOutlet weak var btnInvoices: ThemeBlackGrayButton!
    @IBOutlet weak var tblInvoices: UITableView!
    @IBOutlet weak var consHeightTableInvoices: NSLayoutConstraint!
    @IBOutlet weak var vwFigure: UIStackView!
    @IBOutlet weak var btnSort: SmallGreenButton!
    
    // VIEW FIGURE
    @IBOutlet weak var vwTotalSales: UIView!
    @IBOutlet weak var txtSortSale: UITextField!
    @IBOutlet weak var lblTotalSales: UILabel!
    @IBOutlet weak var lblTotalSalesValue: UILabel!
    
    @IBOutlet weak var vwStoreView: UIView!
    @IBOutlet weak var txtSortStoreView: UITextField!
    @IBOutlet weak var lblStoreView: UILabel!
    @IBOutlet weak var lblStoreViewValue: UILabel!
    
    @IBOutlet weak var lblSalesCategory: UILabel!
    @IBOutlet weak var vwSalesCategory: UIView!
    @IBOutlet weak var txtSalesCategorySort: UITextField!
    @IBOutlet weak var colSalesCategory: UICollectionView!
    @IBOutlet weak var constHeightSlaesCategory: NSLayoutConstraint!
    
    @IBOutlet weak var vwStore: UIView!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var txtSortStore: UITextField!
    @IBOutlet weak var colStore: UICollectionView!
    @IBOutlet weak var consHeightStore: NSLayoutConstraint!
    // bar chart
    @IBOutlet weak var barchartView: BarChartView!
    @IBOutlet weak var vwBarChart: UIView!
    @IBOutlet weak var lblBarChart: UILabel!
    // line chart
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var vwLineChart: UIView!
    @IBOutlet weak var lblLineChart: UILabel!
    // pie chart
    @IBOutlet weak var vwPieChart: UIView!
    @IBOutlet weak var pieChartCategoryView: PieChartView!
    @IBOutlet weak var lblPieChartCategory: UILabel!
    @IBOutlet weak var pieChartCategoryVolumeView: PieChartView!
    @IBOutlet weak var lblPieChartCategoryVolume: UILabel!
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : DashboardVM = DashboardVM()
    var sortDataPicker: UIPickerView!
    let arrSortData =  [SortModel(sortTitle: Labels.weekly.capitalizeFirstLetter(), sortId: Status.three.rawValue),
                        SortModel(sortTitle: Labels.monthly.capitalizeFirstLetter(), sortId: Status.two.rawValue),
                        SortModel(sortTitle: Labels.yearly.capitalizeFirstLetter(), sortId: Status.one.rawValue)]
    
    let color1 = [UIColor.themeBottleGreen] + [UIColor.themeDarkGreen] + [UIColor.themeLightGreen]
    let color2 = [UIColor.themeGrayTwo] + [UIColor.themeLightOrange] + [UIColor.themeDarkBlue]
    
    let colors = [UIColor.themeBottleGreen, UIColor.themeDarkGreen ,UIColor.themeLightGreen , UIColor.themeGrayTwo, UIColor.themeLightOrange, UIColor.themeDarkBlue]
    
    var arrSort : [SortModel] = []
    var selectSort : SortModel?
    var page : Int = 1
    
    var objStoreViews: DashboardGraphModel?
    var objSalesInAed: DashboardGraphModel?
    
    var indexTotalSales = 0
    var indexFigureStore = 0
    var indexStoreViews = 0
    var indexCategorySort = 0
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblInvoices.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colStore.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colSalesCategory.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.colStore.removeObserver(self, forKeyPath: "contentSize")
        self.colSalesCategory.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    func setDataPieChartCount(graphData: [SalesGraphModel], vw: PieChartView) {
        var entries = [PieChartDataEntry]()
        for i in 0..<graphData.count {
            entries.append(PieChartDataEntry(value: Double(graphData[i].value ?? "0") ?? 0,
                                             label: graphData[i].title ?? ""))
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 0
        set.valueTextColor = .black
        set.colors = colors + color1 + color2
        
        let data = PieChartData(dataSet: set)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 2
        pFormatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(UIFont(name: "Poppins-Regular", size: 12.0)!)
        vw.data = data
    }
    
    func setPieChart(graphData: [SalesGraphModel], vw: PieChartView) {
        vw.isUserInteractionEnabled = false
        vw.usePercentValuesEnabled = false
        vw.drawSlicesUnderHoleEnabled = false
        vw.holeRadiusPercent = 0.6
        vw.transparentCircleRadiusPercent = 0.5
        vw.chartDescription.enabled = false
        vw.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        vw.drawCenterTextEnabled = false
        vw.drawHoleEnabled = true
        vw.rotationAngle = 0
        vw.rotationEnabled = true
        vw.highlightPerTapEnabled = true
        
        let l = vw.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.xEntrySpace = 15
        l.yEntrySpace = 15
        l.yOffset = 0
        
        self.setDataPieChartCount(graphData: graphData, vw: vw)
        vw.delegate = self
    }
    
    // --------------------------------------------
    
    func setBarChart() {
        self.barchartView.delegate = self
        let l = barchartView.legend
        l.enabled = false
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 15
        l.font = UIFont(name: "Poppins-Regular", size: 20.0)!
        l.xEntrySpace = 20.0
        l.yEntrySpace = 20.0
        l.formToTextSpace = 20.0
        l.xOffset = 10
        l.yOffset = 10
        
        self.barchartView.drawBarShadowEnabled = false
        self.barchartView.drawValueAboveBarEnabled = false
        self.barchartView.isUserInteractionEnabled = false
        self.barchartView.xAxis.enabled = true
        self.barchartView.rightAxis.enabled = false
        self.barchartView.xAxis.gridLineWidth = 0
        
        let xAxis = barchartView.xAxis
        xAxis.labelPosition = .bottom
        
        xAxis.labelTextColor = .black
        xAxis.drawGridLinesEnabled = false
        xAxis.avoidFirstLastClippingEnabled = false
        xAxis.valueFormatter = GraphValueFormatter(keys: objSalesInAed?.key ?? [])
//        xAxis.labelRotationAngle = -45
    //    xAxis.setLabelCount(objSalesInAed?.key?.count ?? 0, force: true)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = barchartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 3
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        leftAxis.gridLineWidth = 0
        
        // Show y-axis zero line
        leftAxis.drawZeroLineEnabled = true
            leftAxis.zeroLineColor = .gray
            leftAxis.zeroLineWidth = 1.0
        
        self.setBarDataCount()
    }

    
    // --------------------------------------------
    
    func setBarDataCount() {
        var arrayValue = [BarChartDataEntry]()

        guard let dates = self.objSalesInAed?.key, let values = self.objSalesInAed?.value else {
            return
        }

        for i in 0..<dates.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]) ?? 0)
            arrayValue.append(dataEntry)
            
        }
        let xAxis = barchartView.xAxis
        xAxis.valueFormatter = ChartXAxisFormatter(dates: dates.map { $0.dateFormateChange(currDateFormate: DateFormat.apiDateFormateymd, needStringDateFormate: DateFormat.appDateFormate_mmm_dd) })
        xAxis.yOffset = 8
        
        // Configure y-axis
        let leftAxis = barchartView.leftAxis
        leftAxis.axisMinimum = 0
        let intValues = values.compactMap { $0.toDouble() }
        print("Int values:", intValues)

        let maxReachCount = intValues.max() ?? 0
        let axisMaximum : Double = setGraphMaxValue(val: Int(Double(maxReachCount) * 1.25))
        leftAxis.forceLabelsEnabled = true
        leftAxis.axisMaximum = axisMaximum
        leftAxis.drawZeroLineEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.granularity = 0
        leftAxis.labelXOffset = -4
       
        let set1 = BarChartDataSet(entries: arrayValue, label: "")
        set1.colors = colors + color1 + color2
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9

        self.barchartView.data = data
        
    }
    
    // --------------------------------------------
    
    func setLineChart() {
        self.lineChartView.delegate = self
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        
        let llXAxis = ChartLimitLine(limit: 5, label: "Index 10")
        llXAxis.lineWidth = 0
        llXAxis.labelPosition = .leftBottom
        llXAxis.lineDashLengths = [0, 0, 0]
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        self.lineChartView.xAxis.gridLineDashLengths = [0, 0]
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.gridLineDashLengths = [50, 0]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.xAxis.gridLineWidth = 0
        self.lineChartView.legend.form = .none
        
        self.setLineChartDataCount()
    }
    
    // --------------------------------------------
    
    func setLineChartDataCount() {
       
        var arrayValue = [ChartDataEntry]()

        guard let dates = self.objStoreViews?.key, let values = self.objStoreViews?.value else {
            return
        }

        for i in 0..<dates.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]) ?? 0)
            arrayValue.append(dataEntry)
            
        }
        let xAxis = lineChartView.xAxis
        xAxis.valueFormatter = ChartXAxisFormatter(dates: dates.map { $0.dateFormateChange(currDateFormate: DateFormat.apiDateFormateymd, needStringDateFormate: DateFormat.appDateFormate_mmm_dd) })
        xAxis.axisMinimum = 0.0
        xAxis.granularity = 1
        xAxis.axisMaximum = Double(dates.count )
        
        // Configure y-axis
        let leftAxis = lineChartView.leftAxis
        leftAxis.axisMinimum = 0
        let maxReachCount = values.compactMap{ $0.toDouble() }.max() ?? 0
        let axisMaximum : Double = setGraphMaxValue(val: Int(Double(maxReachCount) * 1.25))
        print(maxReachCount, axisMaximum)
        leftAxis.forceLabelsEnabled = true
        leftAxis.axisMaximum = axisMaximum
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.granularity = 0
        leftAxis.labelXOffset = -4

        let set1 = LineChartDataSet(entries: arrayValue, label: "")
        set1.drawIconsEnabled = false
        self.setup(set1)

        let gradientColors = [ChartColorTemplates.colorFromString("ThemeBottleGreen").cgColor,
                              ChartColorTemplates.colorFromString("ThemeRed").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        set1.fillAlpha = 1
        set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        let data = LineChartData(dataSet: set1)
        self.lineChartView.data = data
        self.lineChartView.setVisibleXRangeMaximum(5)
        self.lineChartView.xAxis.setLabelCount(dates.count, force: false)
    }
    
    // --------------------------------------------
    
    func setGraphMaxValue(val: Int) -> Double {
        let roundedAxisMaximum = val % 10
        let finalAxisMaximum = roundedAxisMaximum == 0 ? 10 : val + (10 - roundedAxisMaximum)
        return Double(finalAxisMaximum)
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
            dataSet.setColor(.black)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = nil
            dataSet.lineWidth = 1
            dataSet.circleRadius = 0
            dataSet.drawCircleHoleEnabled = false
        }
    }

    // --------------------------------------------
    
    private func applyStyle() {
        self.sortDataPicker = UIPickerView()
        
        self.txtSortSale.tintColor = .clear
        self.txtSortStoreView.tintColor = .clear
        self.txtSalesCategorySort.tintColor = .clear
        self.txtSortStore.tintColor = .clear
        
        self.sortDataPicker.dataSource = self
        self.sortDataPicker.delegate = self
        
        self.txtSortSale.inputView = sortDataPicker
        self.txtSortSale.text = arrSortData[indexTotalSales].sortTitle
        self.txtSortStore.inputView = sortDataPicker
        self.txtSortStore.text = arrSortData[indexFigureStore].sortTitle
        self.txtSortStoreView.inputView = sortDataPicker
        self.txtSortStoreView.text = arrSortData[indexStoreViews].sortTitle
        self.txtSalesCategorySort.inputView = sortDataPicker
        self.txtSalesCategorySort.text = arrSortData[indexCategorySort].sortTitle
        
        self.txtSortSale.iq.addDone(target: self, action: #selector(selectDoneAction), showPlaceholder: true)
        self.txtSortStore.iq.addDone(target: self, action: #selector(selectDoneAction), showPlaceholder: true)
        self.txtSortStoreView.iq.addDone(target: self, action: #selector(selectDoneAction), showPlaceholder: true)
        self.txtSalesCategorySort.iq.addDone(target: self, action: #selector(selectDoneAction), showPlaceholder: true)
        
        self.btnFigure.isSelected = true
        self.setTopButtons()
        self.btnSort.cornerRadius(cornerRadius: self.btnSort.frame.height / 2)
        
        self.viewModel.setData()
        self.tblInvoices.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        self.setTablesCellections()
        self.setViews()
        self.btnSort.isHidden = true
    }
    
    @objc func selectDoneAction(){
        if self.txtSortSale.isFirstResponder {
            self.txtSortSale.text = self.arrSortData[indexTotalSales].sortTitle
            self.fetchTotalSales(isNext: false)
        } else if self.txtSalesCategorySort.isFirstResponder {
            self.txtSalesCategorySort.text = self.arrSortData[indexCategorySort].sortTitle
            self.fetchSalesByCategory(isNext: false)
        } else if self.txtSortStore.isFirstResponder {
            self.txtSortStore.text = self.arrSortData[indexFigureStore].sortTitle
            self.fetchMyfigureStore()
        } else if self.txtSortStoreView.isFirstResponder {
            self.txtSortStoreView.text = self.arrSortData[indexStoreViews].sortTitle
            self.fetchStoreViews(isNext: false)
        }
    }
    
    @objc func refreshData() {
        self.page = 1
        self.fetchMyInvoices(isShowLoader: false)
    }
    
    // --------------------------------------------
    
    func setViews() {
        self.lblTotalSales.font(font: .regular, size: .size16)
        self.lblTotalSales.color(color: .themeBlack)
        
        self.lblTotalSalesValue.font(font: .semibold, size: .size24)
        self.lblTotalSalesValue.color(color: .themeBlack)
        
        self.vwTotalSales.cornerRadius(cornerRadius: 4)
        self.vwTotalSales.border(borderWidth: 1, borderColor: .themeGreen)
        
        self.lblStoreView.font(font: .regular, size: .size16)
        self.lblStoreView.color(color: .themeBlack)
        
        self.lblStoreViewValue.font(font: .semibold, size: .size24)
        self.lblStoreViewValue.color(color: .themeBlack)
        
        self.vwStoreView.cornerRadius(cornerRadius: 4)
        self.vwStoreView.border(borderWidth: 1, borderColor: .themeGreen)
        
        self.lblSalesCategory.font(font: .semibold, size: .size16)
        self.lblSalesCategory.color(color: .themeBlack)
        self.vwSalesCategory.cornerRadius(cornerRadius: 4.0)
        
        self.lblStore.font(font: .semibold, size: .size16)
        self.lblStore.color(color: .themeBlack)
        self.vwStore.cornerRadius(cornerRadius: 4.0)
        
        self.txtSortStore.font(font: .medium, size: .size16)
        self.txtSortStore.color(color: .themeBlack)
        
        self.txtSortSale.font(font: .medium, size: .size16)
        self.txtSortSale.color(color: .themeBlack)
        
        self.txtSortStoreView.font(font: .medium, size: .size16)
        self.txtSortStoreView.color(color: .themeBlack)
        
        self.txtSalesCategorySort.font(font: .medium, size: .size16)
        self.txtSalesCategorySort.color(color: .themeBlack)
        
        self.vwBarChart.cornerRadius(cornerRadius: 4.0)
        self.lblBarChart.font(font: .medium, size: .size14)
        self.lblBarChart.color(color: .themeBlack)
        
        self.vwLineChart.cornerRadius(cornerRadius: 4.0)
        self.lblLineChart.font(font: .medium, size: .size14)
        self.lblLineChart.color(color: .themeBlack)
        
        self.vwPieChart.cornerRadius(cornerRadius: 4.0)
        self.lblPieChartCategory.font(font: .medium, size: .size14)
        self.lblPieChartCategory.color(color: .themeBlack)
        self.lblPieChartCategoryVolume.font(font: .medium, size: .size14)
        self.lblPieChartCategoryVolume.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setTablesCellections() {
        self.tblInvoices.cornerRadius(cornerRadius: 4.0)
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        self.tblInvoices.register(nib, forCellReuseIdentifier: "OrderCell")
        self.tblInvoices.delegate = self
        self.tblInvoices.dataSource = self
        self.tblInvoices.reloadData()
        
        let cellDashBoard = UINib(nibName: "DashBoardCell", bundle: nil)
        self.colStore.register(cellDashBoard, forCellWithReuseIdentifier: "DashBoardCell")
        self.colStore.delegate = self
        self.colStore.dataSource = self
        self.colStore.reloadData()
        
        self.colSalesCategory.register(cellDashBoard, forCellWithReuseIdentifier: "DashBoardCell")
        self.colSalesCategory.delegate = self
        self.colSalesCategory.dataSource = self
        self.colSalesCategory.reloadData()
        
        self.tblInvoices.addRefreshControl(target: self, action: #selector(refreshData))
        
    }
    
    // --------------------------------------------
    
    func setTopButtons() {
        DispatchQueue.main.async {
            self.btnFigure.addBottomBorderWithColor(color: self.btnFigure.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.btnInvoices.addBottomBorderWithColor(color: self.btnInvoices.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.tblInvoices.reloadData()
        }
        if self.btnFigure.isSelected {
            self.tblInvoices.isHidden = true
            self.vwFigure.isHidden = false
            self.btnSort.isHidden = true
            self.fetchTotalSales(isNext: true)
        } else {
            self.tblInvoices.isHidden = false
            self.vwFigure.isHidden = true
           // self.btnSort.isHidden = false
            self.page = 1
            self.viewModel.totalRecords = 0
            self.apiCalling()
        }
    }
    
    func apiCalling() {
        self.arrSort = [
            SortModel(sortTitle: "Sort by: Newest First", sortId: "2"),
            SortModel(sortTitle: "Sort by: Oldest First", sortId: "1")
        ]
//        GlobalRepo.shared.sortListAPI( .sales, isShowLoader: true) { [self] status, data, error in
//            if status, let sortList = data {
//                arrSort = sortList
        self.btnSort.setTitle(arrSort.first?.sortTitle ?? "", for: .normal)
        self.selectSort = arrSort.first
//            }
            
        self.fetchMyInvoices(isShowLoader: true)
//        }
     }
    
    func fetchMyInvoices(isShowLoader: Bool) {
        self.viewModel.fetchMyInvoices(sortId: self.selectSort?.sortId ?? "", pageNo: self.page, isShowLoader: isShowLoader) { isDone in
            if isDone {
                self.btnSort.isHidden = false
            } else {
                self.btnSort.isHidden = true
                self.setNoData(scrollView: self.tblInvoices, noDataType: .nothingHere)
            }
            if self.viewModel.arrInvoice.count == 0 {
                self.btnSort.isHidden = true
                self.setNoData(scrollView: self.tblInvoices, noDataType: .nothingHere)
            }
            self.tblInvoices.reloadData()
            self.tblInvoices.endRefreshing()
        }
    }
    
    func fetchTotalSales(isNext: Bool) {
        notifier.showLoader()
        if let index = arrSortData.firstIndex(where: {$0.sortTitle == txtSortSale.text}) {
            if let id = arrSortData[index].sortId {
                self.viewModel.fetchTotalSales(sortTotalSales: id) { isDone, data in
                    if let data = data {
                        self.setTotalSalesDetails(data: data)
                    }
                    if isNext {
                        self.fetchSalesByCategory(isNext: isNext)
                    }
                    notifier.hideLoader()
                }
            }
        }
    }
    
    func fetchSalesByCategory(isNext: Bool) {
        notifier.showLoader()
        if let index = arrSortData.firstIndex(where: {$0.sortTitle == txtSortStoreView.text}) {
            if let id = arrSortData[index].sortId {
                self.viewModel.fetchSalesByCategory(sortSalesByCategory: id) { isDone in
                    self.colSalesCategory.reloadData()
                    self.setPieChart(graphData: self.viewModel.salesByCategory?.salesByCategory ?? [], vw: self.pieChartCategoryView)
                    self.setPieChart(graphData: self.viewModel.salesByCategory?.salesByCategoryVolume ?? [], vw: self.pieChartCategoryVolumeView)
                    if isNext {
                        self.fetchStoreViews(isNext: true)
                    }
                    notifier.hideLoader()
                }
            }
        }
    }
    
    func fetchStoreViews(isNext: Bool) {
        notifier.showLoader()
        if let index = arrSortData.firstIndex(where: {$0.sortTitle == txtSortStoreView.text}) {
            if let id = arrSortData[index].sortId {
                self.viewModel.fetchStoreViews(sortStoreViews: id) { isDone, data in
                    if let data = data {
                        self.setStoreViewsDetails(data: data)
                    }
                    if isNext {
                        self.fetchMyfigureStore()
                    }
                    notifier.hideLoader()
                }
            }
        }
    }
    
    func fetchMyfigureStore() {
        notifier.showLoader()
        if let index = arrSortData.firstIndex(where: {$0.sortTitle == txtSortStore.text}) {
            if let id = arrSortData[index].sortId {
                self.viewModel.fetchMyFiguresStore(sortSalesByCategory: id) { isDone in
                    self.colStore.reloadData()
                    notifier.hideLoader()
                }
            }
        }
    }
    
    func setTotalSalesDetails(data: TotalSalesModel) {
        self.lblTotalSalesValue.text = kCurrency + ((data.totalSalesAmount ?? "0").isEmpty ? "0" : (data.totalSalesAmount ?? "0"))
        self.objSalesInAed = data.salesInAed
        self.setBarChart()
    }
    
    func setStoreViewsDetails(data: StoreViewsModel) {
        self.lblStoreViewValue.text = ((data.totalStoreView ?? "0").isEmpty ? "0" : (data.totalStoreView ?? "0"))
        self.objStoreViews = data.storeViews
        self.setLineChart()
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj1 = object as? UITableView,
           obj1 == self.tblInvoices && keyPath == "contentSize" {
            
            if self.tblInvoices.contentSize.height > 0 {
                self.consHeightTableInvoices.constant = contentScrollView.frame.height - 32
            } else {
                self.consHeightTableInvoices.constant = contentScrollView.frame.height - 32
            }
            
        }
        if let obj2 = object as? UICollectionView,
           obj2 == self.colStore && keyPath == "contentSize" {
            self.consHeightStore.constant = self.colStore.contentSize.height
        }
        if let obj3 = object as? UICollectionView,
           obj3 == self.colSalesCategory && keyPath == "contentSize" {
            self.constHeightSlaesCategory.constant = self.colSalesCategory.contentSize.height
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.dashboard
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func setData() {
        self.btnFigure.setTitle(Labels.myFigures, for: .normal)
        self.btnInvoices.setTitle(Labels.myInvoices, for: .normal)
        self.lblTotalSales.text = Labels.totalSales
        self.lblSalesCategory.text = Labels.salesByCategory
        self.lblStoreView.text = Labels.storeViews
        self.lblStore.text = Labels.store
        self.lblBarChart.text = Labels.salesInAED
        self.lblLineChart.text = Labels.storeViews
        self.lblPieChartCategory.text = Labels.salesByCategory
        self.lblPieChartCategoryVolume.text = Labels.salesPerCategoryInVolume
        
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    @objc private func downloadFile(_ sender: UIButton) {
        if let strURL = self.viewModel.setMyAddItemsData(row: sender.tag).invoiceUrl {
            downloadFile(url: strURL) { file in
                if file != nil {
                    // Create the Array which includes the files you want to share
                    var filesToShare = [Any]()
                    
                    // Add the path of the file to the Array
                    filesToShare.append(file)
                    
                    // Make the activityViewContoller which shows the share-view
                    let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                    
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        // 4. set its sourceRect here. It's the same as in step 2
                        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                        activityViewController.popoverPresentationController?.permittedArrowDirections = []
                    }
                    
                    // Show the share-view
                    self.present(activityViewController, animated: true, completion: nil)
                    notifier.showToast(message: Labels.invoiceDownloadedSuccessfully)
                    
                }
                
            }
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnFigureTapped(_ sender: Any) {
        self.btnFigure.isSelected = true
        self.btnInvoices.isSelected = false
        self.contentScrollView.scrollsToTop = true
        self.contentScrollView.isScrollEnabled = true
        self.setTopButtons()
    }
    
    // --------------------------------------------
    
    @IBAction func btnInvoicesTapped(_ sender: Any) {
        self.btnFigure.isSelected = false
        self.btnInvoices.isSelected = true
        self.contentScrollView.scrollsToTop = true
        self.contentScrollView.isScrollEnabled = false
        self.setTopButtons()
    }
    
    // --------------------------------------------
    
    @IBAction func btnSortTapped(_ sender: Any) {
        self.coordinator?.presentSort(data: self.arrSort) { [self] data in
            self.btnSort.setTitle(data.sortTitle, for: .normal)
            self.selectSort = data
            self.fetchMyInvoices(isShowLoader: true)
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnTotalSales(_ sender: Any) {
        self.sortDataPicker.selectRow(indexTotalSales, inComponent: 0, animated: false)
        self.txtSortSale.becomeFirstResponder()
    }
    
    // --------------------------------------------
    
    @IBAction func btnFigureStore(_ sender: Any) {
        self.sortDataPicker.selectRow(indexFigureStore, inComponent: 0, animated: false)
        self.txtSortStore.becomeFirstResponder()
    }
    
    // --------------------------------------------
    
    @IBAction func btnStoreViews(_ sender: Any) {
        self.sortDataPicker.selectRow(indexStoreViews, inComponent: 0, animated: false)
        self.txtSortStoreView.becomeFirstResponder()
    }
    
    // --------------------------------------------
    
    @IBAction func btnCategorySort(_ sender: Any) {
        self.sortDataPicker.selectRow(indexCategorySort, inComponent: 0, animated: false)
        self.txtSalesCategorySort.becomeFirstResponder()
    }
}

// --------------------------------------------
// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
// --------------------------------------------

extension DashboardVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrSortData.count
    }
    
    // --------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // --------------------------------------------
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrSortData[row].sortTitle
    }
    
    // --------------------------------------------
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.txtSortSale.isFirstResponder {
            self.indexTotalSales = row
        } else if self.txtSortStore.isFirstResponder {
            self.indexFigureStore = row
        } else if self.txtSortStoreView.isFirstResponder {
            self.indexStoreViews = row
        } else if self.txtSalesCategorySort.isFirstResponder {
            self.indexCategorySort = row
        } else {}
    }
    
    // --------------------------------------------
}

// --------------------------------------------
// MARK: - UITableView delegate and datasource
// --------------------------------------------

extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfMyAddItems()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.setInvoicesData(data: self.viewModel.setMyAddItemsData(row: indexPath.row), lastRow: self.viewModel.numberOfMyAddItems(), currentRow: indexPath.row)
        cell.btnOrderDetails.tag = indexPath.row
        cell.btnOrderDetails.addTarget(self, action: #selector(downloadFile(_ : )), for: .touchUpInside)
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            let total = self.viewModel.numberOfMyAddItems()
            if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
                self.page += 1
                fetchMyInvoices(isShowLoader: true)
            }
        
    }
}

// ------------------------------------------------
// MARK: - UICollectionView delegate and datasource
// ------------------------------------------------

extension DashboardVC : UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.colStore ? self.viewModel.numberOfStore() : self.viewModel.numberOfSalesCategory()
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCell", for: indexPath) as! DashBoardCell
        if collectionView == self.colStore {
            cell.setData(data: self.viewModel.setStoreData(row: indexPath.row))
        } else {
            let value = self.viewModel.setSalesCategoryData(row: indexPath.row)
            cell.setData(data: DashboardSortModel(title: value.title ?? "", amount: kCurrency + (value.value ?? "")))
        }
        return cell
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView == self.colStore ? ((self.colStore.frame.width - 10) / 2) : ((self.colSalesCategory.frame.width - 10) / 2)
        let height = screenHeight * 0.08
        return CGSize(width: width, height: height)
    }
    
    // --------------------------------------------
    
}
