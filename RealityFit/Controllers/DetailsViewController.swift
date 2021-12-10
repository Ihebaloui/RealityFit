//
//  DetailsViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 19/11/2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    var excerciseName:String?
    
    var exerciseDescription: String?
    
    var imagePath: String?
    
    @IBOutlet weak var excerciseImage: UIImageView!
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    @IBOutlet weak var exercise_description: UITextView!
    
    
    override func viewDidLoad() {
        var imageUrl = imagePath!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       imageUrl = imageUrl.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        let url = URL(string: imageUrl)!
        print(exerciseDescription)
        super.viewDidLoad()
        excerciseImage.af.setImage(withURL: url)
        exerciseNameLabel.text = excerciseName
        exercise_description.text = exerciseDescription
        

        // Do any additional setup after loading the view.
    }
    

 

}
