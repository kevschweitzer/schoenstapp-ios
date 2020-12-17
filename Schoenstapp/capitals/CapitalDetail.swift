//
//  CapitalDetail.swift
//  Schoenstapp
//
//  Created by usuario on 14/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI

struct CapitalDetail: View {
    var urn: CapitalEntity
    
    var body: some View {
        Text("\(urn.name)")
    }
}

struct CapitalDetail_Previews: PreviewProvider {
    static var previews: some View {
        CapitalDetail(urn: CapitalEntity(
            id: "asd", name: "Prueba Capitalario", ownerId: ""
        ))
    }
}

