//
//  Animations.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

/// `Double Tap Heart Animation`
public func showHeartAnimation(view: UIView, at position: CGPoint) {
    // Create a new instance of HeartView
    let heartView = UIImageView(frame: CGRect(x: -25, y: 0, width: 50, height: 50))
    heartView.image = .icHeartFill
    heartView.center = position
    
    // Add the HeartView as a subview
    view.addSubview(heartView)
    
    // Animate the HeartView (e.g., fade out)
    UIView.animate(withDuration: 1.0, animations: {
        heartView.alpha = 0.0
    }, completion: { _ in
        // Remove the HeartView from the superview
        heartView.removeFromSuperview()
    })
}
