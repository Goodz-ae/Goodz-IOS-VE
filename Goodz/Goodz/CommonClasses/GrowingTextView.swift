//
//  GrowingTextView.swift
//  Goodz
//
//  Created by Akruti on 06/03/24.
//

import Foundation
import UIKit

@objc public protocol GrowingTextViewDelegate: UITextViewDelegate {
    @objc optional func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
}

@IBDesignable @objc
open class GrowingTextView: UITextView {
    override open var text: String! {
        didSet { setNeedsDisplay() }
    }
    private var heightConstraint: NSLayoutConstraint?
    
    // Maximum length of text. 0 means no limit.
    @IBInspectable open var maxLength: Int = 0
    
    // Trim white space and newline characters when end editing. Default is true
    @IBInspectable open var trimWhiteSpaceWhenEndEditing: Bool = true
    
    // Customization
    @IBInspectable open var minHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    @IBInspectable open var maxHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    @IBInspectable open var placeholdeR: String? {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var placeholderColoR: UIColor = UIColor.themeGray {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var attributedPlaceholdeR: NSAttributedString? {
        didSet { setNeedsDisplay() }
    }
    
    // Initialize
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .redraw
        associateConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
    
    private func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height,from: https://github.com/legranddamien/MBAutoGrowingTextView
        for constraint in constraints {
            if (constraint.firstAttribute == .height) {
                if (constraint.relation == .equal) {
                    heightConstraint = constraint;
                }
            }
        }
    }
    
    // Calculate and adjust textview's height
    private var oldText: String = ""
    private var oldSize: CGSize = .zero
    
    private func forceLayoutSubviews() {
        oldSize = .zero
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private var shouldScrollAfterHeightChanged = false
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if text == oldText && bounds.size == oldSize { return }
        oldText = text
        oldSize = bounds.size
        
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        
        // Constrain minimum height
        height = minHeight > 0 ? max(height, minHeight) : height
        
        // Constrain maximum height
        height = maxHeight > 0 ? min(height, maxHeight) : height
        
        // Add height constraint if it is not found
        if (heightConstraint == nil) {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            addConstraint(heightConstraint!)
        }
        
        // Update height constraint if needed
        if height != heightConstraint!.constant {
            shouldScrollAfterHeightChanged = true
            heightConstraint!.constant = height
            if let delegate = delegate as? GrowingTextViewDelegate {
                delegate.textViewDidChangeHeight?(self, height: height)
            }
        } else if shouldScrollAfterHeightChanged {
            shouldScrollAfterHeightChanged = false
            scrollToCorrectPosition()
        }
    }
    
    private func scrollToCorrectPosition() {
        if self.isFirstResponder {
            self.scrollRangeToVisible(NSMakeRange(-1, 0)) // Scroll to bottom
        } else {
            self.scrollRangeToVisible(NSMakeRange(0, 0)) // Scroll to top
        }
    }
    
    // Show placeholder if needed
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.isEmpty {
            let xValue = textContainerInset.left + textContainer.lineFragmentPadding
            let yValue = textContainerInset.top
            let width = rect.size.width - xValue - textContainerInset.right
            let height = rect.size.height - yValue - textContainerInset.bottom
            let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)
            
            if let attributedPlaceholder = attributedPlaceholdeR {
                // Prefer to use attributedPlaceholder
                attributedPlaceholder.draw(in: placeholderRect)
            } else if let placeholder = placeholdeR {
                // Otherwise user placeholder and inherit `text` attributes
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = textAlignment
                var attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: placeholderColoR,
                    .paragraphStyle: paragraphStyle
                ]
                if let font = font {
                    attributes[.font] = font
                }
                
                placeholder.draw(in: placeholderRect, withAttributes: attributes)
            }
        }
    }
    
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if trimWhiteSpaceWhenEndEditing {
                text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                setNeedsDisplay()
            }
            scrollToCorrectPosition()
        }
    }
    
    // Limit the length of text
    @objc func textDidChange(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if maxLength > 0 && text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                text = String(text[..<endIndex])
                undoManager?.removeAllActions()
            }
            setNeedsDisplay()
        }
    }
}
