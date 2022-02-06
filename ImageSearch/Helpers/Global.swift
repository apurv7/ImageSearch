//
//  Global.swift
//  ImageSearch
//
//  Created by apurv on 06/02/2022.
//

import UIKit

//MARK: Toast Manager
internal func showToast(_ message: String?) {
    guard let msg = message else {
        return
    }
    
    DispatchQueue.main.async {
        UIApplication.shared.keyWindow?.hideToast()
        UIApplication.shared.keyWindow?.makeToast(msg)
    }
}
