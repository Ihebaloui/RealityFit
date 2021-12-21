//
//  workoutTableViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 12/12/2021.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class workoutTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredExercises: [String] = []
    
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
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search exercises"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        searchbar.searchTextField.backgroundColor = UIColor.black
        searchbar.searchTextField.textColor = UIColor(red: 91, green: 199, blue: 250, alpha: 1)
    
        
       
        
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
        let desc = cv.viewWithTag(4) as! UILabel
        excerciseName.text = exercise_name[indexPath.row]
        
        category.text = exercise_category[indexPath.row]
        desc.text = exercise_desc[indexPath.row]
        
        
        var path = String(exercise_image[indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        
        
        print(url)
        
        exerciseImg.af.setImage(withURL: url)
        
        
        
        
        return cellA
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView  {performSegue(withIdentifier: "detailsSegue2", sender: indexPath)}
    }
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    
    
    
    func loadExercises()  {
        AF.request(HOST+"/exercises/display", method: .get).responseJSON{
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
                    let bodypart = i["bodyPart"].stringValue
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        filteredExercises = exercise_name
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
 
        filterContentForSearchText(searchText)
        print(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        exercise_name = []
        for exercise in filteredExercises {
            if exercise.lowercased()
                .contains(searchText.lowercased()) {
                exercise_name.append(exercise)
            }
        }
        
        
        if searchText.isEmpty {
            exercise_name = filteredExercises
        } else {
        }
        
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue2" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! DetailsViewController
            destination.excerciseName = exercise_name[indexPath.row]
            destination.exerciseDescription = exercise_desc[indexPath.row]
           destination.imagePath = exercise_image[indexPath.row]
            destination.exerciseId = exercise_id[indexPath.row]
            destination.exerciseCat = exercise_category[indexPath.row]
            destination.segue = false
        }
    }
    
    
}



extension workoutTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
