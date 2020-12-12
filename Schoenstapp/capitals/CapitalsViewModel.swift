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
    @Published var urns = Array<CapitalEntity>()
    var disposeBag = DisposeBag()
    
    init() {
        getUrns()
    }
    
    func getUrns() {
        let disposable = model.getCapitalUrns().subscribe(onNext: { result in
            self.urns = result
        })
        disposeBag.insert(disposable)
    }
    
    func createUrn() -> Observable<FirebaseResponse> {
        return model.createUrn(urnName: urnName).do(onCompleted: {
            self.getUrns()
        })
    }
    
    func deleteUrn(id: String) -> Observable<FirebaseResponse> {
        return model.deleteCapitalUrn(id: id).do(onCompleted: {
            self.getUrns()
        })
    }
    
    func joinUrn() -> Observable<FirebaseResponse> {
        return model.joinUrn(urnId: urnName).do(onCompleted: {
            self.getUrns()
        })
    }
}
