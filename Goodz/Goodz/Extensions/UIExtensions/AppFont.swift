//
//  AppFont.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import UIKit

// MARK: Protocol to Change font size and font style
protocol AppFontProtocol {
    var value: UIFont { get }
}

// MARK: Enum for application font and size
enum AppFont: AppFontProtocol {
    
    var value: UIFont {
        
        switch self {
        case .black(let size):
            return UIFont(name: "Poppins-Black", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .bold(let size):
            return UIFont(name: "Poppins-Bold", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .extraBold(let size):
            return UIFont(name: "Poppins-ExtraBold", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .extraLight(let size):
            return UIFont(name: "Poppins-ExtraLight", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .italic(let size):
            return UIFont(name: "Poppins-Italic", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .light(let size):
            return UIFont(name: "Poppins-Light", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .medium(let size):
            return UIFont(name: "Poppins-Medium", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .regular(let size):
            return UIFont(name: "Poppins-Regular", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .semibold(let size):
            return UIFont(name: "Poppins-SemiBold", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        case .thin(let size):
            return UIFont(name: "Poppins-Thin", size: size.rawValue) ?? UIFont.systemFont(ofSize: 25)
        }
        
    }
    case black(_ size: FontSize)
    case bold(_ size: FontSize)
    case extraBold(_ size: FontSize)
    case extraLight(_ size: FontSize)
    case italic(_ size: FontSize)
    case light(_ size: FontSize)
    case medium(_ size: FontSize)
    case regular(_ size: FontSize)
    case semibold(_ size: FontSize)
    case thin(_ size: FontSize)
    
}
