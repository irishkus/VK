//
//  FriendsService.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 07.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation

class FriendsService {
    public func sendRequest() {
        let path = "/method/friends.get"
        let sessionUser = UserSession.instance
        

        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = path
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: sessionUser.token),
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "nickname, photo_50"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        
        guard let url = urlConstructor.url else { preconditionFailure("Bad url")}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
        let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            
        print("Список друзей!")
        print(json ?? "")
        }
        
        task.resume()
        
    }
}
