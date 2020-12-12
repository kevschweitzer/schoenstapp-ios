//
//  CapitalsView.swift
//  Schoenstapp
//
//  Created by usuario on 07/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI
import RxSwift

struct CapitalsView: View {
    @State var showCreateAlert = false
    @State var showJoinAlert = false
    @State var showResponse = false
    @State var showDeleteDialog = false
    @State var responseMessage = ""
    @ObservedObject var viewModel = CapitalsViewModel()
    var disposeBag = DisposeBag()

    var body: some View {
        ZStack {
            List(viewModel.urns) { urn in
                HStack {
                    Text(urn.name)
                    Spacer()
                    Button(action: {
                        self.showDeleteDialog = true
                    }) {
                        Text("Delete")
                    }.foregroundColor(Color.red)
                        .alert(isPresented: self.$showDeleteDialog) {
                            Alert(title: Text("Are you sure you want to delete?"),
                                  primaryButton: .default(Text("Confirm"), action: {
                                    let disposable = self.viewModel.deleteUrn(id: urn.id).subscribe(onNext: { result in
                                        switch result {
                                            case .CORRECT: self.showResponseMessage(message: "Urn deleted succesfully")
                                            case .DEFAULT_ERROR: self.showResponseMessage(message: "Error deleting urn. Try again")
                                        }
                                    })
                                    self.disposeBag.insert(disposable)
                                  }),
                                  secondaryButton: .default(Text("Dismiss")) )
                    }
                }
            }
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
                let disposable = self.viewModel.createUrn().subscribe(onNext: { response in
                    switch response {
                        case .CORRECT: self.showResponseMessage(message: "Urn created successfully")
                        case .DEFAULT_ERROR: self.showResponseMessage(message: "Error creating urn. Try again")
                    }
                })
                self.disposeBag.insert(disposable)
            }
        .textFieldAlert(
            isShowing: $showJoinAlert,
            text: $viewModel.urnName,
            title: "Join Urn",
            buttonText: "Join") {
                self.viewModel.joinUrn()
            }
        .alert(isPresented: $showResponse) {
            Alert(title: Text(responseMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func showResponseMessage(message: String) {
        self.showResponse = true
        self.responseMessage = message
    }
}

struct CapitalsView_Previews: PreviewProvider {
    static var previews: some View {
        CapitalsView()
    }
}
