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
        let urnId = urnName.split(separator: "?")[1]
        return model.joinUrn(urnId: String(urnId)).do(onCompleted: {
            self.getUrns()
        })
    }
    
    func exitUrn(urnId: String) -> Observable<FirebaseResponse> {
        return model.exitUrn(urnId: urnId).do(onCompleted: {
            self.getUrns()
        })
    }
    
    func addCapitalToUrn(urnId: String) -> Observable<Int>{
        return model.addCapitalToUrn(urnId: urnId).do(onNext: { result in
            if let index = self.urns.firstIndex(where: {$0.id == urnId}) {
                self.urns[index].capitals = result
            }
        })
    }
}
