//
//  ViewController.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 14/06/2021.
//

import UIKit

class SignUpScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        let forgotPasswordTap = UITapGestureRecognizer(target: self, action: #selector(self.forgotButtonPressed));
//        forgotPasswordLabelButton?.isUserInteractionEnabled = true;
//        forgotPasswordLabelButton?.addGestureRecognizer(forgotPasswordTap);
    }
    
    
    @objc
    func forgotButtonPressed(sender:UITapGestureRecognizer) {
        performSegue(withIdentifier: "gotoForgotPassword", sender: self);
    }
    
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSignIn", sender: self)
    }
    
}

