//
//  profileViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 5/12/2021.
//

import UIKit
import SwiftyJSON
import PhotosUI

class profileViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmpasswordTF: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var prenom: UILabel!
    @IBOutlet weak var nom: UILabel!
   
    
    var imagePicker = UIImagePickerController()
    var libraryPicker: PHPickerViewController?

    
    let token = UserDefaults.standard.string(forKey: "token")!
    let nomConnected = UserDefaults.standard.string(forKey: "nom")!
    let prenomConnected = UserDefaults.standard.string(forKey: "prenom")!

    let _id = UserDefaults.standard.string(forKey: "_id")!
    
    

    var user : userModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.borderWidth = 10
            profileImage.layer.masksToBounds = false
            profileImage.layer.borderColor = UIColor(red:18/255, green:19/255, blue:38/255, alpha: 1).cgColor
            profileImage.layer.cornerRadius = profileImage.frame.height/2
        bgImage.layer.cornerRadius = bgImage.frame.height/2
            profileImage.clipsToBounds = true
        
    
     intialiseProfile()
        prenom.text = prenomConnected
        nom.text = nomConnected
        print(_id)
        setupLibrary()

        

        // Do any additional setup after loading the view.
    }
    
    func intialiseProfile() {
        print("initializing profile")

        UserService.shareinstance.getProfile(_id: _id,completionHandler: {
            isSuccess, user in
            if isSuccess{
                
                self.user = user
                self.usernameTF.text = self.user?.nom
                self.emailTF.text = self.user?.email
                print(self.user)
            }
        })
                                           
    }
   
    
    @IBAction func signOut(_ sender: Any) {
      
        UserDefaults.standard.setValue("", forKey: "token")
        UserDefaults.standard.setValue("", forKey: "_id")
        UserDefaults.standard.setValue("", forKey: "nom")
        performSegue(withIdentifier: "signInSegue2", sender: nil)
        
    }
    
    func showAlert(title:String, message:String){
                  let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
                  let action = UIAlertAction(title:"ok", style: .cancel, handler:nil)
                  alert.addAction(action)
                  self.present(alert, animated: true, completion: nil)

}
    
    
    @IBAction func confirmUpdate(_ sender: Any) {
        let nom =  usernameTF.text
        let email = emailTF.text
        let password = passwordTF.text
        let confirmPassword = confirmpasswordTF.text
        print("testttttttt")
        print(_id)
   
        let user = userModel(_id:"",nom: nom, prenom: "", email: email, password: password,gender: "", age: "", weight: "", height: "",   experience: "", goal: "", token: "")
        if( nom!.isEmpty || email!.isEmpty || password!.isEmpty){
                   showAlert(title: "Warning", message: "Please make sure to fill out all the form before registering")
                   return
               }else
        if (!(confirmPassword! == password)){
                    showAlert(title: "Failure", message: "Password do not match")
                   return
                                }
        UserService.shareinstance.updateProfile(_id: _id, user: user,completionHandler:{
                   (isSuccess) in
                   if isSuccess{
                    
                       self.performSegue(withIdentifier: "homeSegue4", sender: IndexPath.self)

                   } else {
                       self.showAlert(title: "Failre", message: "Please try again")
                   }
               })
    }
    

    @IBAction func cancelUpdate(_ sender: Any) {
        
    }
    
    
    
   
    @IBAction func changeProfilePic(_ sender: Any) {
        present(libraryPicker!, animated: true, completion: nil)
        
        
    }
    
   
    
    @IBAction func changeBgPic(_ sender: Any) {
        present(libraryPicker!, animated: true, completion: nil)
    }
    
}

extension profileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 /*
    func setupCamera() {
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    func checkCamera() {
        camerabtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            setupCamera()
        }
    }
    */
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profileImage.image = image
            self.bgImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension profileViewController:  PHPickerViewControllerDelegate {
    
    func setupLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        libraryPicker = PHPickerViewController(configuration: configuration)
        libraryPicker!.delegate = self
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if let first = results.first {
            let newItem = first.itemProvider
            if newItem.canLoadObject(ofClass: UIImage.self) {
                newItem.loadObject(ofClass: UIImage.self) { image, error in
                    if let newImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self.profileImage.image = newImage
                            self.bgImage.image = newImage
                        }
                    }
                }
            }
        }
    }

}
