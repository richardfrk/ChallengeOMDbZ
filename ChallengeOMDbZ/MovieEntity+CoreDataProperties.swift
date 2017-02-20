//
//  MovieEntity+CoreDataProperties.swift
//  DesafioZUP
//
//  Created by Richard Frank on 20/02/17.
//  Copyright © 2017 Richard Frank. All rights reserved.
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity");
    }

    @NSManaged public var mmActors: String?
    @NSManaged public var mmAwards: String?
    @NSManaged public var mmDirector: String?
    @NSManaged public var mmGenre: String?
    @NSManaged public var mmIMDbID: String?
    @NSManaged public var mmIMDbRating: String?
    @NSManaged public var mmIMDbVotes: String?
    @NSManaged public var mmLanguage: String?
    @NSManaged public var mmMetascore: String?
    @NSManaged public var mmPlot: String?
    @NSManaged public var mmPoster: String?
    @NSManaged public var mmRated: String?
    @NSManaged public var mmReleased: String?
    @NSManaged public var mmRuntime: String?
    @NSManaged public var mmTitle: String?
    @NSManaged public var mmType: String?
    @NSManaged public var mmWriter: String?
    @NSManaged public var mmYear: String?

}
