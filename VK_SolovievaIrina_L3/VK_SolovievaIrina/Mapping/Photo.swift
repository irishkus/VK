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

class Photo : CustomStringConvertible {
    var description: String {
        return "Фотки такие \(url) "
    }

    var url : String

    init(json: JSON)  {
        self.url = json["sizes"][8]["url"].stringValue

    }
}

