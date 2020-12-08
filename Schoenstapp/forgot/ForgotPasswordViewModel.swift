//
//  ForgotPasswordViewModel.swift
//  Schoenstapp
//
//  Created by usuario on 05/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import RxSwift

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var email: String = ""
    let model = ForgotPasswordModel()
    
    
    func forgotPassword() -> Observable<FirebaseResponse> {
        return model.sendForgotEmail(email: email)
    }
    
    func clear() {
        email = ""
    }
}
