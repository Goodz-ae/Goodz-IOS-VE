//
//  ToastExtension.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

 import UIKit

 extension UIViewController {

    func showToast(message: String, font: UIFont) {
        let size = message.sizeOfString(usingFont: font)
        
        var y: CGFloat = 100
        
//        if isNotched() {
//            y = 138
//        }
        
        let toastLabel = UILabel(frame: .zero)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = (size.height + 4) / 2
        toastLabel.clipsToBounds  =  false
        toastLabel.numberOfLines = 0
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toastLabel)
        self.view.bringSubviewToFront(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -y),
            toastLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40)
        ])
        
        let frameView = UIView(frame: .zero)
        frameView.translatesAutoresizingMaskIntoConstraints = false
        frameView.backgroundColor = UIColor.themeBlack.withAlphaComponent(0.7)
        frameView.alpha = 0
        self.view.addSubview(frameView)
        self.view.bringSubviewToFront(frameView)
        self.view.bringSubviewToFront(toastLabel)
        
        NSLayoutConstraint.activate([
            frameView.bottomAnchor.constraint(equalTo: toastLabel.bottomAnchor, constant: 8),
            frameView.topAnchor.constraint(equalTo: toastLabel.topAnchor, constant: -8),
            frameView.leadingAnchor.constraint(equalTo: toastLabel.leadingAnchor, constant: -15),
            frameView.trailingAnchor.constraint(equalTo: toastLabel.trailingAnchor, constant: 15)
        ])
        
        frameView.clipsToBounds = true
        frameView.layer.cornerRadius = 12
        
        let scaleUp = CGAffineTransform(scaleX: 1, y: 1)
        let scaleDown = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        frameView.transform = scaleDown
        toastLabel.transform = scaleDown
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            toastLabel.alpha = 1
            frameView.alpha = 1
            frameView.transform = scaleUp
            toastLabel.transform = scaleUp
        }, completion: {(_) in
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                toastLabel.alpha = 0.0
                frameView.alpha = 0.0
                frameView.transform = scaleDown
                toastLabel.transform = scaleDown
            }, completion: {(_) in
                toastLabel.removeFromSuperview()
                frameView.removeFromSuperview()
            })
        }
    }
     
     func showTopToast(message: String, font: UIFont) {
         let toastLabel = UILabel(frame: .zero)
         toastLabel.textColor = UIColor.themeBlack
         toastLabel.font = font
         toastLabel.textAlignment = .center
         toastLabel.text = message
         toastLabel.alpha = 0
         toastLabel.numberOfLines = 0
         toastLabel.translatesAutoresizingMaskIntoConstraints = false
         self.view.addSubview(toastLabel)
         self.view.bringSubviewToFront(toastLabel)
         
         let frameView = UIView(frame: .zero)
         frameView.translatesAutoresizingMaskIntoConstraints = false
         frameView.backgroundColor = UIColor.themeLightRed.withAlphaComponent(0.8)
         frameView.alpha = 0
         self.view.addSubview(frameView)
         self.view.bringSubviewToFront(frameView)
         self.view.bringSubviewToFront(toastLabel)
         
         NSLayoutConstraint.activate([
             frameView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
                    frameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                    frameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                    frameView.bottomAnchor.constraint(equalTo: toastLabel.bottomAnchor, constant: 10), // Adjust the bottom constraint here
                    
             toastLabel.centerXAnchor.constraint(equalTo: frameView.centerXAnchor),
             toastLabel.topAnchor.constraint(equalTo: frameView.topAnchor, constant: 10), // Adjust the top constraint here
             toastLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 10), // Adjust the leading constraint here
             toastLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -10) // Adjust the trailing constraint here
         ])
         
         frameView.clipsToBounds = true
         
         UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
             toastLabel.alpha = 1
             frameView.alpha = 1
         }, completion: {(_) in
         })
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                 toastLabel.alpha = 0.0
                 frameView.alpha = 0.0
             }, completion: {(_) in
                 toastLabel.removeFromSuperview()
                 frameView.removeFromSuperview()
             })
         }
     }
    
 }
extension UIViewController : NVActivityIndicatorViewable {
    
    func startLoaderwithMsg(message : String) {
        startAnimating(CGSize(width: 50, height: 50), message: message, type: .ballPulse, color: UIColor.lightGray,  backgroundColor: UIColor.clear, fadeInAnimation: nil)
    }
 
    func startLoader() {
        startAnimating(CGSize(width: 50, height: 50), message: "", type: .ballPulse , color: .themeDarkGreen.withAlphaComponent(0.5),  backgroundColor: UIColor.clear, fadeInAnimation: nil)
    }
 
    func stopLoader() {
        self.stopAnimating(nil)
    }
    
}
