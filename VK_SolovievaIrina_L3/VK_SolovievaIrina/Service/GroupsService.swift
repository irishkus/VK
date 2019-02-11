//
//  GroupsService.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 07.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire

class GroupsService {
    public func sendRequest() {
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
            print("Список групп!")
            print(repsonse.value ?? "")
        }
        
    }
}
