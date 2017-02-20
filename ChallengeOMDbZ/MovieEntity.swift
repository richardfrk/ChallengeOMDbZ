//
//  MovieEntity+CoreDataClass.swift
//  DesafioZUP
//
//  Created by Richard Frank on 19/02/17.
//  Copyright © 2017 Richard Frank. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

public class MovieEntity: NSManagedObject {
    
    convenience init(_ json: JSON, _ index: Int) {
        
        var myContext: NSManagedObjectContext {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        
        var myEntity: NSEntityDescription {
            return NSEntityDescription.entity(forEntityName: "MovieEntity", in: myContext)!
        }
        
        self.init(entity: myEntity, insertInto: nil)
        
        self.mmTitle = json["Search"][index]["Title"].stringValue
        self.mmYear = json["Search"][index]["Year"].stringValue
        self.mmIMDbID = json["Search"][index]["imdbID"].stringValue
        self.mmType = json["Search"][index]["Type"].stringValue
        self.mmPoster = json["Search"][index]["Poster"].stringValue

    }
    
    convenience init(_ json: JSON) {
        
        var myContext: NSManagedObjectContext {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        
        var myEntity: NSEntityDescription {
            return NSEntityDescription.entity(forEntityName: "MovieEntity", in: myContext)!
        }
        
        self.init(entity: myEntity, insertInto: nil)
    
        self.mmActors = json["Actors"].stringValue
        self.mmAwards = json["Awards"].stringValue
        self.mmDirector = json["Director"].stringValue
        self.mmGenre = json["Genre"].stringValue
        self.mmIMDbID = json["imdbID"].stringValue
        self.mmIMDbRating = json["imdbRating"].stringValue
        self.mmIMDbVotes = json["imdbVotes"].stringValue
        self.mmLanguage = json["Language"].stringValue
        self.mmMetascore = json["Metascore"].stringValue
        self.mmPlot = json["Plot"].stringValue
        self.mmPoster = json["Poster"].stringValue
        self.mmRated = json["Rated"].stringValue
        self.mmReleased = json["Released"].stringValue
        self.mmRuntime = json["Runtime"].stringValue
        self.mmTitle = json["Title"].stringValue
        self.mmType = json["Type"].stringValue
        self.mmWriter = json["Writer"].stringValue
        self.mmYear = json["Year"].stringValue
            
    }

}
