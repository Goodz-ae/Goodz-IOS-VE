//
//  CustomButton.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    var activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    var loaderTintColor : UIColor?
    private var preSetTitle = String()
    
    @IBInspectable
    var cornderRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornderRadius
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor, cornerRadius: cornderRadius)
        }
    }
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?, borderWidth: CGFloat? = 0, borderColor: UIColor? = UIColor.black, cornerRadius: CGFloat = 0) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: -0.3, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.borderColor = borderColor?.cgColor
            gradientLayer.borderWidth = borderWidth ?? 0
            gradientLayer.cornerRadius = cornderRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    /// loader show/hide
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.superview?.addSubview(activityView)
        activityView.frame = self.frame
        activityView.isHidden = true
        preSetTitle = titleLabel?.text ?? ""
        activityView.color = .themeWhite

    }

    func showLoader() {
        DispatchQueue.main.async {
            self.setTitle("", for: .normal)
            self.activityView.isHidden = false
            self.activityView.startAnimating()
            self.isUserInteractionEnabled = false
            self.superview?.bringSubviewToFront(self.activityView)
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.setTitle(self.preSetTitle, for: .normal)
            self.activityView.isHidden = true
            self.activityView.stopAnimating()
            self.isUserInteractionEnabled = true
           
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
  
}

class ThemeGreenButton : UIButton {
    
    // rgba(143, 203, 180, 1)
    // rgba(155, 209, 198, 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.backgroundColor = .themeGreen
        self.cornerRadius(cornerRadius: 4.0)
        self.font(font: .semibold, size: .size16)
        self.tintColor = .themeWhite
        
    }
}

class ThemeGreen14Button : UIButton {
    
    // rgba(143, 203, 180, 1)
    // rgba(155, 209, 198, 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.backgroundColor = .themeGreen
        self.cornerRadius(cornerRadius: 4.0)
        self.font(font: .semibold, size: .size12)
        self.tintColor = .themeWhite
        
    }
}

class ThemeGreenButton_14 : UIButton {
    
    // rgba(143, 203, 180, 1)
    // rgba(155, 209, 198, 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.backgroundColor = .themeGreen
        self.cornerRadius(cornerRadius: 4.0)
        self.font(font: .regular, size: .size14)
        self.tintColor = .themeWhite
        
    }
}

class ThemeGreenBorderButton : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.backgroundColor = .themeWhite
        self.cornerRadius(cornerRadius: 4.0)
        self.border(borderWidth: 2.0, borderColor: .themeGreen.withAlphaComponent(0.6))
        self.font(font: .semibold, size: .size16)
        self.tintColor = .themeWhite
        
    }
}

class ThemeGreenBorder14Button : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.backgroundColor = .themeWhite
        self.cornerRadius(cornerRadius: 4.0)
        self.border(borderWidth: 2.0, borderColor: .themeGreen.withAlphaComponent(0.6))
        self.font(font: .semibold, size: .size12)
        self.tintColor = .themeBlack
        
    }
}

// ThemeBlackGreyButton
class ThemeBlackGrayButton : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.backgroundColor = .clear
        self.font(font: .semibold, size: .size16)
        self.setTitleColor(.themeBlack, for: .selected)
        self.setTitleColor(.themeGray, for: .normal)
       
    }
    
}

class SmallGreenBorderButton : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.backgroundColor = .themeWhite
        self.cornerRadius(cornerRadius: 4.0)
        self.border(borderWidth: 1.5, borderColor: .themeGreen.withAlphaComponent(0.6))
        self.font(font: .medium, size: .size12)
        self.tintColor = .themeBlack
        
    }
}

class SmallGreenButton : UIButton {
    
    // rgba(143, 203, 180, 1)
    // rgba(155, 209, 198, 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle() {
        self.backgroundColor = .themeGreen
        self.cornerRadius(cornerRadius: 4.0)
        self.font(font: .medium, size: .size12)
        self.tintColor = .themeWhite
        
    }
}
