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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: LoginViewModel
    @State var showLoginError = false
    let disposables = DisposeBag()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
               NavigationLink(destination: ForgotPasswordView()) {
                   Text("Forgot your password?")
               }.padding(.top)
            }
        }.alert(isPresented: $showLoginError) {
                Alert(
                    title: Text("Something went wrong"),
                    message: Text("Wrong username or password"),
                    dismissButton: .default(Text("OK"))
                )
        }
    }
    
    func loginSuccessAction() {
        viewModel.loginCorrect = true
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func loginErrorAction() {
        showLoginError = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}

extension Binding where Value == Bool {
    public func negate() -> Binding<Bool> {
        return Binding<Bool>(get:{ !self.wrappedValue },
            set: { self.wrappedValue = !$0})
    }
}
