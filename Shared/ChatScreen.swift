//
//  ChatScreen.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/5/22.
//
import SwiftUI

struct ChatScreen: View {
    @EnvironmentObject private var userInfo: UserInfo
    @StateObject private var model = ChatScreenModel()
    @State private var message = ""
    
    private func onAppear() {
        model.connect(username: userInfo.username, userID: userInfo.userID)
    }
    
    private func onDisappear() {
        model.disconnect()
    }
    
    private func onCommit() {
        if !message.isEmpty {
            model.send(text: message)
            message = ""
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = model.messages.last {
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    var body: some View {
        VStack {
            // Chat history.
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 8) {
                        ForEach(model.messages) { message in
                            ChatMessageRow(message: message,
                                           isUser: message.userID == userInfo.userID)
                                .id(message.id)
                            
                        }
                    }
                    .onChange(of: model.messages.count) { _ in
                        scrollToLastMessage(proxy: proxy)
                    }
                }
            }
            // Message field.
            HStack {
                TextField("Message", text: $message, onEditingChanged: { _ in }, onCommit: onCommit)
                    .padding(10)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(5)
                
                Button(action: onCommit) {
                    Image(systemName: "arrowshape.turn.up.right")
                        .font(.system(size: 20))
                }
                .padding()
                .disabled(message.isEmpty)
            }
            .padding()
        }
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}
