//
//  UberUser.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

struct UberUser: Identifiable {
    let id: String
    let fullname: String
    let email: String
    let userType: UserType
    
    init(data: [String: Any]) {
        self.id = data["uid"] as? String ?? ""
        self.fullname = data["fullname"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.userType = .init(rawValue: data["accountType"] as? String ?? "") ?? .RIDER
    }
}
