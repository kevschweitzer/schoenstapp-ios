//
//  MenuView.swift
//  Schoenstapp
//
//  Created by usuario on 05/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import SwiftUI

struct MenuView: View {
        
    var body: some View {
        NavigationView {
            NavigationLink(destination: CapitalsView()) {
                Text("Capitales de Gracia")
            }
        }
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
