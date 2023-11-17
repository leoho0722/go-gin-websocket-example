//
//  MainViewController.swift
//  go-websocket-ios-client-example
//
//  Created by Leo Ho on 2023/11/16.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var txfMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var txvLog: UITextView!
    
    // MARK: - Properties
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        WebSocketManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        setupButton()
        setupTextField()
        setupTextView()
    }
    
    fileprivate func setupButton(isConnect: Bool = false) {
        btnSend.setTitle(isConnect ? "Send" : "Connect", for: .normal)
        btnClose.setTitle("Close", for: .normal)
    }
    
    fileprivate func setupTextField(isConnect: Bool = false) {
        txfMessage.isEnabled = isConnect
    }
    
    fileprivate func setupTextView() {
        txvLog.isEditable = false
    }
    
    // MARK: - Function
    
    
    
    // MARK: - IBAction
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        do {
            if WebSocketManager.shared.isConnect {
                Task {
                    guard let txt = txfMessage.text, !txt.isEmpty else {
                        return
                    }
                    let message = WebSocketMessage(data: txt)
                    try await WebSocketManager.shared.send(data: message)
                    Alert.showAlertWith(vc: self, config: .confirmNcancel(title: "Send",
                                                                          message: "Success",
                                                                          confirmTitle: "Confirm",
                                                                          cancelTitle: "Cancel"))
                }
            } else {
                let config = WebSocketConnectionConfig(scheme: .ws,
                                                       host: "192.168.23.56",
                                                       port: 8080,
                                                       path: "/ws")
                try WebSocketManager.shared.connect(config: config)
            }
        } catch {
            Alert.showAlertWith(vc: self, config: .confirm(title: "Error",
                                                           message: error.localizedDescription,
                                                           confirmTitle: "Confirm"))
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        if WebSocketManager.shared.isConnect {
            WebSocketManager.shared.cancel()
        }
    }
}

// MARK: - Extensions

extension MainViewController: WebSocketManagerDelegate {
    
    func websocket(_ manager: WebSocketManager, connectState state: WebSocketConnectState) {
        switch state {
        case .connect:
            setupButton(isConnect: true)
            setupTextField(isConnect: true)
        case .disconnect:
            setupButton(isConnect: false)
            setupTextField(isConnect: false)
        }
    }
    
    func websocket(_ manager: WebSocketManager, didReceive response: WebSocketResponse) {
        DispatchQueue.main.async {
            let log = response.message
            self.txvLog.text += "\(log)\n"
        }
    }
}

// MARK: - Protocol



// MARK: - Previews

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}

