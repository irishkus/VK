//
//  FotoService.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 07.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FotoService {
    let baseUrl = "https://api.vk.com"
    let sessionUser = UserSession.instance
    let path = "/method/photos.getAll"

    public func sendRequest(id: Int, completion: @escaping ([Photo]) -> Void) {
        let parameters: Parameters = [
            "access_token": sessionUser.token,
            "no_service_albums": "1",
            "owner_id": id,
            "v": "5.92",
            "count": 100
        ]

        let url = baseUrl+path

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            switch repsonse.result {
            case .success(let value):
                let json = JSON(value)
                let photos = json["response"]["items"].arrayValue.map { json in
                    return Photo(json: json)
                }
                completion(photos)
//                                photos.forEach {
//                                    print($0)
//                                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}