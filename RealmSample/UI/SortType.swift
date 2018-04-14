//
//  SortType.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/15.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import Foundation

enum SortType: Int {
    case id_ascending = 0
    case id_descending
    case name_ascending
    case name_descending
    
    var param: String {
        switch self {
        case .id_ascending, .id_descending:
            return "id"
        case .name_ascending, .name_descending:
            return "name"
        }
    }
    
    var isAscending: Bool {
        switch self {
        case .id_descending,
             .name_descending:
            return true
        default:
            return false
        }
    }
}
