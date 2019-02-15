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

class User : Decodable, CustomStringConvertible {
    var description: String {
        return "\(firstName) \(lastName) \(id)"
    }
    
    var id = 0
    var firstName = ""
    var lastName = ""
    var photo = ""

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case photo
        case id
    }

    init(json: JSON)  {
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
    }
}

