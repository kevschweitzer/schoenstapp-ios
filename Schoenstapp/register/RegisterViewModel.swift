//
//  LoginViewModel.swift
//  Schoenstapp
//
//  Created by usuario on 29/11/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import RxSwift

class RegisterViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    var model = RegisterModel()
 
    func clear() {
        username = ""
        password = ""
    }
    
    func registerNewUser() -> Observable<FirebaseResponse> {
         return model.registerNewUser(email: username, password: password)
    }
    
}
