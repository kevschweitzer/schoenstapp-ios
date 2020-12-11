//
//  CustomFloatingMenu.swift
//  Schoenstapp
//
//  Created by usuario on 08/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI

struct FloatingMenu: View {
    @State var showButtons = false
    var onCreateClicked: () -> ()
    var onJoinClicked: () -> ()
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                if showButtons {
                    FloatingButton(text: "Join") {
                        self.onJoinClicked()
                        self.showButtons = false
                    }
                    FloatingButton(text: "Create") {
                        self.onCreateClicked()
                        self.showButtons = false
                    }
                }
                Button(action: {
                    withAnimation {
                        self.showButtons.toggle()
                    }
                }, label: {
                   Image(systemName: showButtons ? "minus" : "plus")
                     .foregroundColor(.white)
                     .font(.headline)
                })
                .padding(.all, 20)
                .background(Color.blue)
                .clipShape(Circle())
                .padding(.all, 10)
            }
        }
    
    }
}

struct FloatingButton: View {
    
    var text: String
    var onClick: () -> ()
    
    var body: some View {
        VStack {
            Text(text)
            Button(action: {
                self.onClick()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.body)
            })
            .padding(.all, 10)
            .background(Color.blue)
            .clipShape(Circle())
            .transition(.move(edge: .trailing))
        }.padding(.all, 10)

    }
}
