//
//  HomeViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 19/11/2021.
//

import UIKit
import GoogleSignIn
import Alamofire
import SwiftyJSON
import AlamofireImage

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var username: String?
   var exercices = ["squats","pushups","squats","pushups","squats"]
    var exercise_name = [String]()
    var exercise_category = [String]()
    var exercise_image = [String]()
    var user_image = [String]()
    var exercise_description = [String]()
    let token = UserDefaults.standard.string(forKey: "token")!
    let nomConnected = UserDefaults.standard.string(forKey: "nom")!
    let _id = UserDefaults.standard.string(forKey: "_id")!

    @IBOutlet weak var profileImage: UIButton!
    
    
    
    
    //var bodypart = ["legs","chest","legs","chest","legs"]
    
    @IBOutlet weak var workoutCollectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    //POPULAR WORKOUT COLLECTION VIEW/////
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // exercices.count
        return exercise_name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularWorkoutCell", for: indexPath)
        let cv = cell.contentView
        let excerciseName = cv.viewWithTag(2) as! UILabel
        excerciseName.text = exercise_name[indexPath.row]
        
        
        
        
  
        
        let exerciseImg = cv.viewWithTag(1) as! UIImageView
      
        let category = cv.viewWithTag(3) as! UILabel
        
    
            category.text = exercise_category[indexPath.row]
       
        
        var path = String(exercise_image[indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)

        let url = URL(string: path)!
       

        print(url)

      exerciseImg.af.setImage(withURL: url)
   
        

        
        return cell
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailsSegue", sender: indexPath)
    }
    
    //AVAILABLE WORKOUTS TABLE VIEW//////
    
    
    
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(_id)
        loadExercises()
        loadProfileImage()
       
        usernameLabel.text = nomConnected
        
        //STYLEFORM/////
        
      
        

    
        

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! DetailsViewController
            destination.excerciseName = exercise_name[indexPath.row]
            destination.exerciseDescription = exercise_description[indexPath.row]
           destination.imagePath = exercise_image[indexPath.row]
           
        }
    }
    
    
    func loadExercises()  {
        AF.request("http://172.17.9.26:3000/exercises/display", method: .get).responseJSON{
            response in
            switch response.result{
                
            case .success:
               // print(response)
                let myresult = try? JSON(data: response.data!)
              //  print(myresult)
                self.exercise_name.removeAll()
                self.exercise_category.removeAll()
                self.exercise_image.removeAll()
                
                
                for i in myresult!.arrayValue {
                    //print(i)
                    let nom = i["nom"].stringValue
                    let bodypart = i["bodyPart"].stringValue
                    let description = i["description"].stringValue
                    let image = "http://172.17.9.26:3000/"+i["image"].stringValue
                    self.exercise_name.append(nom)
                    self.exercise_category.append(bodypart)
                    self.exercise_description.append(description)
                    self.exercise_image.append(image)
                   // print(image)
                }
                self.workoutCollectionView.reloadData()
                break
            case .failure:
                print(response.error!)
                
                break
            }
        }
    }
    
    func loadProfileImage()  {
        AF.request("http://172.17.9.26:3000/users/display/"+_id, method: .get).responseJSON{
            response in
            switch response.result{
                
            case .success:
               // print(response)
                let myresult = try? JSON(data: response.data!)
                print(myresult)
               
                self.user_image.removeAll()
                
                
                for i in myresult!.arrayValue {
                    //print(i)
                    
                    let image = "http://172.17.9.26:3000/"+i["image"].stringValue
                  //  print(image)

                    self.user_image.append(image)
                   // print(image)
                }
                break
            case .failure:
                print(response.error!)
                
                break
            }
        }
        
    }
    
    

}
