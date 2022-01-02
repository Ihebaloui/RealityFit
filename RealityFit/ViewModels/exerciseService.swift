//
//  exerciseService.swift
//  RealityFit
//
//  Created by Apple Esprit on 3/12/2021.
//

import Foundation
import Alamofire
import SwiftyJSON


class exerciseService{
    static let shareinstance = exerciseService()

    func getExercise() {
        AF.request("http://172.17.1.238:3000/exercises/display").response {
            response in
            debugPrint(response)
        }
    }
    
    
    func addComment(workoutId:String,comment: String,completionHandler:@escaping (Bool)->()){
        let headers: HTTPHeaders = ["x-access-token": UserDefaults.standard.string(forKey: "token")!]
        // let headers: HTTPHeaders = [.contentType("application/x-www-form-urlencoded"),.authorization(bearerToken:(UserDefaults.standard.string(forKey: "token")!)) ]
        AF.request(HOST+"/exercises/comment/",  method:   .put ,parameters: ["text":comment, "exerciseID": workoutId ] ,  headers: headers ).response{ response in
             switch response.result{
             case .success(let data):
                 do {
                     let json  = try JSONSerialization.jsonObject(with: data!, options: [])
                     print(json)
//                     print(response.response.s)
                     if response.response?.statusCode == 200{
                         //let jsonData = JSON(response.data!)
                         print(comment)
                         //let user = self.makeItem(jsonItem: jsonData)
                         completionHandler(true)

                         //print(user)
                     }else{
                         completionHandler(false)
                     }
                     
                 } catch  {
                     print(error.localizedDescription)
                     completionHandler(false)
                     
                     
                 }
             case .failure(let err):
                 print("eeee")
                 print(err.localizedDescription)
             }
         }
     }
    func payPlan(PlanId:String,completionHandler:@escaping (Bool)->()){
       
        let headers: HTTPHeaders = [.contentType("application/x-www-form-urlencoded"),.authorization(bearerToken:(UserDefaults.standard.string(forKey: "token")!)) ]
        AF.request(HOST+"/plan/"+PlanId,  method:   .patch ,  headers: headers ).response{ response in
             switch response.result{
             case .success(let data):
                 do {
                     let json  = try JSONSerialization.jsonObject(with: data!, options: [])
                     print(json)
//                     print(response.response.s)
                     if response.response?.statusCode == 201{
                         //let jsonData = JSON(response.data!)
                         print("jawek behy ya jon")
                         //let user = self.makeItem(jsonItem: jsonData)
                         completionHandler(true)

                         //print(user)
                     }else{
                         completionHandler(false)
                     }
                     
                 } catch  {
                     print(error.localizedDescription)
                     completionHandler(false)
                     
                     
                 }
             case .failure(let err):
                 print("eeee")
                 print(err.localizedDescription)
             }
         }
     }
   
    
}
