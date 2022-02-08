//
//  ChatViewModel.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/19/22.
//
import Foundation
import Combine

class ChatViewModel: ObservableObject {
    private var username: String?
    private var userID: UUID?
    @Published var currentReceiver: String = ""
    @Published var messages: [Message] = []
    @Published var activeChat: Message? = Message(id: UUID(), messages: [])
    @Published var isShowingGetReceiverUsernameView: Bool = false
    @Published var isShowingChat: Bool = false
    private var webSocketTask: URLSessionWebSocketTask?

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
                  let chatMessages = try? JSONDecoder().decode(ReceivingChatMessage.self, from: data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.activeChat?.messages.append(chatMessages)
            }
        }
    }
    
    func send(text: String) {
        guard let username = username, let userID = userID else {
            return
        }
        let message = SubmittedChatMessage(message: text, sender: username, senderID: userID, receiver: currentReceiver)
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
    
    func updateActiveChat() {
        guard let activeChat = activeChat else {
            return
        }
        do {
            try StorageManager.update(activeChat)
        } catch {
            assertionFailure("Error on updating your chat data in phone storage")
        }
    }
    
    func getActiveChat() {
        for message in messages
        where message.messages[0].sender == currentReceiver || message.messages[0].receiver == currentReceiver {
            activeChat = message
            print("We had a chat with user \(currentReceiver)")
            print("Active chat is: \(String(describing: activeChat))")
            return
        }
        activeChat = Message(id: UUID(),
                             messages: [])
        print("Active chat is: \(String(describing: activeChat))")
    }
    
    func setCurrentReceiver(from chatItem: Message) {
        if let receiver = getReceiver(from: chatItem) {
            currentReceiver = receiver
        }
        print("Current receiver is: \(currentReceiver)")
    }
    
    func getReceiver(from chatItem: Message) -> String? {
        for message in chatItem.messages where message.receiver != username {
            print("receiver of chat item: \(chatItem) is: \(message.receiver)")
            return message.receiver
        }
        return nil
    }
    
    deinit {
        disconnect()
    }
}
