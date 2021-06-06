//
//  SnapsViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 02/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class SnapsViewController: UIViewController {

    
    @IBAction func logOutButton(_ sender: Any) {
        
        let authentication = Auth.auth()
        do {
            try authentication.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Error trying to log out user.")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
