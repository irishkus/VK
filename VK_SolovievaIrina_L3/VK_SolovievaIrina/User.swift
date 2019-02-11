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
        //self.init()
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//      //  let user = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
//        self.firstName = try values.decode(String.self, forKey: .firstName)
//        self.lastName = try values.decode(String.self, forKey: .lastName)
//        self.photo = try values.decode(String.self, forKey: .photo)
//        print(self.firstName)
//        print(self.lastName)
//        print(self.photo)
//        var userValues = try values.nestedUnkeyedContainer(forKey: .weather)
//        let firstWeatherValues = try weatherValues.nestedContainer(keyedBy: WeatherKeys.self)
//        self.weatherName = try firstWeatherValues.decode(String.self, forKey: .main)
//        self.weatherIcon = try firstWeatherValues.decode(String.self, forKey: .icon)
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
    }
}

