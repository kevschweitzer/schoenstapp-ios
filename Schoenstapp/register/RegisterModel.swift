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

class RegisterModel {
    
    func registerNewUser(email: String, password: String) -> Observable<FirebaseResponse> {
       return Observable.create { emitter in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error == nil {
                    authResult?.user.sendEmailVerification(completion: { error in
                        if error == nil {
                            emitter.onNext(FirebaseResponse.CORRECT)
                        } else {
                            emitter.onNext(FirebaseResponse.DEFAULT_ERROR)
                        }
                    })
                } else {
                    print("error \(error?.localizedDescription as String?)")
                    emitter.onNext(FirebaseResponse.DEFAULT_ERROR)
                }
            }
        return Disposables.create()
        }
        
    }
}
