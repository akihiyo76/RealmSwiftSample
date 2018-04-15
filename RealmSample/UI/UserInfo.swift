//
//  UserInfo.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/14.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import Foundation

enum UserInfo: Int {
    case unknown = -1
    case name
    case nickname
    case age
    case birthday
    case hoby
    
    static let count = 5
    
    var title: String {
        return self.key
    }
    
    var key: String {
        switch self {
        case .name:
            return "name"
        case .nickname:
            return "nickname"
        case .age:
            return "age"
        case .birthday:
            return "birthday"
        case .hoby:
            return "hoby"
        default:
            return ""
        }
    }
}
