//
//  ContentView.swift
//  Shared
//
//  Created by Masein Modi on 1/5/22.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var userInfo = UserInfo()
    
    var body: some View {
        NavigationView {
            SettingsScreen()
        }
        .environmentObject(userInfo)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
