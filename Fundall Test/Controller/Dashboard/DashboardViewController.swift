//
//  DashboardViewController.swift
//  Fundall Test
//
//  Created by Cjay on 16/06/2021.
//

import UIKit
import Kingfisher
import SwiftyJSON

class DashboardViewController: UIViewController {
    
    var userData: UserData!
    
    let imagePicker = UIImagePickerController();
    @IBOutlet weak var avatarImage: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(userData.email, userData.firstname, userData.avatar)
        

        avatarImage.kf.setBackgroundImage(with: userData.avatar as? Resource, for: .normal)

        
        imagePicker.delegate = self
    }
    
    //This function will help reducde image size
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
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
            imagePicker.dismiss(animated: true) { [self] in
                let imageResize = self.resizeImage(image: image, targetSize: CGSize(width: 320, height: 240))
                
                activityIndicator.startAnimating();
                view.isUserInteractionEnabled = false
                view.endEditing(true);
                Networking.shared.uploadRequestAlamofire(parameters: ["avatar": imageResize.pngData()], imageData: imageResize.pngData()) { [self] (isSuccess, json) in
                    
                    activityIndicator.stopAnimating();
                    view.isUserInteractionEnabled = true
                    if isSuccess {
                      
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
        else {
            print("Error")
            dismiss(animated: true)
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

