//
//  User+Copy.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/14.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import Foundation

extension User: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        let user = User()
        user.id = self.id
        user.name = self.name
        user.nickname = self.nickname
        user.birthday = self.birthday
        user.hoby = self.hoby
        user.age = self.age
        return user
    }
    
}
