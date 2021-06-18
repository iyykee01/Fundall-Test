//
//  SignInScreenViewController.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import UIKit
import LocalAuthentication
import KeychainAccess

class SignInScreenViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabelDeviceClass!
    @IBOutlet weak var switchAccountLabel: UILabelDeviceClass!
    @IBOutlet weak var createAccountLabel: UILabelDeviceClass!
    
    var userData: UserData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI();
    }
    
    
    func setupUI() {
        
        //Getting user name from UserDefault
        let name = UserDefaults.standard.string(forKey: "userName")!
        nameLabel.text = "\(String(describing: name))'s lifestyle"
        
        //Allows tap on creat account Label
        let createTextTap = UITapGestureRecognizer(target: self, action: #selector(self.createTextPressed));
        createAccountLabel.isUserInteractionEnabled = true;
        createAccountLabel.addGestureRecognizer(createTextTap);
    }
    
    
    //This will handle login in with face or fingerprint
    func login() {
            //Api call here
            let context: LAContext = LAContext()
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login to Voguepay Digital") { (success, nil) in
                    
                    if success {
                        DispatchQueue.main.async {
                            self.userLogin()
                        }
                    }
                    else {
                        AlertView.showAlert(status: "Error", view: self, message: "Error login in with biometrics") {}
                    }
                }
            }
            else {
                print("Biometrics not supported. Please enter you password")
            }
            
            
        }
 
    
    @objc func createTextPressed(sender:UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //Method to user login
    func userLogin() {
        view.isUserInteractionEnabled = false
        view.endEditing(true);
        
        //Login user with data stored
        let email = UserDefaults.standard.string(forKey: "email")!
        
        //Getting data from keychain
        let keychain = Keychain(service: "com.fundall.test.Fundall-Test")
        let password = keychain["userPassword"]!
        
        let loginDetials = LoginUser(email: email, password: password)
        print(loginDetials)
        
        Networking.shared.loginUserApi(path: "/api/v1/login", login: loginDetials) { [self] (isSuccess, json) in
            view.isUserInteractionEnabled = true
            
            if isSuccess {
                //print(json)
                AlertView.showAlert(status: json["success"]["status"].stringValue, view: self, message: json["success"]["message"].stringValue) {
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
            }
            else {
                AlertView.showAlert(status: json["error"]["status"].stringValue, view: self, message: json["error"]["message"].stringValue) {}
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDashBoard" {
            let destination = segue.destination as! DashboardViewController
            destination.userData = userData
        }
        
    }

   
}

extension SignInScreenViewController {
    
    @IBAction func passwordButtonPressed(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "welcomeBack") as? WelcomeBackScreenViewController
                self.navigationController?.pushViewController(vc!, animated: true);
    }
    
    @IBAction func biometricsButtonPressed(_ sender: Any) {
        login();
    }
}
