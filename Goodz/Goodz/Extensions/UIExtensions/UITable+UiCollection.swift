//
//  UITable+UiCollection.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import Foundation
import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}

extension UITableView {
    func dequeueReusableCell<T: Reusable>(indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeHeaderAsACell<T: Reusable>() -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    }
    
}

extension UICollectionView {
    
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UITableView {

    func setMessage(_ message: String, strImg : UIImage) {
        /*let lblMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        lblMessage.text = message
        lblMessage.textColor = .black
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .center
        lblMessage.font(font: .semibold, size: .size18)
        lblMessage.sizeToFit()
        lblMessage.backgroundColor = .red
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 104, height: 104))
        img.contentMode = .scaleAspectFill
        img.image = strImg
        img.backgroundColor = .themeGray
        
        let btn = ThemeGreenButton(frame: CGRect(x: 10, y: 0, width: 100, height: 20))
        btn.setTitle("hello", for: .normal)
        
        img.addSubview(btn)
        lblMessage.addSubview(img)
        self.backgroundView = lblMessage
        self.separatorStyle = .none*/
        
        // Image View
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        imageView.image = strImg

        // Text Label
        let textLabel = UILabel()
        textLabel.backgroundColor = UIColor.yellow
        textLabel.widthAnchor.constraint(equalToConstant: self.bounds.size.width).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        textLabel.text  = "Hi World"
        textLabel.textAlignment = .center
        
        let btn = UIButton()
        btn.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        btn.setTitle("hello", for: .normal)
        btn.backgroundColor = .systemPink

        // Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalCentering
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(btn)
        stackView.translatesAutoresizingMaskIntoConstraints = true

        self.backgroundView = stackView 

    }

    func clearBackground() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
