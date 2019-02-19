//
//  Group.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 11.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Group : Object, Decodable {
    
   @objc dynamic  var id = 0
   @objc dynamic  var name = ""
   @objc dynamic  var photo = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case photo
        case id
    }
    
    convenience init(json: JSON)  {
        self.init()
        self.name = json["name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
    }
}
