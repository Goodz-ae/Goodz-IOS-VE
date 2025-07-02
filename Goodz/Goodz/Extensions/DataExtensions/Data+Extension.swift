//
//  Data+Extension.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import Foundation

extension Data {
    var dict: [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? [String: Any]
    }
}

extension Date {
    func convertTimeYYYYMMdd()->String{
        let dateFromServer      = self
        let formate2nd          = DateFormatter()
        formate2nd.addExLocalDateFormate()
        formate2nd.dateFormat = DateFormatE.YYYYMMdd.rawValue
        formate2nd.timeZone =  TimeZone(abbreviation: "UTC")
        let date2 = formate2nd.string(from: dateFromServer)
        return "\(date2)"
    }
}

extension String {
    
      
    
 
    
    
     
     
    
    
    
    func loadDateTimeSSSZ_UTC(dateFormate : String ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.addExLocalDateFormate()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormatE.YMSTHMSSssZZZZZ.rawValue
       // print(self)
        if let lbldate  = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = dateFormate
            //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone  =   TimeZone(identifier: "UTC") //TimeZone(abbreviation: "America/New_York")
            let finaltime  = dateFormatter.string(from:lbldate)
        //    print(finaltime)
            return finaltime
        }
        return ""
    }
    
    func loadDateTimeSSSZ_UTC2(dateFormate : String ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.addExLocalDateFormate()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormatE.YMSTHMSS.rawValue
       // print(self)
        if let lbldate  = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = dateFormate
            //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone =   TimeZone(identifier: "UTC") //TimeZone(abbreviation: "America/New_York")
            let finaltime  = dateFormatter.string(from: lbldate )
           // print(finaltime)
            return finaltime
        }
        return ""
    }
    
    func loadDate(dateFormate : String) -> String? {
        let dateFormatter = DateFormatter()
       // dateFormatter.addExLocalDateFormate()
        dateFormatter.dateFormat = DateFormatE.YYYYMMdd.rawValue
        //dateFormatter.timeZone =  TimeZone(abbreviation: "UTC")
        // Fri, Jan 14
        if let lbldate  = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = dateFormate
            return  dateFormatter.string(from: lbldate )
        }
        return ""
    }
    
    
    func convertDateForYYYYMMdd(abbreviation : String = "UTC")->Date{
        
        let dateFormatter          = DateFormatter()
        dateFormatter.addExLocalDateFormate()
        dateFormatter.dateFormat   = DateFormatE.YMSTHMSS.rawValue
        dateFormatter.timeZone =  TimeZone(abbreviation: abbreviation)
        
       
        dateFormatter.dateFormat   = DateFormatE.YYYYMMdd.rawValue
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
         
        return  Date()
        
    }
    
    func convertDateForGMT(abbreviation : String = "UTC")->Date{
        
        let dateFormatter          = DateFormatter()
       // dateFormatter.addExLocalDateFormate()
        dateFormatter.dateFormat   = DateFormatE.YMSTHMSSZ.rawValue
       // dateFormatter.timeZone =  TimeZone(abbreviation: abbreviation)
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat   = DateFormatE.YMSTHMSSssZZZZZ.rawValue
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat   = DateFormatE.YYYYMMddHHmmss.rawValue
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat   = DateFormatE.YYYYMMddHHmmssZ.rawValue
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat   = DateFormatE.YYYYMMdd.rawValue
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
         
        return  Date()
        
    }
}
enum DateFormatE : String {
    
    case YMSTHMSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case YMSTHMSSssZZZZZ = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    case YMSTHMSS = "yyyy-MM-dd'T'HH:mm:ss"
    
    case yyyy_MM_dd_SSS =  "yyyy-MM-dd'T'HH:mm:ss GMT+SSSZ"
    
    case E_MMM_d_yyyy_HH_mm_ss_Z = "E MMM d yyyy HH:mm:ss GMT+SSSZ"
        
    case    YYYYMMddHHmmss      =       "yyyy-MM-dd HH:mm:ss"
    case    YYYYMMddHHmmssZ     =       "yyyy-MM-dd HH:mm:ssZ"
    case    MMddyyyyHHmmss      =       "MM-dd-yyyy HH:mm:ss"
    
    case    HHmmss          =       "HH:mm:ss"
    case    hhmma           =       "hh:mm a"
    case    hmma            =       "h:mm a"
    case    MMddhmma        =       "MMM dd, h:mm a"
    case    YYYYMMdd        =       "yyyy-MM-dd"
    case    EEEEMMMdd       =       "EEEE, MMM dd"
    case    MMMdd_yyyy      =       "MMM dd,yyyy"
    case    HMSA            =       "HH:mm:ss a"
    case    EEEMMMdd        =       "EEE, MMM dd"
    //"yyyy-MM-dd HH:mm:ss"
}
extension DateFormatter {
    
    func addExLocalDateFormate(){
        self.locale = Locale(identifier: "en_US_POSIX")
        self.setLocalizedDateFormatFromTemplate("HH:mm")
        
    }
}
