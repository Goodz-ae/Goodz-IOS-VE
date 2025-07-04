//
//  Function.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import UIKit
import AVFoundation
import Foundation
import QuickLook
import Photos
import PhotosUI

class FUNCTION {
    
    func getDataFromJsonFile(fileName: String) -> Data? {
        
        do {
            
            let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
            let jsonData = try Data(contentsOf: url)
            
            return jsonData
            
        } catch {
            
            return nil
        }
    }
    
    func getFont(for font: FontName, size: FontSize) -> UIFont {
        
        return UIFont(name: font.rawValue, size: getFontSize(size: size.rawValue))!
    }
    
    func getColorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    func isValidEmail(email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        
        let passwordRegex: String = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,15}$"
        let predicateForPassword: NSPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicateForPassword.evaluate(with: password)
    }
    
    //    func isValidContactNumber(number: String, userAddress: UserAddress? = nil) -> Bool {
    //
    //        var count = (CurrentCountry().getCountry()?.country_code?.count ?? 0)+1+(Int(CurrentCountry().getCountry()?.mobile_length ?? "") ?? 8)
    //
    //        if let address = userAddress {
    //            count = (address.phone_code?.count ?? 0)+1+(Int(address.mobile_length ?? "") ?? 8)
    //        }
    //
    //        if number.count > count {
    //            return false
    //        } else if number.count < count {
    //            return false
    //        } else {
    //            return true
    //        }
    //
    //    }
    
    func isValidContactNumEditScreen(number: String , lenght : String, crCode : String) -> Bool {
        let count = (crCode.count)+1+(Int(lenght) ?? 8)
        if number.count > count {
            return false
        } else if number.count < count {
            return false
        } else {
            return true
        }
    }
    
    func formatedNumber(formate: String, number: String) -> String {
        
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        
        var index = cleanPhoneNumber.startIndex
        for ch in formate where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
    
    func getFontSize(size: CGFloat) -> CGFloat {
        
        // var sizeNew = size
        //        if screenHeight >= 736 {
        //            sizeNew = sizeNew + 2.0
        //        } else if screenHeight >= 667 {
        //            sizeNew = sizeNew + 1.5
        //        } else if screenHeight <= 568 {
        //            sizeNew = sizeNew + 1.0
        //        }
        
        //        if IS_IPAD {
        //            sizeNew = sizeNew + 2.5
        //        }
        
        return size
    }
    
    func getLocalCountryCode() -> String? {
        
        return (Locale.current as NSLocale).object(forKey: .countryCode) as? String
    }
    
    func  getAttributedString(string: String,
                              color: UIColor? = nil,
                              backgroundColor: UIColor? = nil,
                              strikethroughStyle: Int? = nil,
                              shadowBlurRadius: Int? = nil,
                              shadowOffset: CGSize? = nil,
                              shadowColor: UIColor? = nil,
                              strokeWidth: Int? = nil,
                              underlineStyle: NSUnderlineStyle? = nil,
                              font: UIFont? = nil) -> NSAttributedString {
        var newAttribute : [NSAttributedString.Key : Any]? = [:]
        
        if font != nil {
            newAttribute?.updateValue(font as Any, forKey: NSAttributedString.Key.font)
        }
        
        if color != nil {
            newAttribute?.updateValue(color as Any, forKey: NSAttributedString.Key.foregroundColor)
        }
        if strikethroughStyle != nil {
            newAttribute?.updateValue(strikethroughStyle as Any, forKey: NSAttributedString.Key.strikethroughStyle)
        }
        
        let shadow = NSShadow()
        if shadowBlurRadius != nil {
            shadow.shadowBlurRadius = CGFloat(shadowBlurRadius ?? 0)
        }
        if shadowOffset != nil {
            shadow.shadowOffset = shadowOffset!
        }
        if shadowColor != nil {
            shadow.shadowColor = shadowColor
        }
        
        newAttribute?.updateValue(shadow, forKey: NSAttributedString.Key.shadow)
        
        if strokeWidth != nil {
            newAttribute?.updateValue(strokeWidth as Any, forKey: NSAttributedString.Key.strokeWidth)
        }
        if backgroundColor != nil {
            newAttribute?.updateValue(backgroundColor as Any, forKey: NSAttributedString.Key.backgroundColor)
        }
        if underlineStyle != nil {
            newAttribute?.updateValue(underlineStyle!.rawValue, forKey: NSAttributedString.Key.underlineStyle)
        }
        
        return NSAttributedString(string: string, attributes: newAttribute)
    }
    
    func setAttributedStringforStatus(_ str: String) -> NSAttributedString {
        var atrstrStatus = str
        var arr = atrstrStatus.components(separatedBy: " : ")
        if arr.count != 2 {
            atrstrStatus = atrstrStatus.replacingOccurrences(of: ": ", with: "")
            atrstrStatus = atrstrStatus.replacingOccurrences(of: " :", with: "")
            
            arr = atrstrStatus.components(separatedBy: ":")
        }
        
        let attString = NSMutableAttributedString(string: String(format: "%@ : ", arr[0]))
        let attString1 = NSMutableAttributedString(string: String(format: "%@", arr[1]))
        
        attString1.addAttribute(
            .foregroundColor,
            value: UIColor.blue,
            range: NSRange(location: 0, length: attString1.length)
        )
        attString.append(attString1)
        
        return attString
    }
    
    /*
     func formatPoints(num: Double) -> String {
     
     let thousandNum = num/1000
     let millionNum = num/1000000
     
     if num >= 1000 && num < 1000000 {
     
     if (floor(thousandNum) == thousandNum) {
     return("\(Int(thousandNum))K")
     }
     return("\(thousandNum.roundToPlaces(places: 1))K")
     }
     if num > 1000000 {
     
     if(floor(millionNum) == millionNum) {
     return("\(Int(thousandNum))K")
     }
     return ("\(millionNum.roundToPlaces(places: 1))M")
     }
     else{
     
     if(floor(num) == num) {
     return ("\(Int(num))")
     }
     return ("\(num)")
     }
     }
     
     func getHmsFromCMTime(cmTime: CMTime) -> (hh: String, mm: String, ss: String, secInt: Int) {
     
     let timeSecond = Int(CMTimeGetSeconds(cmTime))
     let hh = (timeSecond / 3600);
     let mm = ((timeSecond % 3600) / 60);
     let ss = ((timeSecond % 3600) % 60);
     
     return (h: String(format: "%.02d", h),
     m: String(format: "%.02d", m),
     s: String(format: "%.02d", s),
     secInt: timeSecond)
     }
     
     func getHmsFromCMTime(timeSecond: Int) -> (ah: String, am: String, aas: String) {
     
     let ah = (timeSecond / 3600);
     let am = ((timeSecond % 3600) / 60);
     let aas = ((timeSecond % 3600) % 60);
     
     return (ah: String(format: "%.02d", h),
     am: String(format: "%.02d", m),
     aas: String(format: "%.02d", s))
     }
     */
    func convertDateFormate(date : Date) -> String {
        
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM, yyyy"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
    
    func convertServerDateTime(toLocalDeviceDateTime strDateTime: String, isFromChatDetails: Bool) -> String? {
        
        var strDateTime = strDateTime
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter1.date(from: strDateTime) else {
            return ""
        }
        
        let currentTimeZone = NSTimeZone.local as NSTimeZone
        let utcTimeZone = NSTimeZone(abbreviation: "UTC")!
        
        let currentGMTOffset = currentTimeZone.secondsFromGMT(for: date)
        let gmtOffset = utcTimeZone.secondsFromGMT(for: date)
        let gmtInterval = TimeInterval((currentGMTOffset) - (gmtOffset))
        
        let destinationDate = Date(timeInterval: gmtInterval, since: date)
        let currentDate = Date()
        let timeDifference = currentDate.timeIntervalSince(destinationDate)
        let time = Int(round(timeDifference))
        
        let daycount = (Double(time) / 86400.00)
        if daycount <= 0.50 {
            
            let dateFormatters = DateFormatter()
            dateFormatters.dateFormat = "hh:mm a"
            
            dateFormatters.timeZone = NSTimeZone.system
            strDateTime = dateFormatters.string(from: destinationDate)
            
            if isFromChatDetails {
                strDateTime = "Today \(strDateTime)"
            } else {
                strDateTime = "\(strDateTime)"
            }
            
            return strDateTime
        } else if daycount > 0 && daycount < 2 {
            
            let dateFormatters = DateFormatter()
            dateFormatters.dateFormat = "hh:mm a"
            
            dateFormatters.timeZone = NSTimeZone.system
            strDateTime = dateFormatters.string(from: destinationDate)
            
            if isFromChatDetails {
                strDateTime = "Yesterday \(strDateTime)"
            } else {
                strDateTime = "Yesterday"
            }
            
            return strDateTime
        } else {
            
            let dateFormatters = DateFormatter()
            
            if isFromChatDetails {
                dateFormatters.dateFormat = "dd MMM yy hh:mm a"
            } else {
                dateFormatters.dateFormat = "dd MMM yy"
            }
            
            dateFormatters.timeZone = NSTimeZone.system
            strDateTime = dateFormatters.string(from: destinationDate)
            
            return strDateTime
        }
    }
    
    func getImages(assets : [PHAsset], completion:@escaping ([UIImage]) -> Void) {
        
        let group = DispatchGroup()
        var images : [UIImage] = []
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.version = .current
        options.resizeMode = .exact
        
        let manager = PHImageManager.default()
        
        for asset in assets {
            
            let w : CGFloat = CGFloat(asset.pixelWidth)
            let h : CGFloat = CGFloat(asset.pixelHeight)
            
            let size = CGSize(width: w * 0.5, height: h * 0.5)
            
            group.enter()
            manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { (image, info) in
                
                if let image = image {
                    
                    images.append(image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(images)
        }
    }
    
    func getUnique() -> String {
        
        var unique: String {
            var result = ""
            repeat {
                result = String(format:"%04d", arc4random_uniform(10000) )
                
            } while Set<Character>(result).count < 4
            
            return ("\(Int(Date().timeIntervalSince1970))" + result)
        }
        
        return unique
    }
    
    func textToHtml(str: String) -> String {
        var htmlString = str
        htmlString = htmlString.replacingOccurrences(of: "&amp;" , with: "&")
        htmlString = htmlString.replacingOccurrences(of: "&lt;" , with: "<")
        htmlString = htmlString.replacingOccurrences(of: "&gt;" , with: ">")
        htmlString = htmlString.replacingOccurrences(of: "&quot;", with: "\"\"")
        htmlString = htmlString.replacingOccurrences(of: "&#039;" , with: "'")
        htmlString = htmlString.replacingOccurrences(of: "<br>", with: "\n")
        return htmlString
    }
    
}

struct AppInfo {
    
    var appName : String {
        return readFromInfoPlist(withKey: "CFBundleName") ?? "(unknown app name)"
    }
    
    var version : String {
        return readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? "(unknown app version)"
    }
    
    var build : String {
        return readFromInfoPlist(withKey: "CFBundleVersion") ?? "(unknown build number)"
    }
    
    var minimumOSVersion : String {
        return readFromInfoPlist(withKey: "MinimumOSVersion") ?? "(unknown minimum OSVersion)"
    }
    
    var copyrightNotice : String {
        return readFromInfoPlist(withKey: "NSHumanReadableCopyright") ?? "(unknown copyright notice)"
    }
    
    var bundleIdentifier : String {
        return readFromInfoPlist(withKey: "CFBundleIdentifier") ?? "(unknown bundle identifier)"
    }
    
    var developer : String { return "ADASAT" }
    
    // lets hold a reference to the Info.plist of the app as Dictionary
    private let infoPlistDictionary = Bundle.main.infoDictionary
    
    /// Retrieves and returns associated values (of Type String) from info.Plist of the app.
    private func readFromInfoPlist(withKey key: String) -> String? {
        return infoPlistDictionary?[key] as? String
    }
}
