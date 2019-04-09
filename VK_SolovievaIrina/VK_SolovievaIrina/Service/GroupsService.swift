//
//  GroupsService.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 07.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GroupsService {
    public func sendRequest(completion: @escaping ([Group]) -> Void) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        let sessionUser = UserSession.instance
        
        let parameters: Parameters = [
            "access_token": sessionUser.token,
            "extended": "1",
            "v": "5.92"
        ]
        
        let url = baseUrl+path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            switch repsonse.result {
            case .success(let value):
                let json = JSON(value)
                let groups = json["response"]["items"].arrayValue.map { json in
                    return Group(json: json)
                }
                completion(groups)

            //  completion(users)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }        
    }
}
