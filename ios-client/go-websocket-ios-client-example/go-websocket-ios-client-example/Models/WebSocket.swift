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
