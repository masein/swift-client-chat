//
//  SettingsScreen.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/10/22.
//
import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var userInfo: UserInfo
    private var isUsernameValid: Bool {
        !userInfo.username.trimmingCharacters(in: .whitespaces).isEmpty
    }
    private func onDisappear() {
        do {
            guard let user = try StorageManager.retrieveUser() else {
                // create new
                try StorageManager.store(user: User(id: userInfo.userID,
                                                username: userInfo.username))
                return
            }
            if user.username == userInfo.username {
                // update UUID
                try StorageManager.store(user: User(id: userInfo.userID,
                                                username: userInfo.username))
            } else {
                try StorageManager.store(user: User(id: userInfo.userID,
                                                username: userInfo.username))
                try StorageManager.deleteMessages()
            }
        } catch {
            assertionFailure("Error on working with local storage")
        }
    }
    
    
    var body: some View {
        Form {
            Section(header: Text("Username")) {
                TextField("E.g. John Applesheed", text: $userInfo.username)
                NavigationLink("Continue", destination: ChatsScreen())
                    .disabled(!isUsernameValid)
            }
        }
        .navigationTitle("Settings")
        .onDisappear(perform: onDisappear)
    }
}
