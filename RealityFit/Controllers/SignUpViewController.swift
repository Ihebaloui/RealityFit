//
//  SignUpViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 3/12/2021.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var currentPhoto : UIImage?

       @IBOutlet weak var photoUser: UIImageView!
    
    @IBOutlet weak var nomtextField: UITextField!
    
    @IBOutlet weak var prenomTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordtextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if reachability.connection == .unavailable {
            print("jawek mesh behy")
            self.showAlert(title: "Connectivity Problem", message: "Please check your internet connection ")
        }else
      {  initializeHideKeyboard()
        nomtextField.attributedPlaceholder = NSAttributedString(
            string: "nom",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        prenomTextField.attributedPlaceholder = NSAttributedString(
            string: "prenom",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
       confirmPasswordtextField.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(
             string: "Email",
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        
        
        
            photoUser.layer.masksToBounds = false
            photoUser.layer.borderColor = UIColor(red:18/255, green:19/255, blue:38/255, alpha: 1).cgColor
            photoUser.layer.cornerRadius = photoUser.frame.height/2
       // bgImage.layer.cornerRadius = bgImage.frame.height/2
            photoUser.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if textField == nomtextField {
          textField.resignFirstResponder()
          prenomTextField.becomeFirstResponder()
       } else if textField == prenomTextField {
          textField.resignFirstResponder()
          emailTextField.becomeFirstResponder()
       } else if textField == emailTextField {
          textField.resignFirstResponder()
           passwordTextField.becomeFirstResponder()
       }else if textField == passwordTextField {
           textField.resignFirstResponder()
            confirmPasswordtextField.becomeFirstResponder()
        }
      return true
     }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let nom = nomtextField.text!
        let prenom = prenomTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let weight = weightTextField.text!
        let height = heightTextField.text!
        
        
        let user = userModel(_id:"",nom: nom, prenom: prenom, email: email, password: password,gender: "", age: "", weight: weight, height: height,   experience: "", goal: "", token: "")
        if( nom.isEmpty || prenom.isEmpty || email.isEmpty || password.isEmpty || weight.isEmpty || height.isEmpty){
            showAlert(title: "Warning", message: "Please make sure to fill out all the form before registering")
            return
        }else
        if (!(confirmPasswordtextField.text! == password)){
            showAlert(title: "Failure", message: "Password do not match")
            return
        }
        UserService.shareinstance.register(user: user){
            (isSuccess) in
            if isSuccess{
                
                self.performSegue(withIdentifier: "homeSegue3", sender: IndexPath.self)
                
            } else {
                self.showAlert(title: "Failre", message: "Please try again")
            }
        }
        
        
    }
    
    
    
    
    @IBAction func SignUp(_ sender: Any) {
        let nom = nomtextField.text!
        let prenom = prenomTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        
        
        let user = userModel(_id:"",nom: nom, prenom: prenom, email: email, password: password,gender: "", age: "", weight: "", height: "",   experience: "", goal: "", token: "")
        if( nom.isEmpty || prenom.isEmpty || email.isEmpty || password.isEmpty){
            showAlert(title: "Warning", message: "Please make sure to fill out all the form before registering")
            return
        }else
        if (!(confirmPasswordtextField.text! == password)){
            showAlert(title: "Failure", message: "Password do not match")
            return
        }
        UserService.shareinstance.registerUser(user: user, uiImage: currentPhoto!){
            (isSuccess) in
            if isSuccess{
                
                self.performSegue(withIdentifier: "verifySegue", sender: IndexPath.self)
                
            } else {
                self.showAlert(title: "Failre", message: "Please try again")
            }
        }
        
        
        
        
        
        
    }
    
    
    
//    
//    func showAlert(title:String, message:String){
//        let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
//        let action = UIAlertAction(title:"ok", style: .cancel, handler:nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//        
//    }
//    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSegue3" {
            //  let indexPath = sender as! IndexPath
            let destination = segue.destination as! HomeViewController
            destination.username = emailTextField.text
            
        }
        if segue.identifier == "verifySegue" {
            //  let indexPath = sender as! IndexPath
            let destination = segue.destination as! codeViewController
            destination.email = emailTextField.text
            
        }
        
        
        
    }
    
    
    
    
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBAction func changePhoto(_ sender: Any) {
    showActionSheet()
}
    func camera()
    {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)

    }
  
  
  func gallery()
  {

      let myPickerControllerGallery = UIImagePickerController()
      myPickerControllerGallery.delegate = self
      myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
      myPickerControllerGallery.allowsEditing = true
      self.present(myPickerControllerGallery, animated: true, completion: nil)

  }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            
            return
        }
        
               currentPhoto = selectedImage
               photoUser.image = selectedImage
        addImageButton.isHidden = true
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet(){

        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)

        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
            self.camera()
        }
        actionSheetController.addAction(saveActionButton)

        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
   
    
    
    
    
    
}
extension SignUpViewController {
 func initializeHideKeyboard(){
 //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
 let tap: UITapGestureRecognizer = UITapGestureRecognizer(
 target: self,
 action: #selector(dismissMyKeyboard))
 //Add this tap gesture recognizer to the parent view
 view.addGestureRecognizer(tap)
 }
 @objc func dismissMyKeyboard(){
 //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
 //In short- Dismiss the active keyboard.
 view.endEditing(true)
 }
 }

