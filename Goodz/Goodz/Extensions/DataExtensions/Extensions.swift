//
//  UIExtensions.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit
import MobileCoreServices

var kAssociationKeyMaxLength: Int = 0

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

@IBDesignable
class SpinnerView : UIView {
    
    override var layer: CAShapeLayer {
        return super.layer as? CAShapeLayer ?? CAShapeLayer()
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor(ciColor: .black).withAlphaComponent(0.50).cgColor
        layer.lineWidth = 3
        setPath()
    }
    
    override func didMoveToWindow() {
        animate()
    }
    
    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }
    
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
    
    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7)
            ]
            
        }
    }
    
    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
        
        // animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 36
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        for i in 0 ... count {
            animation.values?[i] = UIColor.black.cgColor
        }
        
        animation.duration = duration
        animation.calculationMode = .linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
}

// MARK: - UIScrollView Extension
///
/// - `addRefreshControl`: It will add refreshcontrol to scrollview, tableview.
extension UIScrollView {
    func addRefreshControl(target: Any, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        refreshControl.tintColor = .themeGreen
        
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            addSubview(refreshControl)
        }
    }
    
    func endRefreshing() {
            if #available(iOS 10.0, *) {
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                }
            } else {
                // If not using refreshControl property in iOS 10, you may need to handle it differently.
                // For example, if you added the refresh control using addSubview, you can find and remove it.
                for view in subviews {
                    if let refreshControl = view as? UIRefreshControl {
                        if refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
                            refreshControl.removeFromSuperview()
                        }
                    }
                }
            }
        }
}

/// - Custom Class to update contraint values according to the mobilke devices
/// - Will check that weather device is notched or not
/// - Then apply constant value to your view
class NotchedConstraintConstant: NSLayoutConstraint {
    
    var mainConstant: CGFloat = 0 // Main Constant to hold the default value
    
    @IBInspectable var nonNotchedConst: CGFloat = 0 {
        didSet {
            if enableDynamicHeight {
                setUpConstraint()
            }
        }
    }
    
    @IBInspectable var notchedConst: CGFloat = 0 {
        didSet {
            if enableDynamicHeight {
                setUpConstraint()
            }
        }
    }
    
    /// Only enablig this will trigger the prorata
    fileprivate func setUpConstraint() {
        if UIDevice.current.hasNotch == false { // if prorata is enabled change the constant value
            
            self.constant = nonNotchedConst
            
        } else {
            
            self.constant = notchedConst
            
        }
    }
    
    @IBInspectable
    var enableDynamicHeight: Bool = false {
        didSet {
            mainConstant = constant
            if enableDynamicHeight {
                setUpConstraint()
            }
        }
    }
}

/// Will check that device is notched or not
extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            // Fallback on earlier versions
            return false
        }
    }
}

extension UILabel {
    func setStrikethrough(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
    func setStrikethrough(normalText: String,text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.themeGray, range: NSMakeRange(0, attributedString.length))
        let attributedNormalString = NSMutableAttributedString(string: normalText + " ")
        self.attributedText = attributedNormalString.append(attributedString: attributedString)
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        
        let targetRange = (lblText as NSString).range(of: targetText)
        
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes([NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize], range: NSRange(location: 0, length: attributedString.length))
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}

extension URL {
    func mimeType() -> String {
         let pathExtension = self.pathExtension
         if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
             if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
             }
         }
         return "application/octet-stream"
    }

    var containsImage: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
             return false
        }
        return UTTypeConformsTo(uti, kUTTypeImage)
    }

    var containsAudio: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
              return false
        }
        return UTTypeConformsTo(uti, kUTTypeAudio)
    }
    var containsVideo: Bool {
        let mimeType = self.mimeType()
        guard  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
               return false
        }
        return UTTypeConformsTo(uti, kUTTypeMovie)
    }
 }

extension UITextField {
    
    func setDatePickerAsInputViewFor(target:Any, selector:Selector,minimumDate: Date? = nil,maximumDate: Date? = nil, currentDate: Date = Date(), datePickerMode: UIDatePicker.Mode = .date){
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 200.0))
        datePicker.datePickerMode = datePickerMode
        
        if datePickerMode == .time {
            datePicker.locale = Locale.init(identifier: "en_us")
        }
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.inputView = datePicker
        datePicker.date = datePickerMode == .time ? currentDate : (self.text?.toDate() ?? Date())
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 40.0))
        let cancel = UIBarButtonItem(title: Labels.cancel, style: .plain, target: self, action: #selector(tapCancel))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: Labels.done, style: .done, target: nil, action: selector)
        
        toolBar.setItems([cancel,flexibleSpace, done], animated: false)
        self.inputAccessoryView = toolBar
        
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    func setAutocapitalization(_ autocapitalizationType: UITextAutocapitalizationType = .sentences) {
        self.autocapitalizationType = autocapitalizationType
    }
    
    
    func enforceCharacterLimit(max: Int) {
        self.delegate = self
        addTarget(self, action: #selector(limitTextLength), for: .editingChanged)
        objc_setAssociatedObject(self, &AssociatedKeys.maxLimit, max, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func getCharacterCount() -> Int {
        return self.text?.count ?? 0
    }
    
    private struct AssociatedKeys {
        static var maxLimit = "maxLimit"
    }
}

extension UITextField: UITextFieldDelegate {
    @objc private func limitTextLength() {
        let maxLimit = objc_getAssociatedObject(self, &AssociatedKeys.maxLimit) as? Int ?? Int.max
        
        if let text = self.text, text.count > maxLimit {
            self.text = String(text.prefix(maxLimit))
        }
    }
}

extension UITextView {
    
    func setAutocapitalization(_ autocapitalizationType: UITextAutocapitalizationType = .sentences) {
        self.autocapitalizationType = autocapitalizationType
    }
}

extension URLRequest {
    public func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        
        return cURL
    }
}

extension Decodable {
    
    func decodeToString<K:CodingKey>(_ value: KeyedDecodingContainer<K>, key: KeyedDecodingContainer<K>.Key) -> String? {
        var str: String? = nil
        if let res = try? value.decodeIfPresent(String.self, forKey: key) {
            str = res
        } else if let res = try? value.decodeIfPresent(Int.self, forKey: key) {
            str = String(format: "%@", "\(res)")
        } else if let res = try? value.decodeIfPresent(Double.self, forKey: key) {
            str = String(format: "%@", "\(res)")
        } else if let res = try? value.decodeIfPresent(Int64.self, forKey: key) {
            str = String(format: "%@", "\(res)")
        }
        return str
    }
}

extension Double {
    var clean: String {
            let roundedValue = (self * 100).rounded() / 100 // Round to two decimal places
            return String(format: "%.2f", roundedValue)
        }
}

extension Notification.Name {
    static let isFromSplash = Notification.Name("ISFROMSPLASH")
}
extension Formatter {
    static let custom: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
extension FloatingPoint {
    var isWholeNumber: Bool { isNormal ? self == rounded() : isZero }
    var customString: String {
        Formatter.custom.minimumFractionDigits = isWholeNumber ? 0 : 2
        return Formatter.custom.string(for: self) ?? ""
    }
}
