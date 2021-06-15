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
