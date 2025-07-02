//
//  SelectDateTime+Calender.swift
//  Goodz
//
//  Created by Priyanka Poojara on 28/12/23.
//

import UIKit
import FSCalendar

extension SelectDateAndTimeVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        // Get tomorrow's date
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return tomorrow
    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        // Get tomorrow's date
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        // Add 72 hours to tomorrow's date
        let maximumDate = Calendar.current.date(byAdding: .hour, value: 72, to: tomorrow)!
        return maximumDate
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        debugPrint("SELECTEDDATA")
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //debugPrint("didSelect",date)
        
        self.selectedDate = self.dateFormatter2.string(from: date)
        if calendar == viewCalendar {
            
            // strFromDate = dateString
            // self.showCal2()
            // self.setUpdateCalender2()
            
        }
    }
    
    func getPreviousMonth(date:Date) -> Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    func getNextMonth(date:Date) -> Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
}
