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
import Braintree
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
   
    var braintreeClient: BTAPIClient!

    
    
    var username: String?
   var exercices = ["squats","pushups","squats","pushups","squats","squats"]
    var exercicesImg = ["squats","pushups","squats","pushups","squats","squats"]
    var exercise_name = [String]()
    var exercise_category = [String]()
    var exercise_image = [String]()
    var plan_price = [String]()
    var plan_name = [String]()
    var plan_difficulty = [String]()
    var plan_image = [String]()
    var plan_day1 = [String]()
    var plan_day2 = [String]()
    var plan_day3 = [String]()
    var plan_day4 = [String]()
    var plan_day5 = [String]()
    var plan_payment = [String]()
    var IdPlan = [String]()
    var exercise_id = [String]()
    
    var user_image = [String]()
    var exercise_description = [String]()
    let token = UserDefaults.standard.string(forKey: "token")!
    let nomConnected = UserDefaults.standard.string(forKey: "nom")!
    let _id = UserDefaults.standard.string(forKey: "_id")!
    let reachability = try! Reachability()
    let flowLayout = ZoomAndSnapFlowLayout()

   
    let profilepic = UserDefaults.standard.string(forKey: "image")!

    
    
    //var bodypart = ["legs","chest","legs","chest","legs"]
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    @IBOutlet weak var workoutCollectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var planTableView: UITableView!
    
    
    //POPULAR WORKOUT COLLECTION VIEW/////
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // exercices.count
        if collectionView == self.workoutCollectionView {
          return exercise_name.count
          
      }else
          {return exercices.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
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

    //  exerciseImg.af.setImage(withURL: url)
   
        exerciseImg.kf.indicatorType = .activity
        
        exerciseImg.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil )
        
        
        return cellA
           
   
        
        
    }
  
       
        //or you can try this code also
        //let point = CGPoint(x: UIScreen.main.bounds.width/2, y:35 )
            
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.workoutCollectionView  {performSegue(withIdentifier: "detailsSegue", sender: indexPath)}
    }
    
    //AVAILABLE plans tableview view VIEW//////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plan_name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellA = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath)
        let cv = cellA.contentView
        
        let planName = cv.viewWithTag(5) as! UILabel
        let planImg = cv.viewWithTag(4) as! UIImageView
        let saleIcon = cv.viewWithTag(8) as! UIImageView
        let difficulty = cv.viewWithTag(6) as! UILabel
        let price = cv.viewWithTag(7) as! UILabel
        price.text = plan_price[indexPath.row]
        planName.text = plan_name[indexPath.row]
        difficulty.text = plan_difficulty[indexPath.row]
        var path = String(plan_image[indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)

        let url = URL(string: path)!
       

        print(url)

      planImg.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil )
        
        
        
        if plan_payment[indexPath.row] == "true"{

            saleIcon.isHidden = true
        } else {
            saleIcon.isHidden = false
        }

        return cellA
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.performSegue(withIdentifier: "planDetailSegue", sender: nil)
        
        if plan_payment[indexPath.row] == "true"{
          
            self.performSegue(withIdentifier: "planDetailSegue", sender: indexPath)
        } else
       {
           
            let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        let request = BTPayPalRequest(amount: plan_price[indexPath.row])
        request.currencyCode = "EUR" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                debugPrint("Payment successfull")
                exerciseService.shareinstance.payPlan(PlanId: self.IdPlan[indexPath.row], completionHandler: {
                    (isSuccess) in
                    if isSuccess{
                 
                        self.performSegue(withIdentifier: "planDetailSegue", sender: indexPath)
                    }
                    else
                       
                    {self.showAlert(title: "failure", message: "Payment did not proceed");}
                  
                    
                })
                
                self.navigationController?.popToRootViewController(animated: true)
                
                
                
                
                
                let email = tokenizedPayPalAccount.email
                //debugPrint(email)
                let firstName = tokenizedPayPalAccount.firstName
                //debugPrint(firstName)
                
                let lastName = tokenizedPayPalAccount.lastName
                //debugPrint(lastName)
                
                let phone = tokenizedPayPalAccount.phone
                //debugPrint(phone)
                
                
                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                //debugPrint(billingAddress)
                
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                //debugPrint(shippingAddress)
                
            } else if let error = error {
                // Handle error here...
            } else {
                // Buyer canceled payment approval
            }
        }}
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == planTableView {
            let cellHeight = CGFloat(247.0)
            let y          = targetContentOffset.pointee.y + scrollView.contentInset.top + (cellHeight / 2)
            let cellIndex  = floor(y / cellHeight)
            targetContentOffset.pointee.y = cellIndex * cellHeight - scrollView.contentInset.top
        }
    }
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(_id)
        
        if reachability.connection == .unavailable {
            print("jawek mesh behy")
            showSpinner()
        }else{
            workoutCollectionView.collectionViewLayout = flowLayout
            workoutCollectionView.contentInsetAdjustmentBehavior = .always
            print("jawek behy")
            removeSpinner()
            loadExercises()
            loadPlans()
            loadProfileImage()
            print("this is the image path",profilepic)
            usernameLabel.text = nomConnected
            braintreeClient = BTAPIClient(authorization: "sandbox_bnnq3v5c_jn3ynpqzfr5j9hbd")
            

        }
        //STYLEFORM/////
           
        
      
        

    
        

        // Do any additional setup after loading the view.
    }
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! DetailsViewController
            destination.exerciseId = exercise_id[indexPath.row]
            destination.excerciseName = exercise_name[indexPath.row]
            destination.exerciseDescription = exercise_description[indexPath.row]
           destination.imagePath = exercise_image[indexPath.row]
            destination.segue = true
           
        }else if segue.identifier == "planDetailSegue" {
            
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! planDetailViewController
            destination.planName = plan_name[indexPath.row]
            destination.planDifficulty = plan_difficulty[indexPath.row]
            destination.planImagePath = plan_image[indexPath.row]
            destination.planId = IdPlan[indexPath.row]
         
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
                    let id = i["_id"].stringValue
                    let nom = i["nom"].stringValue
                    let bodypart = i["bodyPart"].stringValue
                    let description = i["description"].stringValue
                    let image = HOST+"/"+i["image"].stringValue
                    self.exercise_id.append(id)
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
        profilePictureImage.layer.borderWidth = 6
            profilePictureImage.layer.masksToBounds = false
            profilePictureImage.layer.borderColor = UIColor(red:18/255, green:19/255, blue:38/255, alpha: 1).cgColor
            profilePictureImage.layer.cornerRadius = profilePictureImage.frame.height/2
        profilePictureImage.clipsToBounds = true

        var path = String(HOST+"/"+profilepic).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)

        let url = URL(string: path)!
        profilePictureImage.af.setImage(withURL: url)
   
        
    }
    func loadPlans()  {
        AF.request(HOST+"/plan/displayNotBought", method: .get).responseJSON{
            response in
            switch response.result{
                
            case .success:
                // print(response)
                let myresult = try? JSON(data: response.data!)
                //  print(myresult)
                self.IdPlan.removeAll()
                self.plan_name.removeAll()
                self.plan_difficulty.removeAll()
                self.plan_image.removeAll()
                self.plan_day1.removeAll()
                self.plan_day2.removeAll()
                self.plan_day3.removeAll()
                self.plan_day4.removeAll()
                self.plan_day5.removeAll()
                self.plan_price.removeAll()
                self.plan_payment.removeAll()
                
                for i in myresult!.arrayValue {
                    //print(i)
                    let id = i["_id"].stringValue
                    let nom = i["nom"].stringValue
                    let difficulty = i["difficulty"].stringValue
                    let image = HOST+"/"+i["image"].stringValue
                    let day1 = i["day1"].stringValue
                    let day2 = i["day2"].stringValue
                    let day3 = i["day3"].stringValue
                    let day4 = i["day4"].stringValue
                    let day5 = i["day5"].stringValue
                    let price = i["price"].stringValue
                    let payment = i["isBought"].stringValue

                    self.IdPlan.append(id)
                    self.plan_name.append(nom)
                    self.plan_difficulty.append(difficulty)
                    self.plan_image.append(image)
                    self.plan_day1.append(day1)
                    self.plan_day2.append(day2)
                    self.plan_day3.append(day3)
                    self.plan_day4.append(day4)
                    self.plan_day5.append(day5)
                    self.plan_price.append(price)
                    self.plan_payment.append(payment)
                    // print(id)
                }
                self.planTableView.reloadData()
                break
            case .failure:
                print(response.error!)
                
                break
            }
        }
    }
//    func makeRequest(to endPoint: String) {
//
//        // here you can showActivetyIndicator start progressing here
//        showSpinner()
//        AF.request(endPoint).responseJSON{ response in
//            if let value = response.result.value {
//                let responseInJSON = JSON(value)
//                self.responseInJSON = responseInJSON
//            }
//           // here you can hide Your ActivetyIndicator here
//            removeSpinner()
//        }
//    }
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
extension HomeViewController : BTViewControllerPresentingDelegate{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    
}

extension HomeViewController : BTAppSwitchDelegate {
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
}
