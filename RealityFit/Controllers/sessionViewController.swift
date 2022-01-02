//
//  sessionViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 10/12/2021.
//

import UIKit

class sessionViewController: UIViewController {
    
    let token = UserDefaults.standard.string(forKey: "token")
    let nomConnected = UserDefaults.standard.string(forKey: "nom")
    let _id = UserDefaults.standard.string(forKey: "_id")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if reachability.connection == .unavailable {
            print("jawek mesh behy")
            self.showAlert(title: "Connectivity Problem", message: "Please check your internet connection ")
        }else
        {
            isKeyPresentInUserDefaults(key: "token")
             print(token)
            
        }
        
        
      
        
    }
    
 
    func isKeyPresentInUserDefaults(key: String)  {
        if token == nil {
            performSegue(withIdentifier: "signInSegue", sender: nil)


        } else {
            performSegue(withIdentifier: "sessionSegue", sender: nil)
        }
    

}
}
