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
    @State var urnToBeDeletedOrExited: CapitalEntity? = nil
    @State var responseMessage = ""
    @ObservedObject var viewModel = CapitalsViewModel()
    var disposeBag = DisposeBag()

    var body: some View {
        ZStack {
            List(viewModel.urns) { urn in
                HStack {
                    Text(urn.name)
                    Spacer()
                    Text("\(urn.capitals)")
                    Spacer()
                    self.getDeleteButton(urn: urn)
                    Spacer()
                    self.getAddButton(urn: urn)
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
                let disposable = self.viewModel.joinUrn().subscribe(onNext: { response in
                    switch response {
                        case .CORRECT: self.showResponseMessage(message: "Joined urn successfully")
                        case .DEFAULT_ERROR: self.showResponseMessage(message: "Error joining urn. Try again")
                    }
                })
                self.disposeBag.insert(disposable)
            }
        .alert(isPresented: $showResponse) {
            Alert(title: Text(responseMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func deleteUrn(urn: CapitalEntity) {
        let disposable = self.viewModel.deleteUrn(id: urn.id).subscribe(onNext: { result in
            switch result {
                case .CORRECT: self.showResponseMessage(message: "Urn deleted succesfully")
                case .DEFAULT_ERROR: self.showResponseMessage(message: "Error deleting urn. Try again")
            }
        })
        self.disposeBag.insert(disposable)
    }
    
    func exitUrn(urn: CapitalEntity) {
        let disposable = self.viewModel.exitUrn(urnId: urn.id).subscribe(onNext: { result in
            switch result {
                case .CORRECT: self.showResponseMessage(message: "Urn exited succesfully")
                case .DEFAULT_ERROR: self.showResponseMessage(message: "Error exiting urn. Try again")
            }
        })
        self.disposeBag.insert(disposable)
    }
    
    func getDeleteButton(urn: CapitalEntity) -> some View {
        return
            Button(action: {
                self.urnToBeDeletedOrExited = urn
            }){
                if(urn.amIOwner) {
                    Text("Delete")
                } else {
                    Text("Exit")
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .alert(item: self.$urnToBeDeletedOrExited) { urn in
                Alert(
                    title: urn.amIOwner ? Text("Are you sure you want to delete?") : Text("Are you sure you want to exit?"),
                    primaryButton: .default(Text("Dismiss")),
                    secondaryButton: .default(
                        Text("Confirm"),
                        action: {
                            urn.amIOwner ? self.deleteUrn(urn: urn) : self.exitUrn(urn: urn)
                        }
                    )
                )
            }
    }
    
    func getAddButton(urn: CapitalEntity) -> some View {
        return Button(
            action: {
                let disposable = self.viewModel.addCapitalToUrn(urnId: urn.id).subscribe()
                self.disposeBag.insert(disposable)
            }
        ) {
            Text("+")
        }
        .buttonStyle(BorderlessButtonStyle())
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
