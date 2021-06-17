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
import KeychainAccess

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
    
    
    
    //Login User network call
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
    
    
    func uploadRequestAlamofire(parameters: [String: Data?], imageData: Data?, completion: @escaping(Bool, JSON) -> ()) {
        
        let url = "https://campaign.fundall.io/api/v1/base/avatar"
        let keychain = Keychain(service: "com.fundall.test.Fundall-Test")
        let getToken = keychain["accessToken"]!
        
        let headers: HTTPHeaders = ["X-User-Agent": "ios",
                                    "Accept-Language": "en",
                                    "Accept": "application/json",
                                    "Content-type": "multipart/form-data",
                                    "Authorization": "Bearer \(getToken)"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, val) in parameters {
                multipartFormData.append("\(val)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData {
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/jpg")
            }
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers)
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


