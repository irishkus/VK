//
//  Photo.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 12.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Photo : Object {

    @objc dynamic var url : String = ""
    @objc dynamic var id : Int = 0
    var owner = LinkingObjects(fromType: User.self, property: "photos")//: User?

    convenience init(json: JSON)  {
        self.init()
        self.url = json["sizes"][4]["url"].stringValue
        self.id = json["id"].intValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}

