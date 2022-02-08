//
//  StorageManager.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/24/22.
//
import SwiftUI

class StorageManager {
    // MARK: messages
    static func store(messages: [Message]) throws {
        @AppStorage("messages") var messagesData: Data?
        do {
            let data = try JSONEncoder().encode(messages)
            messagesData = data
        } catch {
            throw SCError.unableToStore
        }
    }
    static func delete(at offset: Int) throws {
        var messages = try StorageManager.retrieveMessages()
        messages.remove(at: offset)
        try StorageManager.store(messages: messages)
    }
    static func deleteMessages() throws {
        @AppStorage("messages") var messagesData: Data?
        let messages: [Message] = []
        do {
            let data = try JSONEncoder().encode(messages)
            messagesData = data
        } catch {
            throw SCError.unableToStore
        }
    }
    static func add(_ message: Message) throws {
        var messages = try StorageManager.retrieveMessages()
        messages.append(message)
        try StorageManager.store(messages: messages)
    }
    static func update(_ message: Message) throws {
        let messages = try StorageManager.retrieveMessages()
        for i in 0..<messages.count where messages[i].id == message.id {
            try delete(at: i)
            try add(message)
            return
        }
        try add(message)
    }
    static func retrieveMessages() throws -> [Message] {
        @AppStorage("messages") var messagesData: Data?
        guard let messagesData = messagesData else { return Array<Message>() }
        do {
            return try JSONDecoder().decode([Message].self, from: messagesData)
        } catch {
            throw SCError.unableToRetrieve
        }
    }
    // MARK: user info
    static func store(user: User) throws {
        @AppStorage("user") var userData: Data?
        do {
            let data = try JSONEncoder().encode(user)
            userData = data
        } catch {
            throw SCError.unableToStore
        }
    }
    static func retrieveUser() throws -> User? {
        @AppStorage("user") var userData: Data?
        guard let userData = userData else { return nil }
        do {
            return try JSONDecoder().decode(User.self, from: userData)
        } catch {
            throw SCError.unableToRetrieve
        }
    }
}
