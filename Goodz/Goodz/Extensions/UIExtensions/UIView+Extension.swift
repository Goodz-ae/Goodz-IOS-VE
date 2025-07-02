//
//  UIView+Extension.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//

import Foundation
import UIKit

extension UIView {
    func setGradient(startColor: UIColor, endColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func round() {
        
        self.layer.cornerRadius = frame.size.height / 2.0
        self.clipsToBounds = true
    }
    
    func cornerRadius(cornerRadius: CGFloat, clipsToBounds: Bool = true) {
        DispatchQueue.main.async {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = clipsToBounds
            
        }
    }
    
    func border(borderWidth: CGFloat, borderColor: UIColor) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func setRoundBorderWithColor(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, clipsToBounds: Bool = true) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func shadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat) {
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false
        
    }
}
extension UIView {

   func roundTopCorners(radius: CGFloat = 10) {
    
       self.clipsToBounds = true
       self.layer.cornerRadius = radius
       if #available(iOS 11.0, *) {
           self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       } else {
           self.roundCorners(corners: [.topLeft, .topRight], radius: radius)
       }
   }

   func roundBottomCorners(radius: CGFloat = 10) {
    
       self.clipsToBounds = true
       self.layer.cornerRadius = radius
       if #available(iOS 11.0, *) {
           self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
       } else {
           self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
       }
   }

}
/// Tap Gesture extension
extension UIView {
    func addTapGesture(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UIView Styling Extensions
/// These extensions cover various styling properties for UIViews:
///
/// - `cornerRadius`: The corner radius of the view's layer.
/// - `borderWidth`: The width of the view's border.
/// - `borderColor`: The color of the view's border.
/// - `shadowRadius`: The radius of the view's shadow.
/// - `shadowOpacity`: The opacity of the view's shadow.
/// - `shadowOffset`: The offset of the view's shadow.
/// - `shadowColor`: The color of the view's shadow.
extension UIView {
    /// Individual corner radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var maskCorners: CACornerMask {
        get {
            return layer.maskedCorners
        }
        set {
            layer.maskedCorners = newValue
            clipsToBounds = true
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}
