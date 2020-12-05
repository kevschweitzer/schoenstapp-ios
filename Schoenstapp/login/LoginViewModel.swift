//
//  LoginViewModel.swift
//  Schoenstapp
//
//  Created by usuario on 05/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    let model = LoginModel()
    
    func login() -> Observable<FirebaseResponse> {
        return model.login(user: username, password: password)
    }
}
