//
//  FriendsService.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 07.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FriendsService {
    let baseUrl = "https://api.vk.com"
    let sessionUser = UserSession.instance
    let path = "/method/friends.get"
    
    public func sendRequest(photos: [Photo], completion: @escaping ([User]) -> Void) {
        let parameters: Parameters = [
            "access_token": sessionUser.token,
            "order": "name",
            "fields": "nickname, photo_50",
            "v": "5.92"
        ]
        
        let url = baseUrl+path
    
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            switch repsonse.result {
            case .success(let value):
                let json = JSON(value)
                let users = json["response"]["items"].arrayValue.map { User(json: $0, photos: photos)
                }
                completion(users)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
