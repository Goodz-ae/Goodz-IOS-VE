//
//  SegmentExtension.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

 import UIKit

extension UISegmentedControl {
    func removeBorder() {
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
    }

    func addUnderlineForSelectedSegment() {
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage {

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}

/*
// MARK: Segment underline
extension UISegmentedControl {
  
     func removeBorder() {

         self.tintColor = UIColor.clear
         self.backgroundColor = UIColor.clear
         self.setTitleTextAttributes( [
             NSAttributedString.Key.foregroundColor : UIColor.themeBlack,
             NSAttributedString.Key.font : UIFont(name: FontName.semibold.rawValue, size: 16) ?? .boldSystemFont(ofSize: 16) ], for: .selected)
         self.setTitleTextAttributes( [
             NSAttributedString.Key.foregroundColor : UIColor.themeGray,
             NSAttributedString.Key.font : UIFont(name: FontName.semibold.rawValue, size: 16) ?? .boldSystemFont(ofSize: 16)], for: .normal)
  
     }
  
     func setupSegment() {
         self.removeBorder()
         let segmentUnderlineWidth: CGFloat = self.bounds.width
         let segmentUnderlineHeight: CGFloat = 4.0
         let segmentUnderlineXPosition = self.bounds.minX
         let segmentUnderLineYPosition = self.bounds.size.height - 18
         let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
         let segmentUnderline = UIView(frame: segmentUnderlineFrame)
  
         segmentUnderline.backgroundColor = .themeGray
         segmentUnderline.cornerRadius = 2
         self.addSubview(segmentUnderline)
         self.addUnderlineForSelectedSegment()
  
     }
  
     func addUnderlineForSelectedSegment() {
  
         let underlineWidth: CGFloat = (self.bounds.size.width / CGFloat(self.numberOfSegments))/2
         let underlineHeight: CGFloat = 4.0
         let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth * 2)) + 55
         let underLineYPosition = self.bounds.size.height - 18
         let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth - 30, height: underlineHeight)
         let underline = UIView(frame: underlineFrame)
         underline.backgroundColor = .themeBlack
         underline.cornerRadius = 2
         underline.tag = 1
         self.addSubview(underline)
     }
  
     func changeUnderlinePosition() {
         guard let underline = self.viewWithTag(1) else {return}
         let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
         underline.frame.origin.x = underlineFinalXPosition
  
     }
}
*/
