//
//  ForgotPasswordModel.swift
//  Schoenstapp
//
//  Created by usuario on 05/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class ForgotPasswordModel {
    
    func sendForgotEmail(email: String) -> Observable<FirebaseResponse> {
        return Observable.create { emitter in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error == nil {
                    emitter.onNext(FirebaseResponse.CORRECT)
                } else {
                    emitter.onNext(FirebaseResponse.DEFAULT_ERROR)
                }
            }
            return Disposables.create()
        }
    }
    
}
