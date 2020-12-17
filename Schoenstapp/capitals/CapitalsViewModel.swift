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
        let disposable = model.getCapitalUrns()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.urns = result
            })
        disposeBag.insert(disposable)
    }
    
    func createUrn() -> Observable<FirebaseResponse> {
        return model.createUrn(urnName: urnName)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .do(onCompleted: {
                self.getUrns()
            })
    }
    
    func deleteUrn(id: String) -> Observable<FirebaseResponse> {
        return model.deleteCapitalUrn(id: id)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .do(onCompleted: {
                self.getUrns()
            })
    }
    
    func joinUrn() -> Observable<FirebaseResponse> {
        let joinLinkSplit = urnName.split(separator: "?")
        let urnId = (joinLinkSplit.count > 1) ? String(joinLinkSplit[1]) : "0"
        return model.joinUrn(urnId: urnId)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .do(onCompleted: {
                self.getUrns()
            })
    }
    
    func exitUrn(urnId: String) -> Observable<FirebaseResponse> {
        return model.exitUrn(urnId: urnId)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .do(onCompleted: {
                self.getUrns()
            })
    }
}
