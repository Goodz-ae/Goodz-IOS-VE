//
//  AppProtocol.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit

/// Protocol for nested collection view screen redirection
protocol ProductViewCellDelegate: AnyObject {
    func didSelectItemInCell(at indexPath: IndexPath)
}
