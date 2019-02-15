//
//  VKLoginViewController.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 07.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import UIKit
import WebKit

class VKLoginViewController: UIViewController {

    @IBOutlet weak var vkWebView: WKWebView!{
        didSet {
            vkWebView.navigationDelegate = self
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6850391"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("Bad url for oauth.vk.com") }
        
        let request = URLRequest(url: url)
        
        vkWebView.load(request)
    }
}

    extension VKLoginViewController: WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            
            guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
                decisionHandler(.allow)
                return
            }
            
            let params = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce([String: String]()) { result, param in
                    var dict = result
                    let key = param[0]
                    let value = param[1]
                    dict[key] = value
                    return dict
            }
            
            let token = params["access_token"]
            let session = UserSession.instance
            session.token = token ?? ""
            print(token ?? "")
//            let friends = FriendsService()
//            friends.sendRequest()
//            let photo =  FotoService()
//            photo.sendRequest()
//            let groups = GroupsService()
//            groups.sendRequest()
            let search = SearchGroupsService()
            search.sendRequest()
            performSegue(withIdentifier: "VKClient", sender: nil)
            
            decisionHandler(.cancel)
        }
    }

