//
//  ViewController.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 14/06/2021.
//

import UIKit
import SwiftyJSON

class SignUpScreen: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField?
    @IBOutlet weak var lastNameTextField: UITextField?
    @IBOutlet weak var EmailTextField: UITextField?
    @IBOutlet weak var phoneNumberTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    
    //This submits text field when signup button is pressed
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        let registerUser = RegisterUser(firstname: firstNameTextField?.text ?? "", lastname: lastNameTextField?.text ?? "", email: EmailTextField?.text ?? "", password: passwordTextField?.text ?? "", password_confirmation: passwordTextField?.text ?? "")
        
        Networking.shared.registerUser(path: "/api/v1/register", register: registerUser) { [self] (isSuccess, json) in
            activityIndicator.stopAnimating();
            if isSuccess {
                let alert = AlertMessage.shared.alertPop(status: json["error"]["status"].stringValue, message: json["error"]["message"].stringValue)
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                print(json)
            }
        }
        //performSegue(withIdentifier: "goToSignIn", sender: self)
    }
    
}

