//
//  Alert.swift
//  go-websocket-ios-client-example
//
//  Created by Leo Ho on 2023/11/17.
//

import UIKit

@MainActor final class Alert {
    
    /// 根據 ``AlertConfig`` 來顯示 Alert
    /// - Parameters:
    ///   - vc: 要顯示 Alert 的畫面
    ///   - config: Alert 的顯示資訊設定
    class func showAlertWith(vc: UIViewController, config: AlertConfig) {
        var alertC: UIAlertController!
        
        switch config {
        case .confirm(let title, let message, let confirmTitle, let confirm):
            alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirm)
            alertC.addAction(confirmAction)
        case .confirmNcancel(let title, let message, let confirmTitle, let cancelTitle, let confirm, let cancel):
            alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirm)
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancel)
            alertC.addAction(confirmAction)
            alertC.addAction(cancelAction)
        }
        
        vc.present(alertC, animated: true)
    }
}

extension Alert {
    
    enum AlertConfig {
        
        /// 單一按鈕的 Alert
        /// - Parameters:
        ///   - title: Alert 的標題
        ///   - message: Alert 的訊息
        ///   - confirmTitle: Alert 的確認按鈕標題
        ///   - confirm: Alert 的確認按鈕按下去後要做的事
        case confirm(title: String,
                     message: String,
                     confirmTitle: String,
                     confirm: ((UIAlertAction) -> Void)? = nil)
        
        /// 具有確認、取消按鈕的 Alert
        /// - Parameters:
        ///   - title: Alert 的標題
        ///   - message: Alert 的訊息
        ///   - confirmTitle: Alert 的確認按鈕標題
        ///   - cancelTitle: Alert 的取消按鈕標題
        ///   - confirm: Alert 的確認按鈕按下去後要做的事
        ///   - cancel: Alert 的取消按鈕按下去後要做的事
        case confirmNcancel(title: String,
                            message: String,
                            confirmTitle: String,
                            cancelTitle: String,
                            confirm: ((UIAlertAction) -> Void)? = nil,
                            cancel: ((UIAlertAction) -> Void)? = nil)
    }
}
