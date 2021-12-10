//
//  SignUpViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 3/12/2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nomtextField: UITextField!
    
    @IBOutlet weak var prenomTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordtextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        UserService.shareinstance.register(user: user){
            (isSuccess) in
            if isSuccess{
                
                self.performSegue(withIdentifier: "verifySegue", sender: IndexPath.self)
                
            } else {
                self.showAlert(title: "Failre", message: "Please try again")
            }
        }
    }
    
    
    
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let action = UIAlertAction(title:"ok", style: .cancel, handler:nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
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
    
    
}
