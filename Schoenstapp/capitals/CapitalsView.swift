//
//  CapitalsView.swift
//  Schoenstapp
//
//  Created by usuario on 07/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI

struct CapitalsView: View {
    @State var showCreateAlert = false
    @State var showJoinAlert = false
    @ObservedObject var viewModel = CapitalsViewModel()

    var body: some View {
        ZStack {
            FloatingMenu(
                onCreateClicked: {
                    self.showCreateAlert = true
                },
                onJoinClicked: {
                    self.showJoinAlert = true
                }
            )
        }.textFieldAlert(
            isShowing: $showCreateAlert,
            text: $viewModel.urnName,
            title: "Create Urn",
            buttonText: "Create") {
                self.viewModel.createUrn()
            }
        .textFieldAlert(
            isShowing: $showJoinAlert,
            text: $viewModel.urnName,
            title: "Join Urn",
            buttonText: "Join") {
                self.viewModel.joinUrn()
            }
    }
}

struct CapitalsView_Previews: PreviewProvider {
    static var previews: some View {
        CapitalsView()
    }
}

