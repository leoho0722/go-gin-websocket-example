//
//  WebSocket.swift
//  go-websocket-ios-client-example
//
//  Created by Leo Ho on 2023/11/17.
//

import Foundation

struct WebSocketMessage: Codable {
    
    let data: String
}

struct WebSocketResponse: Decodable {
    
    let message: String
}

/// 連接 WebSocket 的配置檔結構
struct WebSocketConnectionConfig {
    
    let scheme: WebSocketScheme
    
    let host: String
    
    let port: Int
    
    let path: String
    
    enum WebSocketScheme: String {
        
        case ws = "ws://"
         
        case wss = "wss://"
    }
    
    func url() -> URL? {
        return URL(string: scheme.rawValue + host + ":" + "\(port)" + path)
    }
}

enum WebSocketError: Error {
    
    /// 無效的 WebSocket URL
    case invalidURL
    
    /// 無法連接到 WebSocket
    case cantConnectToServer
    
    /// 重複連接 WebSocket
    case duplicateConnect
    
    /// 向 WebSocket 發送訊息失敗
    /// - Parameters:
    ///   - error: 發送訊息失敗的錯誤
    case sendFailed(Error)
    
    /// 向 WebSocket 接收訊息失敗
    /// - Parameters:
    ///   - error: 接收訊息失敗的錯誤
    case receiveFailed(Error)
}

enum WebSocketConnectState {
    
    /// 已連接上 WebSocket
    case connect
    
    /// 與 WebSocket 間已斷線
    case disconnect
}
