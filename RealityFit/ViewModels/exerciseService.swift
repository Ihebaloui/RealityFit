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
        AF.request("http://172.17.9.26:3000/exercises/display").response {
            response in
            debugPrint(response)
        }
    }
    
    
}
