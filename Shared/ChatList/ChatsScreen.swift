//
//  ChatsScreen.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/19/22.
//
import SwiftUI

struct ChatsScreen: View {
    @EnvironmentObject private var userInfo: UserInfo
    @ObservedObject var viewModel = ChatViewModel()
    
    private func onAppear() {
        viewModel.connect(username: userInfo.username, userID: userInfo.userID)
        retrieveChatsFromStorage()
    }
    
    private func retrieveChatsFromStorage() {
        do {
            let messages = try StorageManager.retrieveMessages()
            viewModel.messages = messages.reversed()
        } catch {
            assertionFailure("Couldn't retrieve messages")
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.isShowingGetReceiverUsernameView {
                GetReceiverUsernameView(
                    isShowingGetReceiverUsernameView: $viewModel.isShowingGetReceiverUsernameView,
                    receiverUsername: $viewModel.currentReceiver,
                    isShowingChat: $viewModel.isShowingChat)
            } else {
                List(viewModel.messages) { message in
                    NavigationLink(destination: ChatScreen(viewModel: viewModel)) {
                        ChatRow(chat: message,
                                receiver: viewModel.getReceiver(from: message) ?? "No name")
                            .onTapGesture {
                                viewModel.setCurrentReceiver(from: message)
                                viewModel.getActiveChat()
                            }
                    }
                }
            }
        }
        .navigationTitle("Chats")
        .navigationBarItems(trailing:
                                Button(action: {
            viewModel.isShowingGetReceiverUsernameView = true
        }) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
        }.sheet(isPresented: $viewModel.isShowingChat,
                content: {
            ChatScreen(viewModel: viewModel)
        })
        )
        .onAppear(perform: onAppear)
    }
}
