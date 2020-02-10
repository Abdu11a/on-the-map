//
//  UserLoginResponse.swift
//  On The Map
//
//  Created by Abdulla Aseed on 11/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation

struct UserLoginResponse: Codable {
    
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey { case account, session }
}

struct Account: Codable {
    let registered: Bool
    let key       : String
    
    enum CodingKeys: String, CodingKey { case registered, key }
}

struct Session: Codable {
    let id        : String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id, expiration
        
    }
}
