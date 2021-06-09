//
//  User.swift
//  snapchat
//
//  Created by Fernando Moreira on 07/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import Foundation

class User {
    
    var email: String
    var name: String
    var uid: String
    
    init(email: String, name: String, uid: String) {
        self.email = email
        self.name = name
        self.uid = uid
    }
    
}
