//
//  Models.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/8/22.
//
import Foundation

struct SubmittedChatMessage: Encodable {
    let message: String
    let sender: String
    let senderID: UUID
    let receiver: String
}
struct ReceivingChatMessage: Codable, Identifiable {
    let date: Date
    let id: UUID
    let message: String
    let sender: String
    let senderID: UUID
    let receiver: String
}
struct Message: Identifiable, Codable {
    let id : UUID
    var messages: [ReceivingChatMessage]
}
struct User: Identifiable, Codable {
    var id: UUID
    var username: String
}
