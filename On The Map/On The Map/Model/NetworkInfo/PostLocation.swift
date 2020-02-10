//
//  PostLocation.swift
//  On The Map
//
//  Created by Abdulla Aseed on 11/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation
struct PostLocation   : Codable {
    let uniqueKey     : String
    let firstName     : String
    let lastName      : String
    let mapString     : String
    let mediaURL      : String
    let latitude      : Float
    let longitude     : Float
}
