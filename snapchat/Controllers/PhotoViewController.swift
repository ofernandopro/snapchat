//
//  PhotoViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 02/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseStorage

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var idImage = NSUUID().uuidString
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextStepAction(_ sender: Any) {
        
        let _storage = Storage.storage().reference()
        let images = _storage.child("images")
        
        // Retrieve image:
        if let selectedImage = image.image {
            if let imageData = selectedImage.jpegData(compressionQuality: 0.5){
                
                images.child("\(self.idImage).jpg").putData(imageData, metadata: nil) { (metaData, error) in
                    
                    if error == nil {
                        print("sucesso ao fazer upload do arquivo\n\n")
                        
                        let imageName = metaData?.dictionaryRepresentation()["name"] as! String
                        let starsRef = _storage.child(imageName)
                        // Fetch the download URL:
                        starsRef.downloadURL { (url, erro) in
                            if let erro = erro {
                                print(erro)
                            } else {
                                if let urlString = url {
                                    self.performSegue(withIdentifier: "selectUserSegue", sender: urlString.absoluteString)
                                }
                            }
                        }
                        
                        
                    } else {
                        let alert = Alert(title: "Upload failed", message: "Erro saving file, try again.")
                        self.present(alert.getAlert(), animated: true, completion: nil)
                    }
                    
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectUserSegue" {
            
            let userViewController = segue.destination as! UsersTableViewController
            
            userViewController.descriptionSnap = self.descriptionTextField.text!
            userViewController.urlImage = sender as! String
            userViewController.idImage = self.idImage
            
        }
        
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        
        /* ---- Para mudar para a camera, basta substituir o .savedPhotosAlbum na linha abaixo para .camera
            Não fizemos isso porque se colocarmos .camera, só vai funcionar no próprio dispositivo e não no simulador.
        */
        
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Enable the next Button:
        nextButton.isEnabled = true
        nextButton.tintColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        
        let retrievedImage = info[ UIImagePickerController.InfoKey.originalImage ] as! UIImage
        image.image = retrievedImage
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 25
        nextButton.clipsToBounds = true
        // Disable the next Button:
        nextButton.isEnabled = false
        nextButton.tintColor = UIColor.gray
        
        imagePicker.delegate = self
    }

}
