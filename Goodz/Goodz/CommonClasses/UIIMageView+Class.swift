//
//  UIIMageView+Class.swift
//  Goodz
//
//  Created by Akruti on 05/12/23.
//

import Foundation
import UIKit

class ThemeGreenBorderImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    func applyStyle() {
        DispatchQueue.main.async {
            self.cornerRadius(cornerRadius: self.frame.height / 2)
            self.border(borderWidth: 2, borderColor: .themeGreenProfile)
            self.contentMode = .scaleToFill
        }
    }
}
extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { 
//                DispatchQueue.main.async() { [weak self] in
//                    self?.image = .product
//                }
//                return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
}
