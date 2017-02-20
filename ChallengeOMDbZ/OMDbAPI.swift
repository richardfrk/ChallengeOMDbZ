//
//  OMDbAPI.swift
//  DesafioZUP
//
//  Created by Richard Frank on 06/02/17.
//  Copyright © 2017 Richard Frank. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OMDbAPI {
    
    class func fetchDataFromSearchByTitle(_ title: String, completionHandler: @escaping ([MovieEntity]) -> ()) {
        
        var arrMovieEntity = [MovieEntity]()
        
        let myParameters = [
        
            "s":title,
            "type":"movie",
            "page":"1"
        ]
        
        Alamofire.request("https://www.omdbapi.com/", parameters: myParameters).validate(statusCode: 200..<300).responseJSON { response in
            
            //print(response.request!)
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                for index in 0..<json["Search"].count {
                    let model = MovieEntity(json, index)
                    arrMovieEntity.append(model)
                }
                completionHandler(arrMovieEntity)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    class func fetchDataMovieByIMDbID(_ id: String, completionHandler: @escaping (MovieEntity)->()) {
        
        let myParameters = [
            
            "i":id
        ]
        
        Alamofire.request("https://www.omdbapi.com/", parameters: myParameters).validate(statusCode: 200..<300).responseJSON{ response in
            
            print(response.request!)
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let model = MovieEntity(json)
                completionHandler(model)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
