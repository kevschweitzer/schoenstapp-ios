//
//  LoginModel.swift
//  Schoenstapp
//
//  Created by usuario on 05/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class LoginModel {
    
    func login(user: String, password: String) -> Observable<FirebaseResponse>{
        return Observable.create { emitter in
            Auth.auth().signIn(withEmail: user, password: password) { authResult, error in
                if(error == nil) {
                    if(Auth.auth().currentUser?.isEmailVerified == true) {
                        emitter.onNext(FirebaseResponse.CORRECT)
                    } else {
                        print("Email not verified")
                        emitter.onNext(FirebaseResponse.DEFAULT_ERROR)
                    }
                } else {
                    print("error \(error?.localizedDescription as String?)")
                    emitter.onNext(FirebaseResponse.DEFAULT_ERROR)
                }
            }
            return Disposables.create()
        }
    }
}
