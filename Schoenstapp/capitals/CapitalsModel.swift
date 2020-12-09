//
//  CapitalsModel.swift
//  Schoenstapp
//
//  Created by usuario on 08/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import Firebase

class CapitalsModel {
    
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid
    lazy var capitals = db.collection(Constants.CAPITALS_COLLECTION_NAME)
    lazy var usersCapitals = db.collection(Constants.USERS_CAPITALS_COLLECTION_NAME)

    func createUrn(urnName: String) {
        usersCapitals.whereField(Constants.USER_ID_FIELD, isEqualTo: userId!).getDocuments { querySnapshot, error in
            self.db.runTransaction({ transaction, error in
                let newUrn = self.capitals.document()
                transaction.setData([
                    "name": urnName,
                    "ownerId": self.userId!,
                    "password": "",
                    "capitals": 0
                ], forDocument: newUrn)
                transaction.setData([:], forDocument: newUrn)
                if querySnapshot?.isEmpty != false {
                    let newUserCapital = self.usersCapitals.document()
                    transaction.setData([
                        "userId": self.userId!,
                        "ownedIds": Array<String>(),
                        "joinedIds": Array<String>()
                    ], forDocument: newUserCapital)
                } else {
                    let userCapital = querySnapshot?.documents[0]
                    var ownedList = userCapital?.get(Constants.OWNED_IDS_FIELD) as! Array<String>
                    ownedList.append(newUrn.documentID)
                    transaction.updateData([
                        "ownedIds": ownedList
                    ], forDocument: userCapital!.reference)
                }
                return nil
            }) { transaction, error in
                if let error = error {
                    print("Transaction failed: \(error)")
                } else {
                    print("Transaction successfully committed!")
                }
            }
        }
    }
}

struct CapitalEntity {
    var name: String
    var ownerId: String
    var password: String = ""
    var capitals: Int = 0
}
