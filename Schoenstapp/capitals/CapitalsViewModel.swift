//
//  CapitalsViewModel.swift
//  Schoenstapp
//
//  Created by usuario on 08/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import RxSwift

class CapitalsViewModel: ObservableObject {
    
    @Published var urnName: String = ""
    private var model = CapitalsModel()
    
    func createUrn() -> Observable<FirebaseResponse> {
        return model.createUrn(urnName: urnName)
    }
    
    func joinUrn() {
        
    }
}
