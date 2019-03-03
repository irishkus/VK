//
//  RealmProvider.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 25.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import RealmSwift

class RealmProvider {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func save<T: Object>(items: [T],
                                config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                                update: Bool = true) {
        print(config.fileURL!)
        
        do {
            let realm = try Realm(configuration: self.deleteIfMigration)
            
            try realm.write {
                realm.add(items, update: update)
            }
            
            
        } catch {
            print(error)
        }
    }
    
    static func get<T: Object>(_ type: T.Type,
                               config: Realm.Configuration = Realm.Configuration.defaultConfiguration)
        -> Results<T>? {
            do {
                let realm = try Realm(configuration: self.deleteIfMigration)
                return realm.objects(type)
            } catch {
                print(error)
            }
            return nil
    }
}


