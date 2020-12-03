//
//  LoginView.swift
//  Schoenstapp
//
//  Created by usuario on 02/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: RegisterView()) {
                Text("Sign up!")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
