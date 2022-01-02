//
//  planDetailViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 25/12/2021.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class planDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var planImgLabel: UIImageView!
    @IBOutlet weak var planDetailTableView: UITableView!
    var days = ["Day 1:","Day 2: ","Day 3:","Day 4:","Day 5:"]
    var exercicesImg = ["squats","pushups","squats","pushups","squats","squats"]
    var planDays = [String]()
    var plan_day1 = [String]()
    var plan_day2 = [String]()
    var plan_day3 = [String]()
    var plan_day4 = [String]()
    var plan_day5 = [String]()

    var  planName: String?
    var planDifficulty: String?
    var planImagePath: String?
    var planId: String?
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        planNameLabel.text = planName
        difficultyLabel.text = planDifficulty
        loadImage()
        loadPlans()

        print(planDays)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellA = tableView.dequeueReusableCell(withIdentifier: "planDetailCell", for: indexPath)
        let cv = cellA.contentView
        let day = cv.viewWithTag(1) as! UILabel
      let workout = cv.viewWithTag(2) as! UILabel
//        let planImg = cv.viewWithTag(4) as! UIImageView
//        let saleIcon = cv.viewWithTag(8) as! UIImageView
//        let difficulty = cv.viewWithTag(6) as! UILabel
//        let price = cv.viewWithTag(7) as! UILabel
        day.text = days[indexPath.row]
       workout.text = planDays[indexPath.row]
//        difficulty.text = plan_difficulty[indexPath.row]
//        var path = String(plan_image[indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//       path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
//
//        let url = URL(string: path)!
//
//
//        print(url)
//
//      planImg.af.setImage(withURL: url)
        return cellA
    }

    func loadImage(){
        var imageUrl = planImagePath!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       imageUrl = imageUrl.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        let url = URL(string: imageUrl)!
        planImgLabel.af.setImage(withURL: url)

    }

    func loadPlans()  {
        AF.request(HOST+"/plan/"+planId!, method: .get).responseJSON{
            response in
            switch response.result{
                
            case .success:
                // print(response)
                let myresult = try? JSON(data: response.data!)
                print(myresult!["day1"].stringValue)
              
           
                self.planDays.removeAll()
               
 
               
                    let day1 =  myresult!["day1"].stringValue
                    let day2 =  myresult!["day2"].stringValue
                    let day3 =  myresult!["day3"].stringValue
                    let day4 =  myresult!["day4"].stringValue
                    let day5 =  myresult!["day5"].stringValue
                print(day2)
                 
                  
                    self.planDays.append(day1)
                    self.planDays.append(day2)
                    self.planDays.append(day3)
                    self.planDays.append(day4)
                    self.planDays.append(day5)
                   
                    // print(id)
              
                
                self.planDetailTableView.reloadData()
                break
            case .failure:
                print(response.error!)
                
                break
            }
        }
   //     print("aaaaaaa"+ planDays = plan_day1 + plan_day2 + plan_day3 + plan_day4 + plan_day5)
        
    }

}
