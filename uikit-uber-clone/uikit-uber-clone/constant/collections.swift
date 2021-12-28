//
//  collections.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Firebase

private let db = Firestore.firestore()

public let COLLECTION_USER = db.collection("users")
public let COLLECTION_TRIP = db.collection("trips")
