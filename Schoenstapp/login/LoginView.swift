//
//  LoginView.swift
//  Schoenstapp
//
//  Created by usuario on 29/11/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding(.leading)
                .padding(.trailing)
            SecureField("Password", text: $viewModel.password)
                .padding(.leading)
                .padding(.trailing)
            Button(action: {
                self.viewModel.registerNewUser().subscribe(onNext: { n in
                    print(n)
                })
            }) {
                Text("Sign up")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
