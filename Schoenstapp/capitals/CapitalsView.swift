//
//  CapitalsView.swift
//  Schoenstapp
//
//  Created by usuario on 07/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI

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

struct FloatingMenu: View {
    @State var showButtons = false
    @State var showCreateAlert = false
    @State var showJoinAlert = false
    @State var alertText = ""
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                if showButtons {
                    FloatingButton(text: "Join") {
                        self.showJoinAlert = true
                    }
                    FloatingButton(text: "Create") {
                        self.showCreateAlert = true
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
                     .frame(width: 60, height: 60)
                })
                .background(Color.blue)
                .clipShape(Circle())
                .padding(.all, 10)
            }
        }
        .textFieldAlert(
            isShowing: $showCreateAlert,
            text: $alertText,
            title: "Create Urn",
            buttonText: "Create") {
                print(self.alertText)
            }
        .textFieldAlert(
            isShowing: $showJoinAlert,
            text: $alertText,
            title: "Join Urn",
            buttonText: "Join") {
                print(self.alertText)
            }
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

struct CapitalsView: View {
    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            Text("Hello, World!")
            FloatingMenu()
        }
    }
}

struct CapitalsView_Previews: PreviewProvider {
    static var previews: some View {
        CapitalsView()
    }
}
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
