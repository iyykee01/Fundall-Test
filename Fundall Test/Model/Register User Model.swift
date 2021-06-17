//
//  Register User Model.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import Foundation

struct RegisterUser: Encodable {
    
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var password_confirmation: String

}



struct LoginUser: Encodable {
    var email: String
    var password: String
}


struct UserData: Encodable {
    var email: String
    var expires_at: String
    var id: String
    var monthly_target: String
    var updated_at: String
    var lastname: String
    var created_at: String
    var firstname: String
    var avatar: String
}



struct UploadAvartar: Codable {
    var avatar: Data
}

