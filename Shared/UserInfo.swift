//
//  UserInfo.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/9/22.
//
import Combine
import Foundation

class UserInfo: ObservableObject {
    let userID = UUID()
    @Published var username = ""
}
