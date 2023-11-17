//
//  WebSocketManager.swift
//  go-websocket-ios-client-example
//
//  Created by Leo Ho on 2023/11/16.
//

import Foundation

import SwiftHelpers

protocol WebSocketManagerDelegate: NSObjectProtocol {
    
    func websocket(_ manager: WebSocketManager, connectState state: WebSocketConnectState)
    
    func websocket(_ manager: WebSocketManager, didReceive message: WebSocketResponse)
}

final class WebSocketManager: NSObject {
    
    static let shared = WebSocketManager()
    
    var isConnect: Bool = false
    
    weak var delegate: WebSocketManagerDelegate?
    
    private var websocketTask: URLSessionWebSocketTask!
    
    /// 與 WebSocket 進行連接
    /// - Parameters:
    ///   - config: 連接 WebSocket 的配置檔結構
    func connect(config: WebSocketConnectionConfig) throws {
        guard !isConnect else {
            print("目前已連線上 WebSocket")
            throw WebSocketError.duplicateConnect
        }
        guard let url = config.url() else {
            throw WebSocketError.invalidURL
        }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let request = URLRequest(url: url)
        websocketTask = session.webSocketTask(with: request)
        websocketTask.resume()
    }
    
    /// 與 WebSocket 進行斷線
    func cancel() {
        websocketTask.cancel(with: .normalClosure, reason: nil)
        delegate?.websocket(self, connectState: .disconnect)
        isConnect = false
    }
    
    /// 發送訊息給 WebSocket
    /// - Parameters:
    ///   - data: 要傳給 WebSocket 的資料
    func send(data: Encodable) async throws {
        guard isConnect else {
            throw WebSocketError.cantConnectToServer
        }
        do {
            let message = try JSON.toJsonData(data: data)
            try await websocketTask.send(.data(message))
            try await receive()
        } catch {
            throw WebSocketError.sendFailed(error)
        }
    }
    
    /// 接收 WebSocket 的訊息
    func receive() async throws {
        do {
            let message = try await websocketTask.receive()
            switch message {
            case .data(let data):
                let result = try JSONDecoder().decode(WebSocketResponse.self, from: data)
                delegate?.websocket(self, didReceive: result)
            case .string(let string):
                guard let data = string.data(using: .utf8) else {
                    return
                }
                let result = try JSONDecoder().decode(WebSocketResponse.self, from: data)
                delegate?.websocket(self, didReceive: result)
            @unknown default:
                fatalError("Unknown Type of URLSessionWebSocketTask.Message")
            }
        } catch {
            throw WebSocketError.receiveFailed(error)
        }
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketManager: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        print("WebSocket is connected!")
        delegate?.websocket(self, connectState: .connect)
        isConnect = true
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        if let reason,
           let status = String(data: reason, encoding: .utf8) {
            print(status)
        } else {
            print("Server didn't send close reason")
        }
    }
}
