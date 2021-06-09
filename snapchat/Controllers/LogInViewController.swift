//
//  LogInViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 31/05/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButtonOutlet: UIButton!
    
    @IBAction func logInButton(_ sender: Any) {
        
        if let email = self.emailTextField.text {
            if let password = self.passwordTextField.text {
                
                // Authenticate user on Firebase:
                let authentication = Auth.auth()
                authentication.signIn(withEmail: email, password: password) { (user, error) in
                    
                    if error == nil {
                        
                        if user == nil {
                            self.displayMessage(title: "Error Authenticating", message: "Problem performing authentication.")
                        } else {
                            
                            // Redirect the user to the App main screen:
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                            
                        }
                        
                    } else {
                        self.displayMessage(title: "Incorrect Data", message: "Verify your data and try again.")
                    }
                    
                }
                
            }
        }
        
    }
    
    func displayMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButtonOutlet.layer.cornerRadius = 25
        logInButtonOutlet.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
