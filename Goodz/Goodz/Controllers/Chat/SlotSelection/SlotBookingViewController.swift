//
//  SlotBookingViewController.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 20/05/25.
//

import UIKit

class SlotBookingViewController: BaseVC {
    
    @IBOutlet weak var titleLab :  UILabel!
    @IBOutlet weak var collectinView :  UICollectionView!
    @IBOutlet weak var timeCollView :  UICollectionView!
    
    @IBOutlet weak var saveButton :  UIButton!
    @IBOutlet weak var moreButton :  UIButton!
    @IBOutlet weak var collectionViewHeight :  NSLayoutConstraint!
    //var arrDate = [WeekdayDate]()
    var seletedIndex : Int = 0
     var slots              : [OptionsSlotBooking]?
    var seletedSlots        : SlotsDateModel?
    var seletedSlotsList    = [SlotsDateModel]()
    var slotOptions         = [SlotsDateModel]()
    var slot_message_id  : String?
    
    //var selectedDate : WeekdayDate?
    //var selectedTime : OptionsSlotBooking?
    
    var seletedSlotModel :  [SlotsDateModel]?
    
    var completion: ((slotBookingModel?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiUpdate()
        slotManage()
        //arrDate = getNextWeekDates()
        collectinView.dataSource = self
        collectinView.delegate = self
                
        timeCollView.dataSource = self
        timeCollView.delegate = self
        
        // let layout = UICollectionViewFlowLayout()
        // layout.itemSize = CGSize(width: 100, height: 100)
        
        // collectinView.collectionViewLayout = layout
        // self.collectinView.register(SlotBookingCollViewCell.nib, forCellWithReuseIdentifier: SlotBookingCollViewCell.reuseIdentifier)
        
        self.collectinView.registerReusableCell(SlotCollectionViewCell.self)
        self.timeCollView.registerReusableCell(SlotBookingCollViewCell.self)
         
        
        // Do any additional setup after loading the view.
    }
    
    func slotManage(){
        for (_ , val) in getNextWeekDates().enumerated() {
            slotOptions.append(SlotsDateModel(day : val.day ,dateVal: val.dateVal , date: val.date ,optionsSlots: slots))
        }
    }
     
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timeCollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        DispatchQueue.main.async {
            self.collectinView.reloadData()
            self.timeCollView.reloadData()
        }
    }
    
    func uiUpdate(){
        self.titleLab.font(font: .regular, size: .size14)
        
        self.saveButton.font(font: .medium, size: .size16)
        self.saveButton.color(color: .themeGreen)

        
        self.moreButton.font(font: .medium, size: .size16)
        self.moreButton.color(color: .themeGreen)

    }
    
    @IBAction func saveAction(_ sender : UIButton! ){
        
        var slotBookedModel : slotBookingModel?
        var solts = [selected_slotsModel]()
        for (_ , val )  in seletedSlotsList.enumerated(){
            
            let idArr = val.optionsSlots?.map{"\($0.id)"}
            
            solts.append(selected_slotsModel(date: val.date, time_slot_ids: idArr))
        }
        
        
        slotBookedModel = slotBookingModel(token: "", selected_slots: solts, pickup_chat_id: "", message_id: slot_message_id ?? "", user_id: "")
        
          
        
        completion?(slotBookedModel)
        self.coordinator?.dismissVC()
    }
    
    @IBAction func chooseMore(_sender : UIButton! ){
         
        if let dic = seletedSlots , (seletedSlots?.optionsSlots?.count ?? 0 ) > 0 {
            
            
            if let index = seletedSlotsList.firstIndex(where: { $0.dateVal == dic.dateVal }) {
                // Update the existing record
                seletedSlotsList[index] = dic
            } else {
                // No match found; append new record
                seletedSlotsList.append(dic)
            }
            
            print(seletedSlotsList)
            
        }else {
            showSimpleAlert(Message: "Please selected date and slots.")
        }
        seletedSlots = nil
        
    }
    
    @IBAction func cancelA(_sender : UIButton! ){
        
        self.coordinator?.dismissVC()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let collectionView = object as? UICollectionView {
            if collectionView == self.timeCollView {
                self.collectionViewHeight.constant = self.timeCollView.contentSize.height
                view.layoutIfNeeded()
            }
        }
        
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timeCollView.removeObserver(self, forKeyPath: "contentSize")
       
    }
    
}

extension SlotBookingViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == collectinView {
            return slotOptions.count
        }else {
            return slotOptions[seletedIndex].optionsSlots?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView == collectinView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotCollectionViewCell", for: indexPath) as!  SlotCollectionViewCell
            
            let dic = slotOptions[indexPath.row]
            
            cell.dateLab.text = "\(dic.dateVal )"
            cell.weakDayLab.text = dic.day
            cell.weakDayLab.textColor = .themeBlack
            
            cell.selectedView.backgroundColor = .clear
            cell.dateLab.textColor = .themeBlack
            if let selected = seletedSlots,
               selected.dateVal == dic.dateVal{
                cell.selectedView.backgroundColor = .themeGreen
                cell.dateLab.textColor = .themeWhite
                cell.weakDayLab.textColor = .themeWhite
            }
          /*  if let seletedArr = seletedSlots {
                
                for i in 0...seletedArr.count    {
                    
                    if seletedArr[i].date == dic.date{
                        cell.selectedView.backgroundColor = UIColor.themeGreen
                    }else {
                        cell.selectedView.backgroundColor = UIColor.clear
                    }
                }
            }*/
         
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotBookingCollViewCell", for: indexPath) as!  SlotBookingCollViewCell
            cell.selectedTimeView.isHidden = false
           
            let dic = slotOptions[seletedIndex].optionsSlots?[indexPath.row]

            
            cell.timeLab.text = dic?.time_slot
            cell.timeLab.textColor = .themeBlack
            cell.selectedTimeView.backgroundColor = .clear

            if let dic = dic,  // unwrap dic safely
               let arr = seletedSlots?.optionsSlots,
               arr.contains(where: { $0.id == dic.id }) {
                cell.timeLab.textColor = .themeWhite
                cell.selectedTimeView.backgroundColor = .themeGreen
            }
 
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView == collectinView {
            
            seletedIndex  = indexPath.row
            let dic = slotOptions[indexPath.row]
            
            
                  /// if dic.dateVal == seletedSlots?.dateVal {
                  ///     seletedSlots  = nil
                 //  }else {
                       seletedSlots = SlotsDateModel(
                           day: dic.day,
                           dateVal: dic.dateVal,
                           date: dic.date,
                           optionsSlots: []
                       )
                   //}
                
            if seletedSlotsList.count > 0 {
                for (ind , val ) in  seletedSlotsList.enumerated() {
                    if val.dateVal == dic.dateVal {
                        seletedSlots = val
                        break;
                    }
                }
            }
            
            
            
            collectionView.reloadData()
            timeCollView.reloadData()
            
            
        } else {
            
            let dateDic = slotOptions[seletedIndex]

            guard let dic = dateDic.optionsSlots?[indexPath.row] else { return }

            var slots = seletedSlots?.optionsSlots ?? []

            if let existingIndex = slots.firstIndex(where: { $0.id == dic.id }) {
                // Deselect: remove slot
                slots.remove(at: existingIndex)
            } else {
                // Select: add slot
                slots.append(dic)
            }

            // Create or update the selected slot model
            seletedSlots = SlotsDateModel(
                day: dateDic.day,
                dateVal: dateDic.dateVal,
                date: dateDic.date,
                optionsSlots: slots
            )

            collectinView.reloadData()
            collectionView.reloadData()
        }
        
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectinView {
            return 5
        }else {
            return 10
        }
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectinView {
            return 5
        } else {
            return 3
        }
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let wid = (collectionView.frame.size.width) // Default width
        let widt = self.view.frame.size.width
        if collectionView == collectinView {
            return CGSize(width: wid/5-10, height:   30)
        }else {
            return CGSize(width: wid/2-10, height:   40)
        }
    }
    
    
    func getNextWeekDates() -> [WeekdayDate] {
        var calendar = Calendar.current
            calendar.firstWeekday = 1 // Sunday = 1, Monday = 2...

            let today = Date()
            // Start from tomorrow
            guard let startDate = calendar.date(byAdding: .day, value: 1, to: today) else {
                return []
            }

            var result: [WeekdayDate] = []

            for i in 0..<7 {
                if let nextDate = calendar.date(byAdding: .day, value: i, to: startDate) {
                    let weekdayIndex = calendar.component(.weekday, from: nextDate) - 1
                    let shortWeekdayName = calendar.shortWeekdaySymbols[weekdayIndex].uppercased()
                    let day = calendar.component(.day, from: nextDate)
                    result.append(WeekdayDate(day: shortWeekdayName, dateVal: day , date: nextDate.convertTimeYYYYMMdd()))
                }
            }

            return result
    }
    
}
struct WeekdayDate {
    let day: String
    let dateVal : Int
    let date : String
}
struct TimeStruct {
    let id : String
    let time : String
}
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
