//
//  DatabaseManager.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/14.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import Foundation
import RealmSwift

let kSerialQueueLabel = "com.ro.RealmSample.worker"

class DatabaseManager: NSObject {
    
    static let sharedInstance: DatabaseManager = DatabaseManager()
    
    private override init() {
    }
    
    func selectFromUser(_ completionHandler:@escaping (Results<User>?) -> Void) {
        DispatchQueue(label: kSerialQueueLabel).async {
            autoreleasepool {
                let realm = try! Realm()
                let users = realm.objects(User.self)
                let ref = ThreadSafeReference(to: users)
                
                DispatchQueue.main.async {
                    let mainRealm = try! Realm()
                    guard let result = mainRealm.resolve(ref) else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(result)
                }
            }
        }
    }
    
    func insertUser(_ user: User, completionHandler:@escaping (Results<User>?) -> Void) {
        DispatchQueue(label: kSerialQueueLabel).async {
            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    realm.add(user, update: true)
                }
                
                let users = realm.objects(User.self)
                let ref = ThreadSafeReference(to: users)
                
                DispatchQueue.main.async {
                    let mainRealm = try! Realm()
                    guard let result = mainRealm.resolve(ref) else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(result)
                }
            }
        }
    }
    
    func filterUser(_ predicateFormat: String, _ args: String..., completionHandler:@escaping (Results<User>?) -> Void) {
        DispatchQueue(label: kSerialQueueLabel).async {
            autoreleasepool {
                var query = predicateFormat
                for arg in args {
                    let appendQuery = String(format: " OR %@", arg)
                    query += appendQuery
                }
                let realm = try! Realm()
                let currencies = realm.objects(User.self).filter(query)
                let ref = ThreadSafeReference(to: currencies)
                
                DispatchQueue.main.async {
                    let mainRealm = try! Realm()
                    guard let result = mainRealm.resolve(ref) else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(result)
                }
            }
        }
    }
    
    func deleteUser(_ user: User, _ completionHandler:@escaping (Results<User>?) -> Void) {
        let mainThreadUser = ThreadSafeReference(to: user)
        DispatchQueue(label: kSerialQueueLabel).async {
            autoreleasepool {
                let realm = try! Realm()
                
                if let res = realm.resolve(mainThreadUser) {
                    try! realm.write() {
                        realm.delete(res)
                    }
                }
                
                let users = realm.objects(User.self)
                let ref = ThreadSafeReference(to: users)
                
                DispatchQueue.main.async {
                    let mainRealm = try! Realm()
                    guard let result = mainRealm.resolve(ref) else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(result)
                }
            }
        }
    }
    
    func selectTickerOrderBy(_ sortType: SortType, completionHandler:@escaping (Results<User>?) -> Void) {
        DispatchQueue(label: kSerialQueueLabel).async {
            autoreleasepool {
                let realm = try! Realm()
                let users = realm.objects(User.self).sorted(byKeyPath: sortType.param, ascending: sortType.isAscending)
                let ref = ThreadSafeReference(to: users)
                
                DispatchQueue.main.async {
                    let mainRealm = try! Realm()
                    guard let result = mainRealm.resolve(ref) else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(result)
                }
            }
        }
    }
}
