//
//  UsersTableViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 07/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsersTableViewController: UITableViewController {
    
    var users: [User] = []
    var urlImage = ""
    var descriptionSnap = ""
    var idImage = ""
    
    
    @IBAction func sendButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database = Database.database().reference()
        let users = database.child("users")
        
        // Retrieve all users
        users.observe(DataEventType.childAdded) { (snapshot) in
            
            let data = snapshot.value as? NSDictionary
            
            // Retireve logged user data
            let authentication = Auth.auth()
            let idLoggedUser = authentication.currentUser?.uid
            
            // Retieve data:
            let userEmail = data?["email"] as! String
            let userName = data?["name"] as! String
            let userId = snapshot.key
            
            let user = User(email: userEmail, name: userName, uid: userId)
            
            // Add user to array if not equal to the logged user
            if userId != idLoggedUser {
                self.users.append(user)
            }
            self.tableView.reloadData()
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = self.users[indexPath.row]
        let idSelectedUser = selectedUser.uid
        
        // Retrieves database reference
        let database = Database.database().reference()
        let users = database.child("users")
        let snaps = users.child(idSelectedUser).child("snaps")
        
        // Retrieve logged user data
        let authentication = Auth.auth()
        
        if let idLoggedUser = authentication.currentUser?.uid {
            
            let loggedUser = users.child(idLoggedUser)
            loggedUser.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                let data = snapshot.value as? NSDictionary
                
                let snap = [
                    "from": data?["email"] as! String,
                    "name": data?["name"] as! String,
                    "description": self.descriptionSnap,
                    "urlImage": self.urlImage,
                    "idImage": self.idImage
                ]
                
                snaps.childByAutoId().setValue(snap)
                
                
            })
            
        }
        
    }

}
