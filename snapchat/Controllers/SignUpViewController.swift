//
//  SignUpViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 31/05/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.backgroundColor = UIColorFromRGB(rgbValue: 0xefefef)
            emailTextField.textColor = .black
            //emailTextField.layer.borderColor = .init(srgbRed: 239, green: 239, blue: 239, alpha: 1)
            emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if let email = self.emailTextField.text {
            if let password = self.passwordTextField.text {
                if let confirmPassword = self.confirmPasswordTextField.text {
                    
                    // Validate Password
                    if password == confirmPassword {
                        
                        // Create account on Firebase
                        let authentication = Auth.auth()
                        authentication.createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error == nil {
                                
                                if user == nil {
                                    self.displayMessage(title: "Error Authenticating", message: "Problem performing authentication.")
                                } else {
                                    // Redirect the user to the App main screen:
                                    //self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                }
                                
                            } else {
                                //print(error ?? "")
                                /* Types os errors:
                                 ERROR_INVALID_EMAIL
                                 ERROR_WEAK_PASSWORD
                                 ERROR_EMAIL_ALREADY_IN_USE
                                 */
                                let retrievedError = error! as NSError
                                if let errorCode = retrievedError.userInfo["error_name"] {
                                    
                                    let errorText = errorCode as! String
                                    var errorMessage = ""
                                    
                                    switch errorText {
                                    case "ERROR_INVALID_EMAIL":
                                        errorMessage = "Invalid Email, type a valid one."
                                        break
                                    case "ERROR_WEAK_PASSWORD":
                                        errorMessage = "Your password should have at least 6 caracters, with letters and numbers."
                                        break
                                    case "ERROR_EMAIL_ALREADY_IN_USE":
                                        errorMessage = "This email is already in use, use another one."
                                        break
                                    default:
                                        errorMessage = "Data entered are incorrect."
                                    }
                                    
                                    self.displayMessage(title: "Invalid Data", message: errorMessage)
                                }
                                
                            }
                            
                        })
                        
                    } else {
                        self.displayMessage(title: "Incorrect Data",
                                            message: "The passwords are not the same. Please, type again.")
                    } // End validating password
                    
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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
