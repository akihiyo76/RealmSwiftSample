//
//  User.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/14.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var id: Int = Int(Date().timeIntervalSince1970)
    @objc dynamic var name: String?
    @objc dynamic var nickname: String?
    @objc dynamic var age: String?
    @objc dynamic var birthday: String?
    @objc dynamic var hoby: String?
    
    override static func primaryKey()-> String? {
        return "id"
    }
    
}
