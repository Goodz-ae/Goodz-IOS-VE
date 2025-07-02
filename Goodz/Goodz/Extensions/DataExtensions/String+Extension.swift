//
//  String+Extension.swift
//  Goodz
//
//  Created by Akruti on 05/12/23.
//

import Foundation
import UIKit
import AVFoundation

// MARK: - String Styling Extensions
/// These extensions provide styling options for String:
///
/// - `capitalizingFirstLetter`: It will capitalize first letter of any string.
/// - `stringToImage`: Will convert string to image.
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    /// Convert string to UIImage
    func stringToImage() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
extension String {
    // To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "^[0-9]{6,14}$"
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    func isValidEmail(candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        if valid {
            valid = !candidate.contains("..")
        }
        return valid
    }
    
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
}
extension String {
    
    /// Apply strike font on text
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
}
extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    func UTCToLocal(inputFormat: String, outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: dt)
        } else {
            // Handle the case where the conversion from string to date fails
            print("Error: Unable to convert date string to Date")
            return ""
        }
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0
    }
    
    func toFloat() -> Float {
        return Float(self) ?? 0
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self.toFloat())
    }
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func formatAndCompareDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let now = Date()
            if calendar.isDateInToday(date) {
                // Calculate time difference in seconds
                let timeDifference = Int(now.timeIntervalSince(date))
                
                if timeDifference < 60 {
                    // Less than a minute ago
                    return "\(timeDifference) s ago"
                } else if timeDifference < 3600 {
                    // Less than an hour ago
                    let minutesAgo = timeDifference / 60
                    return "\(minutesAgo) m ago"
                } else {
                    // Less than a day ago
                    let hoursAgo = timeDifference / 3600
                    return "\(hoursAgo) h ago"
                }
            } else if calendar.isDateInYesterday(date) {
                // If it's yesterday, return "Yesterday"
                return "Yesterday"
            } else {
                // For other days, you can customize the format as needed
                dateFormatter.dateFormat = "MM/dd/yy"
                return dateFormatter.string(from: date)
            }
        } else {
            return ""
        }
    }
    
    func getTimerOnly() -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter1.date(from: self) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                // For today's date
                dateFormatter1.dateFormat = "hh:mm a"
                return dateFormatter1.string(from: date)
            } else {
                // For other dates
                dateFormatter1.dateFormat = "hh:mm a, MM/dd/yy"
                return dateFormatter1.string(from: date)
            }
        } else if let date = dateFormatter2.date(from: self) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                // For today's date
                dateFormatter2.dateFormat = "hh:mm a"
                return dateFormatter2.string(from: date)
            } else {
                // For other dates
                dateFormatter2.dateFormat = "hh:mm a, MM/dd/yy"
                return dateFormatter2.string(from: date)
            }
        } else if let date = dateFormatter3.date(from: self) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                // For today's date
                dateFormatter3.dateFormat = "hh:mm a"
                return dateFormatter3.string(from: date)
            } else {
                // For other dates
                dateFormatter3.dateFormat = "hh:mm a, MM/dd/yy"
                return dateFormatter3.string(from: date)
            }
        } else {
            return "Invalid date format"
        }
    }
    
    func setString() -> String {
        var numberString = String(self)
        if let dotIndex = numberString.firstIndex(of: ".") {
            numberString = String(numberString[..<dotIndex])
            return numberString
        } else{
            return ""
        }
    }
    
    func createVideoThumbnail(completion: @escaping ((_ image: UIImage)->Void)) {
        
        guard let url = URL(string: self) else {
            completion(.product)
            return
        }
        DispatchQueue.global().async {
            
            let url = url as URL
            let request = URLRequest(url: url)
            let cache = URLCache.shared
            
            if
                let cachedResponse = cache.cachedResponse(for: request),
                let image = UIImage(data: cachedResponse.data)
            {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            var time = asset.duration
            time.value = min(time.value, 2)
            
            var image: UIImage?
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                image = UIImage(cgImage: cgImage)
            } catch {
                print("error:", error)
                DispatchQueue.main.async {
                    completion(.product)
                }
            }
            
            if
                let image = image,
                let data = image.pngData(),
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                
                cache.storeCachedResponse(cachedResponse, for: request)
            }
            
            DispatchQueue.main.async {
                completion(image ?? .product)
            }
        }
    }
    
    func setComma() -> String {
        return self.count > 0 ? (self+", ") : self
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func setFormatCountryCode(_ countryCode: String) -> String {
        return "(\(countryCode)) \(self)"
    }
    
    func setString(str: String) -> String {
        return String(str.prefix(1)).uppercased() + String(str.dropFirst())
    }
    
    func toDate(withFormat format: String = "MM/dd/yyyy")-> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
    }
    
    func dateFormateChange(currDateFormate: String, needStringDateFormate: String) -> String {
        //String to Date Convert
        
        var dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currDateFormate
        guard let s = dateFormatter.date(from: dateString) else { return dateString }
        
        //CONVERT FROM NSDate to String
        
        dateFormatter.dateFormat = needStringDateFormate
        dateString = dateFormatter.string(from: s)
        print("Converted string:-", dateString)
        return dateString
    }
    
    func toJSON() -> Any? {
        let newstr = self.replacingOccurrences(of: "\\", with: "")
        guard let data = newstr.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    func toURL() -> URL? {
        URL(string: self)
    }
    
    func setPercentage() -> String {
        
        if !contains("%") {
            return  self + "%"
        }else {
            return self
        }
    }
}
