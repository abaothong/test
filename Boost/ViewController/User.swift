//
//  User.swift
//  Boost
//
//  Created by Thong Hao Yi on 18/02/2020.
//  Copyright © 2020 Abao. All rights reserved.
//

import UIKit

struct User: Codable {
    
    let id: String
    let firstName: String
    let lastName: String
    let email: String?
    let phone: String?
}
