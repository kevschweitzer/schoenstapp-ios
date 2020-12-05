//
//  ForgotPasswordView.swift
//  Schoenstapp
//
//  Created by usuario on 05/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI
import RxSwift

struct ForgotPasswordView: View {
    
    @ObservedObject var viewModel = ForgotPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var forgotPasswordError = false
    private let disposeBag = DisposeBag()
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .padding(.leading)
                .padding(.trailing)
            Button(action: {
                let disposable = self.viewModel.forgotPassword().subscribe(onNext: { result in
                    switch result {
                        case .CORRECT: self.forgotResultCorrect()
                        case .DEFAULT_ERROR: self.forgotResultIncorrect()
                    }
                })
                self.disposeBag.insert(disposable)
            }) {
                Text("Recover")
            }
        }
        .alert(isPresented: $forgotPasswordError) {
            Alert(
                title: Text("Something went wrong"),
                message: Text("We couldn't sent the recover email"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func forgotResultCorrect() {
        self.viewModel.clear()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func forgotResultIncorrect() {
        forgotPasswordError = true
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
