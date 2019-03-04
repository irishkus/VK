//
//  User.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 10.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class User : Object {
    
   @objc dynamic var id = 0
   @objc dynamic var name = ""
   @objc dynamic var lastName = ""
   @objc dynamic var photo = ""
    var photos = List<Photo>()

    convenience init(json: JSON, photos : [Photo] = [])  {
        self.init()
        self.name = json["last_name"].stringValue + " " + json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
        self.photos.append(objectsIn: photos)
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}

