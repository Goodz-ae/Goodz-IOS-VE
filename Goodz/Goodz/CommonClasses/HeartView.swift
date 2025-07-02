//
//  HeartView.swift
//  Goodz
//
//  Created by Priyanka Poojara on 12/12/23.
//

import UIKit

class HeartView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        // Draw your heart shape here
        // For simplicity, I'm using a simple heart shape
        bezierPath.move(to: CGPoint(x: rect.size.width / 2, y: rect.size.height / 5))
        bezierPath.addCurve(to: CGPoint(x: rect.size.width / 4, y: 0),
                            controlPoint1: CGPoint(x: rect.size.width / 2, y: 0),
                            controlPoint2: CGPoint(x: rect.size.width / 4, y: 0))
        bezierPath.addArc(withCenter: CGPoint(x: rect.size.width / 4, y: rect.size.height / 5),
                          radius: rect.size.width / 4,
                          startAngle: CGFloat.pi,
                          endAngle: 0,
                          clockwise: true)
        bezierPath.addArc(withCenter: CGPoint(x: rect.size.width * 3 / 4, y: rect.size.height / 5),
                          radius: rect.size.width / 4,
                          startAngle: CGFloat.pi,
                          endAngle: 0,
                          clockwise: true)
        bezierPath.addCurve(to: CGPoint(x: rect.size.width / 2, y: rect.size.height / 5),
                            controlPoint1: CGPoint(x: rect.size.width * 3 / 4, y: 0),
                            controlPoint2: CGPoint(x: rect.size.width / 2, y: 0))
        bezierPath.close()

        UIColor.red.setFill()
        bezierPath.fill()
    }
}
