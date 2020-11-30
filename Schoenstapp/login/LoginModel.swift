//
//  LoginModel.swift
//  Schoenstapp
//
//  Created by usuario on 29/11/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class LoginModel {
    
    func registerNewUser(email: String, password: String) -> Observable<Bool> {
       return Observable.create { emitter in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error == nil {
                    authResult?.user.sendEmailVerification(completion: { error in
                        if error == nil {
                            emitter.onNext(true)
                        } else {
                            emitter.onNext(false)
                        }
                    })
                } else {
                    print("error \(error?.localizedDescription as String?)")
                    emitter.onNext(false)
                }
            }
        return Disposables.create()
        }
        
    }
}
