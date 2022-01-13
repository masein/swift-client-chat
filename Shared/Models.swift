//
//  Models.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/8/22.
//
import Foundation

struct SubmittedChatMessage: Encodable {
    let message: String
    let user: String
    let userID: UUID
}
struct ReceivingChatMessage: Decodable, Identifiable {
    let date: Date
    let id: UUID
    let message: String
    let user: String
    let userID: UUID
}
