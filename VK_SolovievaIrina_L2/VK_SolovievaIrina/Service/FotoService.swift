//
//  FotoService.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 07.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation

class FotoService {
    public func sendRequest() {
        let path = "/method/photos.getAll"
        let sessionUser = UserSession.instance
        
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = path
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: sessionUser.token),
            URLQueryItem(name: "no_service_albums", value: "1"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        
        guard let url = urlConstructor.url else { preconditionFailure("Bad url")}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            
            print("Список фотографий!")
            print(json ?? "")
        }
        
        task.resume()
        
    }
}
