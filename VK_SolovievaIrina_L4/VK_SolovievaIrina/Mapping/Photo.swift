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
    @objc dynamic var height : Int = 0

    convenience init(json: JSON)  {
        self.init()
        self.url = json["sizes"][4]["url"].stringValue
        self.height = json["sizes"][4]["height"].intValue
        
    }
}

