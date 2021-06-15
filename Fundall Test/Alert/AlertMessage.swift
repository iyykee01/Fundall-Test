//
//  AlertMessage.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import Foundation
import UIKit

class AlertMessage {
    
    static let shared = AlertMessage()
    
    func alertPop (status: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: status, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    }
}
