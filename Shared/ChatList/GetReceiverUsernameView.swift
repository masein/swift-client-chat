//
//  GetReceiverUsernameScreen.swift
//  SwiftChat
//
//  Created by Masein Modi on 1/21/22.
//
import SwiftUI

struct GetReceiverUsernameView: View {
    @Binding var isShowingGetReceiverUsernameView: Bool
    @Binding var receiverUsername: String
    @Binding var isShowingChat: Bool
    @FocusState private var focusedField: FocusField?
    var animation: Animation { Animation.easeOut }
    @State private var animationAmount = 0.0
    enum FocusField: Hashable {
        case field
    }
    
    func onAppear() {
        receiverUsername = ""
        withAnimation(.interpolatingSpring(mass: 0.7 ,stiffness: 5, damping: 1)) {
            animationAmount += 360
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.focusedField = .field
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.clear)
                .blur(radius: 20)
            VStack {
                Spacer()
                // TODO: add validation to username
                TextField("Username", text: $receiverUsername)
                    .multilineTextAlignment(.center)
                    .focused($focusedField, equals: .field)
                Spacer()
                Button {
                    isShowingGetReceiverUsernameView = false
                    print("current user name is \(receiverUsername)")
                    isShowingChat = true
                } label: {
                    Text("Start")
                }
                Spacer()
                Button {
                    isShowingGetReceiverUsernameView = false
                } label: {
                    Text("Cancel")
                }
                Spacer()
            }
            .background(Color(uiColor: .separator))
            .cornerRadius(12)
            .frame(width: 180, height: 120, alignment: .center)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
        }
        .onAppear(perform: onAppear)
    }
}
