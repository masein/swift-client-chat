//
//  ChatScreenModel.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/5/22.
//
import Combine
import Foundation

final class ChatScreenModel: ObservableObject {
    private var username: String?
    private var userID: UUID?
    @Published private(set) var messages: [ReceivingChatMessage] = []
    private var webSocketTask: URLSessionWebSocketTask?
    // MARK: - Connection
    func connect(username: String, userID: UUID) {
        self.username = username
        self.userID = userID
        let url = URL(string: "ws://127.0.0.1:8080/chat")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }

    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive)
        if case .success(let message) = incoming {
            onMessage(message: message)
        }
        else if case .failure(let error) = incoming {
            print("Error", error)
        }
    }

    private func onMessage(message: URLSessionWebSocketTask.Message) {
        if case .string(let text) = message {
            guard let data = text.data(using: .utf8),
                  let chatMessage = try? JSONDecoder().decode(ReceivingChatMessage.self, from: data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.messages.append(chatMessage)
            }
        }
    }
    
    func send(text: String) {
        guard let username = username, let userID = userID else {
                return
            }
            
        let message = SubmittedChatMessage(message: text, user: username, userID: userID)
        guard let json = try? JSONEncoder().encode(message),
            let jsonString = String(data: json, encoding: .utf8)
        else {
            return
        }
        webSocketTask?.send(.string(jsonString)) { error in
            if let error = error {
                print("Error sending message", error)
            }
        }
    }
    
    deinit {
        disconnect()
    }
}
