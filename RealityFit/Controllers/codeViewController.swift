//
//  codeViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 9/12/2021.
//

import UIKit

class codeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstDigit: UITextField!
    
    
    @IBOutlet weak var secondDigit: UITextField!
    
    @IBOutlet weak var thirrdDigit: UITextField!
    
    @IBOutlet weak var fourthDigit: UITextField!
    
    @IBOutlet weak var fifthDigit: UITextField!
    
    @IBOutlet weak var sixthDigit: UITextField!
    
    var email: String?
    let _id = UserDefaults.standard.string(forKey: "_id")!

    
    
    
    @IBOutlet weak var usernameEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstDigit.delegate = self
        self.secondDigit.delegate = self
        self.thirrdDigit.delegate = self
        self.fourthDigit.delegate = self
        self.fifthDigit.delegate = self
        self.sixthDigit.delegate = self
        
        let components =  email!.components(separatedBy: "@")
        let result = hideMidChars(components.first!) + "@" + components.last!
        usernameEmail.text = result
       // print(_id)
        // Do any additional setup after loading the view.
    }
    

    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        var maxLength : Int = 0
            
            if textField == firstDigit{
                maxLength = 1
            } else if textField == secondDigit{
                maxLength = 1
            } else if textField == thirrdDigit{
                maxLength = 1
            }else if textField == fourthDigit{
                maxLength = 1
            }else if textField == fifthDigit{
                maxLength = 1
            }else if textField == sixthDigit{
                maxLength = 1
            }
            
            let currentString: NSString = textField.text! as NSString
            
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == firstDigit) {
           textField.text = ""
        }
        else if (textField == secondDigit) {
            textField.text = ""        }
    }
    
    func hideMidChars(_ value: String) -> String {
       return String(value.enumerated().map { index, char in
          return [0, 1, value.count - 1, value.count - 2].contains(index) ? char : "*"
       })
    }
 
    
    
    @IBAction func confirmVerif(_ sender: Any) {
        let first_digit =  firstDigit.text!
        let second_digit =  secondDigit.text!
        let third_digit =  thirrdDigit.text!
        let fourth_digit =  fourthDigit.text!
        let fifth_digit =  fifthDigit.text!
        let sixth_digit =  sixthDigit.text!
        
        let code = String(first_digit+second_digit+third_digit+fourth_digit+fifth_digit+sixth_digit)
        
        //print(code)
      //  let user = userModel(_id:"",nom: "", prenom: "", email: "", password: "",gender: "", age: "", weight: "", height: "",   experience: "", goal: "", token: "")
        
        UserService.shareinstance.verifyCode(_id: _id, code: code, completionHandler: {
            (isSuccess) in
            if isSuccess{
               print("jawek behy")
                self.performSegue(withIdentifier: "loginSegue", sender: IndexPath.self)

            } else {
                self.showAlert(title: "Failure", message: "wrong code")
            }
        })
        
        
    }
    func showAlert(title:String, message:String){
                  let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
                  let action = UIAlertAction(title:"ok", style: .cancel, handler:nil)
                  alert.addAction(action)
                  self.present(alert, animated: true, completion: nil)

}

    
}
