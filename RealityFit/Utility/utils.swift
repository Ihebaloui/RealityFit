//
//  utils.swift
//  RealityFit
//
//  Created by Apple Esprit on 16/12/2021.
//
import UIKit
import Foundation

var HOST = "http://172.17.3.77:8888"
var reachability = try! Reachability()


fileprivate var aView : UIView?

extension UIViewController {
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "noInternet") as! noInternetViewController
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false){(t) in
            self.removeSpinner()
           // self.showAlert(title: "Connectivity Problem", message: "Please check your internet connection ")
           
            
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated:true, completion:nil)
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
    func showAlert(title:String, message:String){
                  let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
                  let action = UIAlertAction(title:"ok", style: .cancel, handler:nil)
                  alert.addAction(action)
                  self.present(alert, animated: true, completion: nil)

    }
    
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




