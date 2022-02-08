//
//  ChatRow.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/19/22.
//
import SwiftUI

struct ChatRow: View {
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    let chat: Message
    let receiver: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(receiver)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                    
                    Text(Self.dateFormatter.string(from: chat.messages.last?.date ?? Date(timeIntervalSince1970: 0)))
                        .font(.system(size: 10))
                        .opacity(0.7)
                }
                
                Text(chat.messages.last?.message ?? "No text")
            }
            .foregroundColor(.black)
            .padding(10)
            .background(Color(white: 0.95))
            .cornerRadius(5)
        }
    }
}
