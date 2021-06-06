//
//  ViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 31/05/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authentication = Auth.auth()
        authentication.addStateDidChangeListener { (authentication, user) in
            
            if let loggedUser = user {
                self.performSegue(withIdentifier: "automaticLoginSegue", sender: nil)
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

