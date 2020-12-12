//
//  ViewExtensions.swift
//  Schoenstapp
//
//  Created by usuario on 08/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import SwiftUI



extension View {
    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String,
                        buttonText: String,
                        onClick: @escaping () -> ()) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title,
                       buttonText: buttonText,
                       onClick: onClick)
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {

    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String
    let buttonText: String
    let onClick: () -> ()

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(self.isShowing)
                VStack {
                    Text(self.title)
                    TextField("Enter urn name", text: self.$text)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .id(self.isShowing)
                    Divider()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                                self.text = ""
                            }
                        }) {
                            Text("Dismiss")
                        }
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                                self.onClick()
                                self.text = ""
                            }
                        }) {
                            Text(self.buttonText)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}
