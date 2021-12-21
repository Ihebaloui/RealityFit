//
//  DetailsViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 19/11/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailsViewController: UIViewController {
    
    var segue:Bool?
    var excerciseName:String?
    var exerciseId:String?
    
    var exerciseDescription: String?
    var exerciseCat: String?
    var imagePath: String?
  
    
   
    
    @IBOutlet weak var excerciseImage: UIImageView!
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    @IBOutlet weak var exercise_description: UITextView!
    
    
    override func viewDidLoad() {
     loadImage()
      //  print(exerciseDescription)
        super.viewDidLoad()
        exerciseNameLabel.text = excerciseName
        exercise_description.text = exerciseDescription
      
       
      //
        print(exerciseId)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if segue == true{
            self.performSegue(withIdentifier: "homeBackSegue", sender: nil)
        }
    else {
        self.performSegue(withIdentifier: "listBackSegue", sender: nil)}
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
           // let indexPath = sender as! IndexPath
            let destination = segue.destination as! CommentsViewController
            destination.workoutNameLabel = excerciseName
            destination.workoutId = exerciseId
            destination.imagePath1 = imagePath
            destination.workoutCat = exerciseCat
            //destination.workoutCategoryLabel = exercise_desc[indexPath.row]
         
         
        }
    }
    
    
    @IBAction func commentBtn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "commentSegue", sender: sender )
    }
    
    func loadImage(){
        var imageUrl = imagePath!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       imageUrl = imageUrl.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        let url = URL(string: imageUrl)!
        excerciseImage.af.setImage(withURL: url)

    }
    
}


