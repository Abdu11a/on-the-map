//
//  User.swift
//  On The Map
//
//  Created by Abdulla Aseed on 11/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation

struct UserData   : Codable {
    let firstName : String
    let lastName  : String
    let key       : String
    
    enum CodingKeys: String, CodingKey {
        case firstName  = "first_name"
        case lastName   = "last_name"
        case key
    }
}
