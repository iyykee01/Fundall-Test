//
//  SignInScreenViewController.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import UIKit

class SignInScreenViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 
    
    @IBAction func canelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
