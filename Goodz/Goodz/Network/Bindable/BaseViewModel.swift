//
//  BaseViewModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import Foundation

class BaseViewModel : NSObject {
    var showHUD: Bindable<Bool>                    = Bindable(false)
    var showAlert: Bindable<(String?, SelectPosition, AlertType)> = Bindable((nil, .top, .success))
    var success: Bindable<Bool>                    = Bindable(false)
}

enum SelectPosition {
    case top
    case bottom
}

enum AlertType {
    case success
    case warning
    case failure
}
