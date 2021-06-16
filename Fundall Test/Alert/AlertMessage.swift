//
//  AlertMessage.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import Foundation
import UIKit

//Custom Alert for all view
class AlertView: NSObject {

    static let shared = AlertView()
    
    class func showAlert(status: String, view: UIViewController , message: String, completion: @escaping() -> ()) {
        let alert = UIAlertController(title: status, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
        
        completion()
    }
}
