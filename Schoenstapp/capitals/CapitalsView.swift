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

    init() {
        UITableView.appearance().backgroundColor = .clear // For tableView
        UITableViewCell.appearance().backgroundColor = .clear // For tableViewCell
    }
    
    var body: some View {
        ZStack {
            Image("shrine2")
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.leading)
                .edgesIgnoringSafeArea(.trailing)
            List {
                ForEach(viewModel.urns) { urn in
                    NavigationLink(destination: CapitalDetail(viewModel: CapitalDetailViewModel(urn: urn))) {
                        HStack {
                            Text(urn.name)
                            Spacer()
                            self.getShareButton(urn: urn)
                        }
                        .padding()
                        .edgesIgnoringSafeArea(.all)
                        .listRowBackground(Color.white.opacity(0.3))
                    }
                }
                .onDelete(perform: removeUrn)
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
                .listRowBackground(Color.white.opacity(0.4))
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
            buttonText: "Create",
            hintText: "Enter urn name") {
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
            buttonText: "Join",
            hintText: "Enter join link") {
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

    func removeUrn(at offsets: IndexSet) {
        if let index = offsets.first {
            self.urnToBeDeletedOrExited = viewModel.urns[index]
        }
    }
    
    func shareUrn(at offsets: IndexSet, index: Int) {
        if let index = offsets.first {
            let urn = viewModel.urns[index]
            let shareText = "Join my Capital of Grace urn! \(Constants.BASE_SHARE_URL)?\(urn.id)"
            let av = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
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
   
    func getShareButton(urn: CapitalEntity) -> some View  {
        return Button(
            action: {
                let shareText = "Join my Capital of Grace urn! \(Constants.BASE_SHARE_URL)?\(urn.id)"
                let av = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
            }
        ) {
            if let shareImage = UIImage(systemName: "square.and.arrow.up") {
                Image(uiImage: shareImage)
            }
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
