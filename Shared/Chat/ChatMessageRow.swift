//
//  ChatMessageRow.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/10/22.
//
import SwiftUI

struct ChatMessageRow: View {
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    let message: ReceivingChatMessage
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser {
                Spacer()
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(message.sender)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                    
                    Text(Self.dateFormatter.string(from: message.date))
                        .font(.system(size: 10))
                        .opacity(0.7)
                }
                
                Text(message.message)
            }
            .foregroundColor(isUser ? .white : .black)
            .padding(10)
            .background(isUser ? Color.blue : Color(white: 0.95))
            .cornerRadius(5)
            if !isUser {
                Spacer()
            }
        }
    }
}
