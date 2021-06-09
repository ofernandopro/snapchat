//
//  SnapDetailsViewController.swift
//  snapchat
//
//  Created by Fernando Moreira on 09/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import SDWebImage

class SnapDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageSnap: UIImageView!
    @IBOutlet weak var descriptionSnap: UILabel!
    @IBOutlet weak var counterSnap: UILabel!
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(snap._description)
        
    }

}
