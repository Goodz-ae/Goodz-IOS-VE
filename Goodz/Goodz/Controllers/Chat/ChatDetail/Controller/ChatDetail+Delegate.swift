//
//  ChatDetail+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit
import AVKit

extension ChatDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data  = self.viewModel.setChatRow(row: indexPath.row)
        if (data.messageType == Status.two.rawValue) || (data.messageType == Status.four.rawValue) {
            
            var type : ContentType = .image
            if (data.messageType == Status.two.rawValue) {
                type = .image
            } else if (data.messageType == Status.three.rawValue) {
                type = .video
            } else if (data.messageType == Status.four.rawValue) {
                type = .pdf
            } else {}
            if let madia = data.messageURL, let url = URL(string: madia) {
                self.coordinator?.navigateToOpenMedia(type: type, url: url)
            }
        } else if (data.messageType == Status.three.rawValue) {
            if let madia = data.messageURL, let url = URL(string: madia) {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
