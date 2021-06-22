//
//  DashboardViewController.swift
//  Fundall Test
//
//  Created by Cjay on 16/06/2021.
//

import UIKit
import Kingfisher
import SwiftyJSON
import KeychainAccess
import Alamofire

class DashboardViewController: UIViewController {
    
    var userData: UserData!
    
    let imagePicker = UIImagePickerController();
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print(userData.email, userData.firstname, userData.avatar)
      
        avatarImage.kf.setImage(with: URL(string: userData.avatar))
   
        imagePicker.delegate = self
    }
    
    
    
}

//Image camera delegate

extension DashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    //This will open image gallery
    func imageFromLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            avatarImage.image = image
            
            let resizedImage = AppMethods.shared.resizeImage(image: image, targetSize: CGSize(width: 320, height: 240));
            
            self.activityIndicator.startAnimating();
            imagePicker.dismiss(animated: true) {
                // Make sure you're on the main thread here
                self.writeImageToPath(image: resizedImage);
            };
            
        }
        else {
            print("No image found")
        }
    }
    
    
    func writeImageToPath(image: UIImage) {
        let fileName = "userImage.png"
        // get your UIImage jpeg data representation and check if the destination file url already exists
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(fileName)
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: fileURL, options: .atomic)
                Networking.shared.uploadRequestAlamofire { [self] (isSuccess, json) in
                    activityIndicator.stopAnimating();
                    view.isUserInteractionEnabled = true
                    if isSuccess {
                        print(json)
                        AlertView.showAlert(status: json["success"]["status"].stringValue, view: self, message: json["success"]["message"].stringValue) {
                            UserDefaults.standard.setValue(json["success"]["url"].stringValue, forKey: "avatarUrl");
                        }
                    }
                    else {
                        AlertView.showAlert(status: json["error"]["status"].stringValue, view: self, message: json["error"]["message"].stringValue) {}
                    }
                }
            }
        }
        catch {
            print("nil")
        }

    }
    
    
    
    
}



//Log out button method
extension DashboardViewController {
    
    //Should call api and remove Bearer token from storage.
    //But for now just performs a navigation back to welcome back screen
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


//upload avatarbutton method
extension DashboardViewController {
    
    //Create diaload box
    //Todo: - Put alert in AlertMessage class
    /*
     Should open a dialoag where user can either choose to use camera or upload from device
     */
    @IBAction func uploadAvartarButtonPressed(_ sender: Any) {
        let alertView = UIAlertController(title: "Select your avartar", message: "Take a picture or select from gallery", preferredStyle: .actionSheet);
        
        //Should open camera
        let openCamera = UIAlertAction(title: "Choose from camera", style: .default) { [self] (action) in
            print("camera should open")
            
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        
        
        //Should open device image folder
        let openGallery = UIAlertAction(title: "Choose from gallery", style: .default) { (action) in
            print("gallery should open")
            self.imageFromLibrary();
        }
        
        //Should open device image folder
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        
        alertView.addAction(openCamera)
        alertView.addAction(openGallery)
        alertView.addAction(cancel)
        
        present(alertView, animated: true);
    }
}





//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imagePicker.dismiss(animated: true) { [self] in
//                let imageResize = AppMethods.shared.resizeImage(image: image, targetSize: CGSize(width: 320, height: 240))
//
//                activityIndicator.startAnimating();
//                view.isUserInteractionEnabled = false
//                view.endEditing(true);
//                Networking.shared.uploadRequestAlamofire(parameters: ["avatar": imageResize.pngData()], imageData: imageResize.pngData()) { [self] (isSuccess, json) in
//
//                    activityIndicator.stopAnimating();
//                    view.isUserInteractionEnabled = true
//                    if isSuccess {
//
//                        AlertView.showAlert(status: json["success"]["status"].stringValue, view: self, message: json["success"]["message"].stringValue) {
//                            performSegue(withIdentifier: "goToSignIn", sender: self)
//                        }
//                    }
//                    else {
//                        AlertView.showAlert(status: json["error"]["status"].stringValue, view: self, message: json["error"]["message"].stringValue) {}
//                    }
//                }
//            }
//        }
//        else {
//            print("Error")
//            dismiss(animated: true)
//        }
//    }

