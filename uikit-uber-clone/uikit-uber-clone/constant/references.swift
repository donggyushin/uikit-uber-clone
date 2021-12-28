//
//  references.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Firebase

public let REFERENCE_LOCATION = Database.database().reference(withPath: "locations")
public let REFERENCE_TRIP = Database.database().reference(withPath: "trips")
