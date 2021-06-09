//
//  SnapDetailsViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 09/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SnapDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageSnap: UIImageView!
    @IBOutlet weak var descriptionSnap: UILabel!
    @IBOutlet weak var counterSnap: UILabel!
    
    var snap = Snap()
    var time = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionSnap.text = ""
        
        let url = URL(string: snap._urlImage)
        imageSnap.sd_setImage(with: url) { (image, error, cache, url) in
            
            if error == nil {
                
                self.descriptionSnap.text = self.snap._description
                
                // Initialize timer:
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                    
                    // Decrement time:
                    self.time = self.time - 1
                    
                    // Display timer on screen:
                    self.counterSnap.text = String(self.time)
                    
                    // When the timer reaches 0, it stops
                    if self.time == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let authentication = Auth.auth()
        
        if let idLoggedUser = authentication.currentUser?.uid {
            
            // Delete nodes from database
            let database = Database.database().reference()
            let users = database.child("users")
            
            let snaps = users.child(idLoggedUser).child("snaps")
            
            snaps.child(snap._id).removeValue()
            
            // Delete snap image
            let storage = Storage.storage().reference()
            let images = storage.child("images")
            
            
            images.child("\(snap._idImage).jpg").delete { (error) in
                
                if error == nil {
                    print("Success deleting image")
                } else {
                    print("Error deleting image")
                }
                
            }
            
            
        }
        
    }

}
