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

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var username: String?
   var exercices = ["squats","pushups","squats","pushups","squats","squats"]
    var exercicesImg = ["squats","pushups","squats","pushups","squats","squats"]
    var exercise_name = [String]()
    var exercise_category = [String]()
    var exercise_image = [String]()
    var user_image = [String]()
    var exercise_description = [String]()
    let token = UserDefaults.standard.string(forKey: "token")!
    let nomConnected = UserDefaults.standard.string(forKey: "nom")!
    let _id = UserDefaults.standard.string(forKey: "_id")!
    let reachability = try! Reachability()


   
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var planCollectionView: UICollectionView!
    
    
    //var bodypart = ["legs","chest","legs","chest","legs"]
    
    @IBOutlet weak var workoutCollectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    //POPULAR WORKOUT COLLECTION VIEW/////
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // exercices.count
        if collectionView == self.workoutCollectionView {
          return exercise_name.count
          
      }else
          {return exercices.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.workoutCollectionView {
           let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "popularWorkoutCell", for: indexPath)
        let cv = cellA.contentView
        let excerciseName = cv.viewWithTag(2) as! UILabel
        
        let exerciseImg = cv.viewWithTag(1) as! UIImageView
        let category = cv.viewWithTag(3) as! UILabel
        excerciseName.text = exercise_name[indexPath.row]
    
            category.text = exercise_category[indexPath.row]
       
        
        var path = String(exercise_image[indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)

        let url = URL(string: path)!
       

        print(url)

      exerciseImg.af.setImage(withURL: url)
   
        

        
        return cellA
           
        } else {
            
            print("test collection view")
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "planCell", for: indexPath)
           
         let cv = cellB.contentView
         let planName = cv.viewWithTag(4) as! UILabel
         
         let exerciseImg = cv.viewWithTag(5) as! UIImageView
            
            
            planName.text = exercices[indexPath.row]
            exerciseImg.image = UIImage(named: exercicesImg[indexPath.row])
            
            return cellB
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.workoutCollectionView  {performSegue(withIdentifier: "detailsSegue", sender: indexPath)}
    }
    
    //AVAILABLE plans collection view VIEW//////
    
    
    
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(_id)
        
        if reachability.connection == .unavailable {
            print("jawek mesh behy")
            showSpinner()
        }else{
            print("jawek behy")
            removeSpinner()
            loadExercises()
            loadProfileImage()
            print("this is the image path",user_image)
            usernameLabel.text = nomConnected
        }
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
            destination.segue = true
           
        }
    }
    
    
    func loadExercises()  {
      
        AF.request(HOST+"/exercises/display", method: .get).responseJSON{
            response in
            switch response.result{
            
                
            case .success:
               //self.removeSpinner()
               // print(response)
                let myresult = try? JSON(data: response.data!)
                // print(myresult)
                self.exercise_name.removeAll()
                self.exercise_category.removeAll()
                self.exercise_image.removeAll()
                
                
                for i in myresult!.arrayValue {
                    //print(i)
                    let nom = i["nom"].stringValue
                    let bodypart = i["bodyPart"].stringValue
                    let description = i["description"].stringValue
                    let image = HOST+"/"+i["image"].stringValue
                    self.exercise_name.append(nom)
                    self.exercise_category.append(bodypart)
                    self.exercise_description.append(description)
                    self.exercise_image.append(image)
                   // print(image)
                }
                self.workoutCollectionView.reloadData()
                break
            case .failure:
                
               

                print("CHECK INTERNET CONNECTION!!!!!!!!!!")
                print(response.error!)
                
                break
            }
        }
        
        
    }
    
    func loadProfileImage()  {
        
        AF.request(HOST+"/users/"+_id, method: .get).responseJSON{
            response in
            switch response.result{
                
            case .success:
           print(response)
                let myresult = try? JSON(data: response.data!)
               
               
                self.user_image.removeAll()
                
                
                for i in myresult!.arrayValue {
                    //print(i)
                    
                    let image = HOST+"/"+i["image"].stringValue

                    self.user_image.append(image)
                    print(image)
                }
                break
            case .failure:
                print(response.error!)
                
                break
            }
        }
        
      
   
        
    }
    @IBOutlet weak var switchthemeBtn: UIButton!
    
    @IBAction func modeSwitcher(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
            if #available(iOS 13.0, *) {
                if window?.overrideUserInterfaceStyle == .dark {
                    switchthemeBtn.tintColor = .white
                    switchthemeBtn.setTitle("Light mode", for: .normal)
                    window?.overrideUserInterfaceStyle = .light
                } else {
                    switchthemeBtn.tintColor = .darkGray
                    window?.overrideUserInterfaceStyle = .dark
                    switchthemeBtn.setTitle("Dark mode", for: .normal)
                }
            }
    }
    
}
