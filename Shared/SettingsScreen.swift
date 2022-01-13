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
    
    var body: some View {
        Form {
            Section(header: Text("Username")) {
                TextField("E.g. John Applesheed", text: $userInfo.username)
                NavigationLink("Continue", destination: ChatScreen())
                    .disabled(!isUsernameValid)
            }
        }
        .navigationTitle("Settings")
    }
}
