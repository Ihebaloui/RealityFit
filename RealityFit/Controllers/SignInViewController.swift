//
//  SignInViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 19/11/2021.
//

import UIKit
import GoogleSignIn
import Alamofire
import LocalAuthentication

class SignInViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {
    
    let token = UserDefaults.standard.string(forKey: "token")
    let nomConnected = UserDefaults.standard.string(forKey: "nom")
    let _id = UserDefaults.standard.string(forKey: "_id")
    
    @IBOutlet weak var loginLabel: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var fingerprint: UIButton!
    var context = LAContext()
    var err : NSError?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()

        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        addBottomBorderTo(textField: emailTextField)
        addBottomBorderTo(textField: passwordTextField)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
              GIDSignIn.sharedInstance().signInSilently()
              let gSignIn = GIDSignInButton(frame: CGRect(x: 19, y: 690, width: 347, height: 31))
              view.addSubview(gSignIn)
          
      /*    let signOut = UIButton (frame: CGRect(x: 211, y: 755, width: 159, height: 31))
              signOut.backgroundColor = UIColor.red
              signOut.setTitle("Sign out", for:  .normal)
              signOut.addTarget(self, action: #selector(self.signOut(sender:)), for: .touchUpInside)
              self.view.addSubview(signOut)*/



        // Do any additional setup after loading the view.
        print(token)
        if token == nil {
            
            fingerprint.isEnabled = false
            fingerprint.tintColor = .gray

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    
    func addBottomBorderTo(textField: UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height-2.0, width: textField.frame.size.width, height: 2.0)
    }
    
    
    @objc func signOut(sender: UIButton)
       {
           print ("signOut")
           GIDSignIn.sharedInstance().signOut()
       }

  
    @IBAction func loginBtn(_ sender: UIButton) {
        
       
        
      
       
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.showAlert(title: "Missing info !", message: "Please make sure to fill all the form and try again")
        }else {
            let user = userModel( _id:"", nom: "", prenom: "", email: emailTextField.text!, password: passwordTextField.text!, gender: "", age: "", weight: "", height: "", experience: "", goal: "", token: "")
            //  let status =  UserService.shareinstance.loginUser(user: user)
        
        let email = emailTextField.text!
        let pass = passwordTextField.text!
        
        //    UserService.shareinstance.login(user: user)
            
            UserService.shareinstance.login(email: email, password: pass ){
                      (isSuccess) in
                      if isSuccess{
                         // self.showAlert(title: "Success", message: "you have logged in")
                          self.performSegue(withIdentifier: "homeSegue", sender: IndexPath.self)
                      } else {
                          self.showAlert(title: "Failure", message: "invalid Credentials")
                      }
                  }
        
        }
             
        
      //
        

        
        }
    
    @IBAction func touchIdLogin(_ sender: Any) {
        
        let localString = "Biometric Authentication"
        let context = LAContext()
           var error: NSError?

           if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
               let reason = "Identify yourself!"

               context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                   [weak self] success, authenticationError in

                   DispatchQueue.main.async {
                       if success {
                           self!.performSegue(withIdentifier: "homeSegue", sender: IndexPath.self)
                       } else {
                           // error
                       }
                   }
               }
           } else {
               // no biometry
    }
    }
    
    
//    func showAlert(title:String, message:String){
//                  let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
//                  let action = UIAlertAction(title:"ok", style: .cancel, handler:nil)
//                  alert.addAction(action)
//                  self.present(alert, animated: true, completion: nil)
//
//}
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSegue" {
          //  let indexPath = sender as! IndexPath
//            let destination = segue.destination as! HomeViewController
           // destination.username = emailTextField.text
            
        }
    
    
    
    
    
    
    //ENDD
}
        
}
extension SignInViewController {

 }
