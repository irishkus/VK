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

class Group : Decodable, CustomStringConvertible {
    var description: String {
        return " \(name)"
    }
    
    var id = 0
    var name = ""
    var photo = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case photo
        case id
    }
    
    init(json: JSON)  {
        self.name = json["name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
    }
}
