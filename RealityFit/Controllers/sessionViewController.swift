//
//  sessionViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 10/12/2021.
//

import UIKit

class sessionViewController: UIViewController {
    
    let token = UserDefaults.standard.string(forKey: "token")!
    let nomConnected = UserDefaults.standard.string(forKey: "nom")!
    let _id = UserDefaults.standard.string(forKey: "_id")!


    override func viewDidLoad() {
        super.viewDidLoad()
       isKeyPresentInUserDefaults(key: "token")
        print(token)
        
    }
    
 
    func isKeyPresentInUserDefaults(key: String)  {
        if token == ""{
            performSegue(withIdentifier: "signInSegue", sender: nil)


        } else {
            performSegue(withIdentifier: "sessionSegue", sender: nil)
        }
    

}
}
