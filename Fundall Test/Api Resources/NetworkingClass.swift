//
//  NetworkingClass.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import Foundation


import UIKit
import Alamofire
import SwiftyJSON

class Networking {
    
    /*:
     Created a static variable instanciating the Networking class
     */
    static let shared = Networking()
    
    private let baseURL = "https://campaign.fundall.io"
    private let token = ""
 
    
    
    //Register user
    //Post request to register a user with User model @Model
    func registerUser(path: String, register: RegisterUser, completion: @escaping(Bool, JSON) -> ()) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let registerUrl = baseURL + path
        
        AF.request(registerUrl, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers)
            .response { response in
                //debugPrint(response)
                switch response.result {
                
                case .success(let data):
                    do {
                        let json = JSON(data!)
                        if response.response?.statusCode == 200 {
                            completion(true, json)
                         
                        }
                        else {
                           completion(false, json)
                        }
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(false, [])
                }
                
            }
    }
    
    
    
    //Login User
    func loginUserApi(path: String, login: LoginUser, completion: @escaping(Bool, JSON) -> ()) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let registerUrl = baseURL + path
        
        AF.request(registerUrl, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers)
            .response { response in
                //debugPrint(response)
                switch response.result {
                
                case .success(let data):
                    do {
                        let json = JSON(data!)
                        if response.response?.statusCode == 200 {
                            completion(true, json)
                         
                        }
                        else {
                           completion(false, json)
                        }
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(false, [])
                }
                
            }
    }
    
}


