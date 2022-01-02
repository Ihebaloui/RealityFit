//
//  userService.swift
//  RealityFit
//
//  Created by Mac-Mini-2021 on 28/11/2021.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Alamofire
import SwiftyJSON
import UIKit


class UserService{
   static let shareinstance = UserService()

    func register(user : userModel,completionHandler:@escaping (Bool)->()){
        let headers: HTTPHeaders = [.contentType("application/json")]
        AF.request(HOST+"/users/register", method: .post, parameters: user,encoder: JSONParameterEncoder.default, headers: headers ).response{ response in debugPrint(response)
            switch response.result{
            case .success(let data):
                do {
                    let json  = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    if response.response?.statusCode == 201{
                        let jsonData = JSON(response.data!)
                        UserDefaults.standard.setValue(jsonData["_id"].stringValue, forKey: "_id")
                        UserDefaults.standard.setValue(jsonData["nom"].stringValue, forKey: "nom")
                        UserDefaults.standard.setValue(jsonData["prenom"].stringValue, forKey: "prenom")
                        UserDefaults.standard.setValue(jsonData["isVerified"].stringValue, forKey: "isVerified")
                        
                        print(jsonData["_id"].stringValue)
                        completionHandler(true)

                    }else{
                       
                        completionHandler(false)
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                    completionHandler(false)
                    
                    
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func registerUser(user: userModel, uiImage: UIImage, completed: @escaping (Bool) -> Void ) {
            print("hi")
        let headers: HTTPHeaders = [.contentType("application/json")]
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(uiImage.jpegData(compressionQuality: 0.5)!, withName: "image" , fileName: "image.jpeg", mimeType: "image/jpeg")
                
                let ParametersS = [ "nom": user.nom!,
                                    "prenom": user.prenom!,
                                    "email": user.email!,
                                    "password": user.password!,
                                    
                ] as [String : Any]
                for (key, value) in ParametersS {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Double {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    
                    }
                    
                    print(multipartFormData)
                }
                },to: HOST+"/users/register",
            method: .post,headers: headers)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    switch response.result {
                    case .success:
                        let jsonData = JSON(response.data!)
                        UserDefaults.standard.setValue(jsonData["_id"].stringValue, forKey: "_id")
                        UserDefaults.standard.setValue(jsonData["nom"].stringValue, forKey: "nom")
                        UserDefaults.standard.setValue(jsonData["prenom"].stringValue, forKey: "prenom")
                        UserDefaults.standard.setValue(jsonData["isVerified"].stringValue, forKey: "isVerified")
                        print("Success")
                        completed(true)
                    case let .failure(error):
                        completed(false)
                        print(error)
                    }
                }
        }
    
    
    
    func login(email: String, password: String,completionHandler:@escaping (Bool)->()){
         let headers: HTTPHeaders = [.contentType("application/json")]
         AF.request(HOST+"/users/login", method: .post, parameters: ["email":email, "password": password],encoder: JSONParameterEncoder.default, headers: headers ).response{ response in debugPrint(response)
             switch response.result{
             case .success(let data):
                 do {
                     let json  = try JSONSerialization.jsonObject(with: data!, options: [])
                     print(json)
                     if response.response?.statusCode == 200{
                         let jsonData = JSON(response.data!)
                         UserDefaults.standard.setValue(jsonData["token"].stringValue, forKey: "token")
                         UserDefaults.standard.setValue(jsonData["_id"].stringValue, forKey: "_id")
                         UserDefaults.standard.setValue(jsonData["nom"].stringValue, forKey: "nom")
                         UserDefaults.standard.setValue(jsonData["prenom"].stringValue, forKey: "prenom")
                         UserDefaults.standard.setValue(jsonData["image"].stringValue, forKey: "image")

                         print(jsonData["nom"].stringValue)
                         completionHandler(true)

                       //  print(UserDefaults.standard.string(forKey: "_id")!)
                     }else{
                         completionHandler(false)
                     }
                     
                 } catch  {
                     print(error.localizedDescription)
                     completionHandler(false)
                     
                     
                 }
             case .failure(let err):
                 print(err.localizedDescription)
             }
         }
     }
    
    
    func getProfile(_id:String,completionHandler:@escaping (Bool,userModel?)->()){
       
      
        let headers: HTTPHeaders = [.contentType("application/json"),.authorization(bearerToken:(UserDefaults.standard.string(forKey: "token")!)) ]
        AF.request(HOST+"/users/"+_id, method: .get,parameters:[ "_id":UserDefaults.standard.value(forKey: "_id")!] , headers: headers ).response{ response in
            switch response.result{
            case .success(let data):
                do {
                    let json  = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    if response.response?.statusCode == 200{
                        let jsonData = JSON(response.data!)
                        let user = self.makeItem(jsonItem: jsonData)
                        UserDefaults.standard.setValue(jsonData["nom"].stringValue, forKey: "nom")
                        UserDefaults.standard.setValue(jsonData["prenom"].stringValue, forKey: "prenom")
                        completionHandler(true,user)

                        print(user)
                    }else{
                        completionHandler(false,nil)
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                    completionHandler(false,nil)
                    
                    
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
   func updateProfile(_id:String,user : userModel,completionHandler:@escaping (Bool)->()){
        let headers: HTTPHeaders = [.contentType("application/x-www-form-urlencoded"),.authorization(bearerToken:(UserDefaults.standard.string(forKey: "token")!)) ]
       AF.request(HOST+"/users/"+_id,  method:   .patch ,parameters: user , headers: headers ).response{ response in
            switch response.result{
            case .success(let data):
                do {
                    let json  = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    if response.response?.statusCode == 201{
                     print("jawek behy ya jon")
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
                print(err.localizedDescription)
            }
        }
    }
    
    
    
    func verifyCode(_id:String,code: String,completionHandler:@escaping (Bool)->()){
         let headers: HTTPHeaders = [.contentType("application/x-www-form-urlencoded"),.authorization(bearerToken:(UserDefaults.standard.string(forKey: "_id")!)) ]
        AF.request(HOST+"/users/verify-email/"+_id,  method:   .patch ,parameters: ["verifCode":code] ,  headers: headers ).response{ response in
             switch response.result{
             case .success(let data):
                 do {
                     let json  = try JSONSerialization.jsonObject(with: data!, options: [])
                     print(json)
                     if response.response?.statusCode == 201{
                         //let jsonData = JSON(response.data!)
                         print(code)
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
    
    
    
    func makeItem(jsonItem: JSON) -> userModel {
        //let isoDate = jsonItem["dateNaissance"]
        userModel(
            _id: jsonItem["_id"].stringValue,
            nom: jsonItem["nom"].stringValue,
            prenom: jsonItem["prenom"].stringValue,
            email: jsonItem["email"].stringValue,
            password:  jsonItem["password"].stringValue,
            gender: jsonItem["gender"].stringValue,
            age: jsonItem["age"].stringValue,
            weight: jsonItem["weight"].stringValue,
            height: jsonItem["height"].stringValue,
            experience: jsonItem["experience"].stringValue,
            goal: jsonItem["goal"].stringValue,
            token: jsonItem["token"].stringValue




            
            

        )
    }
    
    
 }

