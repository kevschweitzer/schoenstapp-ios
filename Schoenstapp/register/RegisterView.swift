//
//  LoginView.swift
//  Schoenstapp
//
//  Created by usuario on 29/11/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI
import RxSwift

enum ActiveAlert { case success, error }

struct RegisterView: View {
    
    @ObservedObject var viewModel = RegisterViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingAlert = false
    @State private var activeAlert: ActiveAlert = .success
    @State private var registerCorrect = false
    let disposables = DisposeBag()
    
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
                    let disposable = self.viewModel.registerNewUser().subscribe(onNext: { result in
                        switch result {
                            case .CORRECT: self.registerSuccessAction()
                            case .DEFAULT_ERROR: self.registerErrorAction()
                        }
                    })
                    self.disposables.insert(disposable)
                }) {
                    Text("Sign up")
                }
            }
            .alert(isPresented: $showingAlert) {
                switch activeAlert {
                    case .error: return Alert(
                        title: Text("Something went wrong"),
                        message: Text("We couldn't create your account, please try again later."),
                        dismissButton: .default(Text("OK"))
                    )
                    case .success: return Alert(
                        title: Text("Congratulations!"),
                        message: Text("Your account have been created. Please verify your email inbox to validate"),
                        dismissButton: .default(Text("OK"), action: {
                            self.goToLogin()
                        })
                    )
                }
            }
        }
    }
    
    func registerSuccessAction() {
        self.activeAlert = .success
        self.showingAlert = true
    }
    
    func registerErrorAction(){
        self.activeAlert = .error
        self.showingAlert = true
    }
    
    func goToLogin() {
        self.viewModel.clear()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
