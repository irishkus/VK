//
//  SearchGroupsService.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 08.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchGroupsService {
    public func sendRequest(searchText: String, completion: @escaping ([SearchGroup]) -> Void) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.search"
        let sessionUser = UserSession.instance
        
        let parameters: Parameters = [
            "access_token": sessionUser.token,
            "q": searchText,
            "v": "5.92",
            "count": 100
        ]
        
        let url = baseUrl+path

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            switch repsonse.result {
            case .success(let value):
                let json = JSON(value)
            //    print(json)
                let groups = json["response"]["items"].arrayValue.map { json in
                    return SearchGroup(json: json)
                }
                completion(groups)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
