//
//  SearchGroups.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 08.03.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class SearchGroup : Object {
    
    @objc dynamic  var id = 0
    @objc dynamic  var name = ""
    @objc dynamic  var photo = ""
    
    
    convenience init(json: JSON)  {
        self.init()
        self.name = json["name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}
