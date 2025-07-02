//
//  Constants.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit

typealias SwiftDict = [String: Any]

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad ? true : false
let bgRemoverKey = "gYrX5qx3Vg7FUFC9J5RNCY7F"

struct Constants {
    static var devicID = UIDevice.current.identifierForVendor!.uuidString
    static var deviceType = UIDevice.current.model
    public static let headerHeight: CGFloat = 56
    public static let mobileNumberLength = 10
    public static let pinCodeNumberLength = 6
    public static let otpLength = 4
    public static let apiSuccessStatus = "SUCCESS"
    public static let MobilePrefix = "+880"
    static var isBiometricsEnabled = false
    static let birthAgeMinDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    static let birthAgeMaxDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())!

    static var isLoggerOn = true
    
    static var ipInfoUrl = "https://ipinfo.io/json"

    static func getAttributedText(toBeAttributedTextDict textArray: [SwiftDict]) -> NSMutableAttributedString {
        let finalString = NSMutableAttributedString()
        for dict in textArray {
            let str = dict[DefaultKeys.text.rawValue] as? String ?? ""
            let tempString = NSAttributedString(string: str, attributes: getAttributes(color: dict[DefaultKeys.color.rawValue] as? UIColor ?? .darkGray, font: dict[DefaultKeys.font.rawValue] as? UIFont ?? .systemFont(ofSize: 12)))
            finalString.append(tempString)
        }
        return finalString
    }

   static private func getAttributes(color: UIColor, font: UIFont) -> [NSAttributedString.Key: Any] {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSMutableAttributedString.Key.foregroundColor: color]
        return attributes
    }
}

struct DateFormat {
    static let ddMMyyyy = "dd-MM-yyyy"
    static let MMDDyyyy = "MM-dd-yyyy"
    static let yyyyMMdd = "yyyy-mm-dd"
    static let apiDateFormate_ymd_Hms = "yyyy-MM-dd HH:mm:ss"
    static let apiDateFormateymd = "yyyy-MM-dd"
    static let appDateFormateMMddYYY = "MM/dd/yyyy"
    static let appDateFormate_hma_MM_dd_YY = "HH:mm a, MM/dd/yy"
    static let appDateFormate_MM_dd_YY_hma = "MM/dd/yy, hh:mm a"
    static let appDateFormate_mmm_dd = "MMM dd"
}

enum DefaultKeys: String {
    case text
    case color
    case font
}

enum Keychain: String {
    case merchantCode
    case userPIN
    case userName
}

enum FileType: String {
    case image = "IMAGE"
    case video = "VIDEO"
    case document = "DOCUMENT"
    case pdf = "pdf"
    case audio = "audio"
    case zip = "zip"
    case rar = "rar"
    case txt = "txt"
    case text = "text"
    case rtf = "rtf"
}

enum ImageType: String {
    case document = "DOCUMENT"
    case tin = "TIN"
    case tinBack = "TIN_BACK"
    case tinFront = "TIN_FRONT"
    case photograph = "PHOTOGRAPH"
    case tradeLicense = "TRADE_LICENSE"
    case companyProfile = "COMPANY_TYPE"
    case bankAccountDetails = "BANK_ACCOUNT_DETAILS"
    case userDetails = "USER_PROFILE"
    case nidFront = "NID_FRONT"
    case nidBack = "NID_BACK"
    case vat = "VAT"
    case otherImg = "OTHER"
    case passport = "PASSPORT"
    case drivingLicense = "DRIVING_LICENCE"
    case birthCertificate = "BIRTH_CERTIFICATE"
    case passportPage1 = "PASSPORT_PAGE_1"
    case drivingLicenseFront = "DRIVING_LICENCE_FRONT"
    case passportPage2 = "PASSPORT_PAGE_2"
    case drivingLicenseBack = "DRIVING_LICENCE_BACK"
    case businessPhoto = "BUSINESS_LOGO"
    case profilePhoto = "PROFILE_PHOTO"
    case nid = "NID"
}

enum MimeType: String {
    case image = "image/jpeg"
}

enum FileUploadParamName: String {
    case document = "file"
    case idForOCR = "files"
}
