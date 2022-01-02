//
//  boughtPlansViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 25/12/2021.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class boughtPlansViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
   
    var exercise_id = [String]()
    var exercise_name = [String]()
    var exercise_category = [String]()
    var   exercise_desc = [String]()
    var exercise_image = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if reachability.connection == .unavailable {
            print("jawek mesh behy")
            showSpinner()
        }else
        {
            loadExercises()
            
        }
        // 1
       
    
        
       
        
    }
    
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise_name.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellA = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let cv = cellA.contentView
        let excerciseName = cv.viewWithTag(2) as! UILabel
        
        let exerciseImg = cv.viewWithTag(1) as! UIImageView
        let category = cv.viewWithTag(3) as! UILabel
       // let desc = cv.viewWithTag(4) as! UILabel
        excerciseName.text = exercise_name[indexPath.row]
        
        category.text = exercise_category[indexPath.row]
      //  desc.text = exercise_desc[indexPath.row]
        
        
        var path = String(exercise_image[indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        
        
        print(url)
        
        exerciseImg.af.setImage(withURL: url)
        
        
        
        
        return cellA
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView  {performSegue(withIdentifier: "planDetail2", sender: indexPath)}
    }
    
    
    
    
    
    
    func loadExercises()  {
        AF.request(HOST+"/plan/displayBought", method: .get).responseJSON{
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
                    let id = i["_id"].stringValue
                    let nom = i["nom"].stringValue
                    let bodypart = i["difficulty"].stringValue
                    let description = i["description"].stringValue
                    let image = HOST+"/"+i["image"].stringValue
                    self.exercise_name.append(nom)
                    self.exercise_category.append(bodypart)
                    self.exercise_desc.append(description)
                    self.exercise_image.append(image)
                    self.exercise_id.append(id)
                    // print(id)
                }
                self.tableView.reloadData()
                break
            case .failure:
                print(response.error!)
                
                break
            }
        }
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "planDetail2" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! planDetailViewController
            destination.planName = exercise_name[indexPath.row]
            destination.planDifficulty = exercise_desc[indexPath.row]
            destination.planImagePath = exercise_image[indexPath.row]
            destination.planId = exercise_id[indexPath.row]
            
        }
    }
    

  

}
