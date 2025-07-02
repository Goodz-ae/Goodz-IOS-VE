//
//  OpenMediaVC.swift
//  Goodz
//
//  Created by Akruti on 26/02/24.
//

import Foundation
import UIKit
import AVKit
import WebKit

class OpenMediaVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var img: UIImageView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var contentURL: URL?
    var contentType: ContentType?
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    // --------------------------------------------
    // MARK: - Intial Methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func applyStyle() {
        self.img.isHidden = true
        if let contentType = contentType, let contentURL = contentURL {
            switch contentType {
            case .image:
                // Load and display image
//                let imageView = UIImageView(frame: view.bounds)
//                imageView.contentMode = .top
                self.vwMain.backgroundColor = .black
                self.img.sd_setImage(with: contentURL, placeholderImage: .product)
//                vwMain.addSubview(imageView)
                self.img.isHidden = false
            case .video:
                self.img.isHidden = true
                let player = AVPlayer(url: contentURL)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = vwMain.bounds
                vwMain.layer.addSublayer(playerLayer)
                player.play()
            case .pdf:
                self.img.isHidden = true
                let webView = WKWebView(frame: vwMain.bounds)
                if let url = contentURL as URL? {
                    let request = URLRequest(url: url)
                    webView.load(request)
                    vwMain.addSubview(webView)
                } else {
                    print("Invalid URL for PDF")
                }
            }
        } else {
            // Handle case where contentURL or contentType is missing
            print("Missing content URL or content type")
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = ""
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    @objc func toggleControls() {
        // Toggle controls visibility
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
}
