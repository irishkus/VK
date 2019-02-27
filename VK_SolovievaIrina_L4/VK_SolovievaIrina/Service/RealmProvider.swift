//
//  RealmProvider.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 25.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import RealmSwift

class RealmProvider {
    
    static func save<T: Object>(items: [T],
                                config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                                update: Bool = true) {
        print(config.fileURL!)
        
        do {
            let realm = try Realm(configuration: config)
            
            try realm.write {
                realm.add(items, update: update)
            }
            
            
        } catch {
            print(error)
        }
    }
    
    func greet<T: MyProtocol>(item: T) {
        item.sayHello()
    }
    
    func greet(item: MyProtocol) {
        item.sayHello()
    }
}

protocol MyProtocol {
    func sayHello()
}
