//
//  WelcomeBackScreenViewController.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import UIKit
import KeychainAccess
import Kingfisher

class WelcomeBackScreenViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var missYouText: UILabelDeviceClass!
    @IBOutlet weak var emailText: UILabelDeviceClass!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountText: UILabelDeviceClass!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var passwordIsHidden = true
    var viewJumpHeight: CGFloat = -50
    var userData: UserData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField.delegate = self
        setupUiForAttributedText()
    }
    
    
    // Setting up UI for attributedText in view controller
    func setupUiForAttributedText()  {
        
        //check if user avarta exist and display avarta
        let avatarUrl = UserDefaults.standard.object(forKey: "avatarUrl");
        
        if avatarUrl != nil {
            avatarImage.kf.setImage(with: URL(string: avatarUrl as! String))
        }
        
        
        
        //Getting user name from UserDefault
        
        var  name = UserDefaults.standard.object(forKey: "userName")
        var  email = UserDefaults.standard.object(forKey: "email")
        
        if UserDefaults.standard.object(forKey: "email") != nil && UserDefaults.standard.object(forKey: "userName") != nil {
            //Key exists
            email = UserDefaults.standard.string(forKey: "email")!
            name = UserDefaults.standard.string(forKey: "userName")!
            
            missYouText.text = "We miss you, \(name ?? "")"
            emailText.text = email as? String
        }
       
        let normalText = "New here? "

        let boldText  = "Create Account"

        let attributedString = NSMutableAttributedString(string:normalText)

        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)]
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
    
    
    //Stop listening for keyboard hide/show events//////
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
}

//This extension handle showing of password in plain text
extension WelcomeBackScreenViewController {
    @IBAction func showPasswordButtonPressed(_ sender: Any) {
        passwordIsHidden.toggle()
        
        if !passwordIsHidden {
            passwordTextField.isSecureTextEntry = false
        }
        else {
            passwordTextField.isSecureTextEntry = true
        }
    }
}

//This extension handles login the user
extension WelcomeBackScreenViewController {
    @IBAction func loginButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating();
        view.isUserInteractionEnabled = false
        view.endEditing(true);
        loginButton.isHidden = true
        
        //Login user with data stored
        var email = ""
        
        if UserDefaults.standard.object(forKey: "email") != nil {
            email = UserDefaults.standard.string(forKey: "email")!
        }
        let password = passwordTextField.text!
        
        let loginDetials = LoginUser(email: email, password: password)
        print(loginDetials)
        
        Networking.shared.loginUserApi(path: "/api/v1/login", login: loginDetials) { [self] (isSuccess, json) in
            view.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
            loginButton.isHidden = !true
            
            if isSuccess {
                print(json)
                
                UserDefaults.standard.setValue(json["success"]["user"]["avatar"].stringValue, forKey: "avatarUrl");
            
                //Storing our password in keychain for Apple's protection and verification process
                let keychain = Keychain(service: "com.fundall.test.Fundall-Test")
                keychain["accessToken"] = json["success"]["user"]["access_token"].stringValue
                
                self.userData = UserData(
                    email: json["success"]["user"]["email"].stringValue,
                    expires_at: json["success"]["user"]["expires_at"].stringValue,
                    id: json["success"]["user"]["id"].stringValue,
                    monthly_target: json["success"]["user"]["monthly_target"].stringValue,
                    updated_at: json["success"]["user"]["updated_at"].stringValue,
                    lastname: json["success"]["user"]["lastname"].stringValue,
                    created_at: json["success"]["user"]["created_at"].stringValue,
                    firstname: json["success"]["user"]["firstname"].stringValue,
                    avatar: json["success"]["user"]["avatar"].stringValue
                    )
                performSegue(withIdentifier: "goToDashBoard", sender: self)
                
            }
            else {
                AlertView.showAlert(status: json["error"]["status"].stringValue, view: self, message: json["error"]["message"].stringValue) {}
            }
        }
    }
}


//passing data between view controllers
extension WelcomeBackScreenViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDashBoard" {
            let destination = segue.destination as! DashboardViewController
            destination.userData = userData
        }
        
    }
}


//Handling textfield delegate method
extension WelcomeBackScreenViewController: UITextFieldDelegate {

    //*********Make view move up when keyboard shows**********//
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        view.frame.origin.y = 0
        return false
    }

    //Move view up when text fields are focused
    @objc func keyboardwillChange(notification: Notification) {
        
        guard   let userInfo = notification.userInfo as? [String: NSObject],
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect  else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification  {
            view.frame.origin.y = -keyboardFrame.height / 2
        }
        else {
            view.frame.origin.y = 0
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        view.frame.origin.y = CGFloat(viewJumpHeight)
    }
}
