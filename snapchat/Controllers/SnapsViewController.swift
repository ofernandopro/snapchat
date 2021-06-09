//
//  SnapsViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 02/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var snaps: [Snap] = []
    
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
        
        let authentication = Auth.auth()
        
        if let idUserLogged = authentication.currentUser?.uid {
            
            let database = Database.database().reference()
            let users = database.child("users")
            let snaps = users.child(idUserLogged).child("snaps")
            
            // Create listener for Snaps
            snaps.observe(DataEventType.childAdded, with: { (snapshot) in
                
                let data = snapshot.value as? NSDictionary
                
                let snap = Snap()
                snap._id = snapshot.key
                snap._name = data?["name"] as! String
                snap._description = data?["description"] as! String
                snap._urlImage = data?["urlImage"] as! String
                snap._idImage = data?["idImage"] as! String
                
                self.snaps.append(snap)
                self.tableView.reloadData()
                
            })
            
            // Adds event for removed item:
            snaps.observe(DataEventType.childRemoved) { (snapshot) in
                
                var index = 0
                for snap in self.snaps {
                    if snap._id == snapshot.key {
                        self.snaps.remove(at: index)
                    }
                    index = index + 1
                }
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        height = 70
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalSnaps = self.snaps.count
        if totalSnaps == 0 {
            return 1
        }
        return totalSnaps
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let totalSnaps = self.snaps.count
        if totalSnaps == 0 {
            cell.textLabel?.text = "You don't have any snap yet!"
        } else {
            let snap = self.snaps[indexPath.row]
            cell.textLabel?.text = snap._name
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "snapDetailsSegue", sender: snap)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "snapDetailsSegue" {
            
            let snapDetailsViewController = segue.destination as! SnapDetailsViewController
            
            snapDetailsViewController.snap = sender as! Snap
            
        }
        
    }
    
    
    
    
    
    

}
