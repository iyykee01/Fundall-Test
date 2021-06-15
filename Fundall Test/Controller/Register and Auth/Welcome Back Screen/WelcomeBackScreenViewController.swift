//
//  WelcomeBackScreenViewController.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import UIKit

class WelcomeBackScreenViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var missYouText: UILabelDeviceClass!
    @IBOutlet weak var emailText: UILabelDeviceClass!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountText: UILabelDeviceClass!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUiForAttributedText()
    }
    
    
    // Setting up UI for attributedText in view controller
    func setupUiForAttributedText()  {
        
        let normalText = "New here? "

        let boldText  = "Create Account"

        let attributedString = NSMutableAttributedString(string:normalText)

        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)

        attributedString.append(boldString)
        
        createAccountText.attributedText = attributedString
        
        
        let createAccountTap = UITapGestureRecognizer(target: self, action: #selector(self.createAccountTextPressed));
        createAccountText?.isUserInteractionEnabled = true;
        createAccountText?.addGestureRecognizer(createAccountTap);
        
        
    }
    
    @objc
    func createAccountTextPressed(sender:UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func showPasswordButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
}
