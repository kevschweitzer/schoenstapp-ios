//
//  MainView.swift
//  Schoenstapp
//
//  Created by usuario on 07/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI

struct MainView: View {
   @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            if(viewModel.loginCorrect) {
                MenuView()
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
