//
//  UserSession.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 07.02.2019.
//  Copyright © 2019 Ирина. All rights reserved.
//

import Foundation

class UserSession {
    
    static let instance = UserSession()
    
    private init(){}
    
    var token: String = ""
    var userId: Int = 0
}
