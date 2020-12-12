//
//  CapitalsModel.swift
//  Schoenstapp
//
//  Created by usuario on 08/12/2020.
//  Copyright © 2020 Kevin Schweitzer. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class CapitalsModel {
    
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid
    lazy var capitals = db.collection(Constants.CAPITALS_COLLECTION_NAME)
    lazy var usersCapitals = db.collection(Constants.USERS_CAPITALS_COLLECTION_NAME)

    func createUrn(urnName: String) -> Observable<FirebaseResponse> {
        return Observable.create { emitter in
            self.usersCapitals.whereField(Constants.USER_ID_FIELD, isEqualTo: self.userId!).getDocuments { querySnapshot, error in
                self.db.runTransaction({ transaction, error in
                    let newUrn = self.capitals.document()
                    transaction.setData([
                        "name": urnName,
                        "ownerId": self.userId!,
                        "password": "",
                        "capitals": 0
                    ], forDocument: newUrn)
                    if querySnapshot?.isEmpty != false {
                        let newUserCapital = self.usersCapitals.document()
                        transaction.setData([
                            "userId": self.userId!,
                            "ownedIds": Array<String>(arrayLiteral: newUrn.documentID),
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
                        emitter.onNext(FirebaseResponse.DEFAULT_ERROR)
                        print("Transaction failed: \(error)")
                    } else {
                        emitter.onNext(FirebaseResponse.CORRECT)
                        print("Transaction successfully committed!")
                    }
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func getCapitalUrns() -> Observable<Array<CapitalEntity>> {
        return Observable.create { emitter in
            self.usersCapitals.whereField(Constants.USER_ID_FIELD, isEqualTo: self.userId!).getDocuments { querySnapshot, error in
                var urns = Array<CapitalEntity>()
                if querySnapshot?.isEmpty == false {
                    var ownedCapitalsIds = querySnapshot?.documents[0].get(Constants.OWNED_IDS_FIELD) as! Array<String>
                    let joinedCapitalsIds = querySnapshot?.documents[0].get(Constants.JOINED_IDS_FIELD) as! Array<String>
                    ownedCapitalsIds.append(contentsOf: joinedCapitalsIds)
                    if(ownedCapitalsIds.isEmpty == false) {
                        ownedCapitalsIds.forEach { capitalId in
                            self.capitals.document(capitalId).getDocument() { document, error in
                                if(error == nil) {
                                    urns.append(
                                        CapitalEntity(
                                            id: document!.documentID,
                                            name: document!.get("name") as! String,
                                            ownerId: document!.get("ownerId") as! String,
                                            password: document!.get("password") as! String,
                                            capitals: document!.get("capitals") as! Int
                                        )
                                    )
                                }
                                emitter.onNext(urns)
                            }
                        }
                    } else {
                        emitter.onNext(urns)
                    }
                } else {
                    emitter.onNext(urns)
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteCapitalUrn(id: String) -> Observable<FirebaseResponse> {
        return Observable.create { emitter in
            self.usersCapitals.whereField(Constants.USER_ID_FIELD, isEqualTo: self.userId!).getDocuments { querySnapshot, error in
                self.db.runTransaction({ transaction, error in
                    let userCapital = querySnapshot?.documents[0]
                    var ownedList = userCapital?.get(Constants.OWNED_IDS_FIELD) as! Array<String>
                    let removeIndex = ownedList.firstIndex(of: id)
                    if removeIndex != nil {
                        ownedList.remove(at: removeIndex!)
                    }
                    self.capitals.document(id).delete()
                    transaction.updateData(
                        ["ownedIds": ownedList],
                        forDocument: userCapital!.reference
                    )
                    return nil
                })
                { transaction, error in
                    if let error = error {
                        emitter.onNext(FirebaseResponse.DEFAULT_ERROR)
                        print("Transaction failed: \(error)")
                    } else {
                        emitter.onNext(FirebaseResponse.CORRECT)
                        print("Transaction successfully committed!")
                    }
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func joinUrn(urnId: String) -> Observable<FirebaseResponse> {
        return Observable.create { emitter in
            self.usersCapitals.whereField(Constants.USER_ID_FIELD, isEqualTo: self.userId!).getDocuments { querySnapshot, error in
                self.db.runTransaction({ transaction, error in
                    if querySnapshot?.isEmpty != false {
                        let newUserCapital = self.usersCapitals.document()
                        transaction.setData([
                            "userId": self.userId!,
                            "ownedIds": Array<String>(),
                            "joinedIds": Array<String>(arrayLiteral: urnId)
                        ], forDocument: newUserCapital)
                    } else {
                        let userCapital = querySnapshot?.documents[0]
                        let ownedList = userCapital?.get(Constants.OWNED_IDS_FIELD) as! Array<String>
                        var joinedList = userCapital?.get(Constants.JOINED_IDS_FIELD) as! Array<String>
                        if( !joinedList.contains(urnId) && !ownedList.contains(urnId)) {
                            joinedList.append(urnId)
                            transaction.updateData([
                                "joinedIds": joinedList
                            ], forDocument: userCapital!.reference)
                        }
                        
                    }
                    return nil
                }) { transaction, error in
                    if let error = error {
                        emitter.onNext(FirebaseResponse.DEFAULT_ERROR)
                        print("Transaction failed: \(error)")
                    } else {
                        emitter.onNext(FirebaseResponse.CORRECT)
                        print("Transaction successfully committed!")
                    }
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

struct CapitalEntity: Identifiable {
    var id: String
    var name: String
    var ownerId: String
    var password: String = ""
    var capitals: Int = 0
}
