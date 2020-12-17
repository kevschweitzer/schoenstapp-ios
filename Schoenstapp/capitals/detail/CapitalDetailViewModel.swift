//
//  CapitalDetailViewModel.swift
//  Schoenstapp
//
//  Created by usuario on 17/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import RxSwift

class CapitalDetailViewModel: ObservableObject {
    @Published var openedUrn: CapitalEntity
    let model = CapitalsModel()
    
    init(urn: CapitalEntity) {
        openedUrn = urn
    }
    
    func addCapitalToUrn() -> Observable<Int>{
        return model.addCapitalToUrn(urnId: self.openedUrn.id)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .do(onNext: { result in
                self.openedUrn.capitals = result
            })
    }
}
