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
    
   // var id = 0
 //   var sizes = [JSON]()
    var url : String
  //  var photo = ""
    

    
    init(json: JSON)  {
     //   self.sizes = json["sizes"].arrayValue
        self.url = json["sizes"][8]["url"].stringValue
       // self.photo = json["photo_50"].stringValue
    //    self.id = json["id"].intValue
      //  print(json["sizes"][0]["src"])
   //    print(json["sizes"][0])
    //    print(json["sizes"])
    }
}

