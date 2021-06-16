//
//  ViewController.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 14/06/2021.
//

import UIKit
import SwiftyJSON
import KeychainAccess

class SignUpScreen: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField?
    @IBOutlet weak var lastNameTextField: UITextField?
    @IBOutlet weak var EmailTextField: UITextField?
    @IBOutlet weak var phoneNumberTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var termsAndConditionsLabel: UILabelDeviceClass!
    @IBOutlet weak var attributedTextForLogin: UILabelDeviceClass!
    @IBOutlet weak var signupButton: UIButton!
    
    var viewJumpHeight: CGFloat = -50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUiForAttributedText()
    }
    
    // Setting up UI for attributedText in view controller
    func setupUiForAttributedText()  {
        
        firstNameTextField?.setLeftPaddingPoints(16)
        lastNameTextField?.setLeftPaddingPoints(16)
        EmailTextField?.setLeftPaddingPoints(16)
        phoneNumberTextField?.setLeftPaddingPoints(16)
        passwordTextField?.setLeftPaddingPoints(16)
        
        phoneNumberTextField?.delegate = self
        passwordTextField?.delegate = self
        
        addInputAccessoryForTextFields(textFields: [firstNameTextField!, lastNameTextField!, EmailTextField!, phoneNumberTextField!, passwordTextField!], dismissable: true, previousNextable: true);

        
        //Allows tap on a  given string
        let loginTextTap = UITapGestureRecognizer(target: self, action: #selector(self.loginTextPressed));
        attributedTextForLogin?.isUserInteractionEnabled = true;
        attributedTextForLogin?.addGestureRecognizer(loginTextTap);
        
    
    }
    

    @objc func loginTextPressed(sender:UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToWelcomeBack", sender: self);
    }
    
    //Method is added to the "Done" tabItem button
    @objc func donePicker(datePicker: UIDatePicker) {
        view.endEditing(true);
        view.frame.origin.y = 0
    }
    
    
    //Stop listening for keyboard hide/show events//////
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}


//Handle Text Field delegates
extension SignUpScreen: UITextFieldDelegate {

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
        print(textField.tag)
        if textField.tag == 4 {
            view.frame.origin.y = CGFloat(viewJumpHeight)
        }
        if textField.tag == 5 {
            view.frame.origin.y = CGFloat(viewJumpHeight)
        }

    }
}


//Handle button clicked and registring user
extension SignUpScreen {
    //This submits text field when signup button is pressed
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating();
        view.isUserInteractionEnabled = false
        view.endEditing(true);
        signupButton.isHidden = true
        
        //Register user with user model
        let registerUser = RegisterUser(firstname: firstNameTextField?.text ?? "", lastname: lastNameTextField?.text ?? "", email: EmailTextField?.text ?? "", password: passwordTextField?.text ?? "", password_confirmation: passwordTextField?.text ?? "")
        
        Networking.shared.registerUser(path: "/api/v1/register", register: registerUser) { [self] (isSuccess, json) in
            activityIndicator.stopAnimating();
            view.isUserInteractionEnabled = true
            signupButton.isHidden = false
            
            if isSuccess {
                
                //Storing data with user default
                UserDefaults.standard.setValue(firstNameTextField?.text, forKey: "userName");
                UserDefaults.standard.setValue(EmailTextField?.text, forKey: "email");
            
                //Storing our password in keychain for Apple's protection and verification process
                let keychain = Keychain(service: "com.fundall.test.Fundall-Test")
                keychain["userPassword"] = passwordTextField?.text
                
                
                AlertView.showAlert(status: json["success"]["status"].stringValue, view: self, message: json["success"]["message"].stringValue) {
                    performSegue(withIdentifier: "goToSignIn", sender: self)
                }
            }
            else {
                AlertView.showAlert(status: json["error"]["status"].stringValue, view: self, message: json["error"]["message"].stringValue) {}
            }
        }
        
    }
}


extension SignUpScreen {
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let doneButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItem.Style.done, target: self, action: nil);
                if textField == textFields.first {
                    doneButton.isEnabled = false
                } else {
                    doneButton.target = textFields[index - 1]
                    doneButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: nil);

                if textField == textFields.last {
                    //nextButton.isEnabled = false
                    nextButton.title = "Done"
                    nextButton.action = #selector(self.donePicker)
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                items.append(contentsOf: [doneButton, spacer, nextButton])
            }
            
            toolbar.barTintColor = UIColor(hexFromString: "#4CE895");
            toolbar.tintColor = UIColor(hexFromString: "#222233");
            toolbar.isUserInteractionEnabled = true;
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
}


