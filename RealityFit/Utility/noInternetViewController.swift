//
//  noInternetViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 1/1/2022.
//

import UIKit



class noInternetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func refreshInternet(_ sender: Any) {
        print("nazla")
    testInternet()
    }
    
    func testInternet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as! UITabBarController
         reachability = try! Reachability()

        if reachability.connection == .unavailable {
            showAlert(title: "Internet Connectivity", message: "You seem to have a problem with your internet connection")
            
           
        } else {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated:true, completion:nil)
        }
    }
}
