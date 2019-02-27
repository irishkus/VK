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

class User : Object, Decodable {
    
   @objc dynamic var id = 0
   @objc dynamic var firstName = ""
   @objc dynamic var lastName = ""
   @objc dynamic var photo = ""

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case photo
        case id
    }

    convenience init(json: JSON)  {
        self.init()
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}

