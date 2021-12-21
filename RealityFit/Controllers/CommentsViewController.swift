//
//  CommentsViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 20/12/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import AudioToolbox
import AVFoundation


class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   
    var workoutNameLabel: String?
    var workoutCategoryLabel: String?
    var workoutId: String?
    var usernameList = [String]()
    var commentList = [String]()
    var imagePath1: String?
    var workoutCat: String?

    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutCategory: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var commenttextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    func initialize() {
        
            self.commentsTableView.dataSource = self
            self.commentsTableView.delegate = self
            workoutCategory.text = workoutCat
            loadImage()
        
        print(workoutId)
        workoutName.text = workoutNameLabel
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        self.commentsTableView.refreshControl = refreshControl
        getComments()
       // print(commentList)
        
        commentsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellA = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        let cv = cellA.contentView
        let username = cv.viewWithTag(4) as! UILabel
        
        let commentaire = cv.viewWithTag(5) as! UILabel
        
        username.text = usernameList[indexPath.row]
        
        commentaire.text = commentList[indexPath.row]
        
 
        return cellA
        
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    @objc  func refresh(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
        {
            print("refreshing...")
            
            self.commentsTableView.reloadData()
            self.commentsTableView.refreshControl?.endRefreshing()
        }
        
    }
    func getComments() {
        AF.request(HOST+"/exercises/comments/"+workoutId!, method: .get).responseJSON{
            response in
            switch response.result{


            case .success:

                //                print(response)
                let myresult = try? JSON(data: response.data!)

               // print(myresult)
                self.usernameList.removeAll()
                self.commentList.removeAll()



                for i in myresult!["comments"].arrayValue {
                    print(i)
                    let username = i["postedBy"].stringValue
                    let comment = i["text"].stringValue
                    print(comment)
                    self.usernameList.append(username)
                    self.commentList.append(comment)

                    // print(image)
                }
                 self.commentsTableView.reloadData()
                break
            case .failure:



                print("CHECK INTERNET CONNECTION!!!!!!!!!!")
                print(response.error!)

                break
            }
        }
    }

    
    func loadImage(){
        var imageUrl = imagePath1!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       imageUrl = imageUrl.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        let url = URL(string: imageUrl)!
        workoutImage.af.setImage(withURL: url)

    }
    
    
    @IBAction func sendComment(_ sender: Any) {
        let systemSoundID: SystemSoundID = 1004
        
        if commenttextField.text == "" {
            showAlert(title: "Warning", message: "You did not type anything")
        }else
        
       { let comment = commenttextField.text!
        exerciseService.shareinstance.addComment(workoutId: workoutId!, comment: comment, completionHandler: {
            (isSuccess) in
            if isSuccess{
                print("comment added")
              
                AudioServicesPlaySystemSound(systemSoundID)

                self.initialize()
            }
            else
               
            {self.showAlert(title: "failure", message: "Comment could not be added");
                self.commentsTableView.reloadData()
            }
          
            
        })
        commenttextField.text = ""
        self.commentsTableView.reloadData()
    }}
    
    
}
