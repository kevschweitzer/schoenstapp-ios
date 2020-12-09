//
//  CapitalsViewModel.swift
//  Schoenstapp
//
//  Created by usuario on 08/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation

class CapitalsViewModel: ObservableObject {
    
    @Published var urnName: String = ""
    private var model = CapitalsModel()
    
    func createUrn() {
        model.createUrn(urnName: urnName)
    }
    
    func joinUrn() {
        
    }
}
