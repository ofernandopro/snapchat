//
//  Alert.swift
//  snapchat
//
//  Created by Fernando Moreira on 03/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit

class Alert {
    
    var title: String
    var message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    func getAlert() -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
}
