//
//  CapitalDetail.swift
//  Schoenstapp
//
//  Created by usuario on 14/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI
import RxSwift

struct CapitalDetail: View {
    @ObservedObject var viewModel: CapitalDetailViewModel
    var disposeBag = DisposeBag()
    
    var body: some View {
        ZStack {
            Image("inside_shrine")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Text("\(viewModel.openedUrn.capitals)")
                        .padding()
                        .padding()
                        .background(Color.blue)
                    Spacer()
                    FloatingButton(text: "") {
                        let disposable = self.viewModel.addCapitalToUrn().subscribe()
                        self.disposeBag.insert(disposable)
                    }
                    .padding()
                }
            }
            
        }
    }
}
