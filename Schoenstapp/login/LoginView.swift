//
//  LoginView.swift
//  Schoenstapp
//
//  Created by usuario on 02/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI
import RxSwift

struct LoginView: View {
    
    @ObservedObject var viewModel = LoginViewModel()
    @State var showLoginError = false
    @State var loginCorrect = false
    let disposables = DisposeBag()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: MenuView(), isActive: $loginCorrect) {
                    EmptyView()
                }
                TextField("Username", text: $viewModel.username)
                    .padding(.leading)
                    .padding(.trailing)
                SecureField("Password", text: $viewModel.password)
                    .padding(.leading)
                    .padding(.trailing)
                Button(action: {
                    let disposable = self.viewModel.login().subscribe(onNext: { result in
                        switch result {
                            case .CORRECT: self.loginSuccessAction()
                            case .DEFAULT_ERROR: self.loginErrorAction()
                        }
                    })
                    self.disposables.insert(disposable)
                }) {
                    Text("Log in")
                }
                NavigationLink(destination: RegisterView()) {
                    Text("Sign up!")
                }.padding(.top)
            }.alert(isPresented: $showLoginError) {
                Alert(
                    title: Text("Something went wrong"),
                    message: Text("Wrong username or password"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
    }
    
    func loginSuccessAction() {
        loginCorrect = true
    }
    
    func loginErrorAction() {
        showLoginError = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
