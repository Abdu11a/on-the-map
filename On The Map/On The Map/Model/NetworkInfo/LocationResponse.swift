//
//  LocationResponse.swift
//  On The Map
//
//  Created by Abdulla Aseed on 11/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation

struct PostLocationResponse: Codable {
    let createAt  : String
    let objectId  : String
    
    enum CodingKeys : String, CodingKey {
        case createAt
        case objectId
    }
}

struct PutLocationResponse: Codable {
    let updatedAt : String
}
