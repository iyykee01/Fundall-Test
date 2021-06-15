//
//  ViewController.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 14/06/2021.
//

import UIKit

class SignUpScreen: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var attributedTextForLogin: UILabelDeviceClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        setupUiForAttributedText()
    }
    
    // Setting up UI for attributedText in view controller
    func setupUiForAttributedText()  {
        
        let normalText = "Already a member? "

        let boldText  = "Log In"

        let attributedString = NSMutableAttributedString(string:normalText)

        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)

        attributedString.append(boldString)
        
        attributedTextForLogin.attributedText = attributedString
        
        
        let loginTextTap = UITapGestureRecognizer(target: self, action: #selector(self.loginTextPressed));
        attributedTextForLogin?.isUserInteractionEnabled = true;
        attributedTextForLogin?.addGestureRecognizer(loginTextTap);
        
        
    }
    

    @objc
    func loginTextPressed(sender:UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToWelcomeBack", sender: self);
    }
    
    

    
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSignIn", sender: self)
    }
    
}

