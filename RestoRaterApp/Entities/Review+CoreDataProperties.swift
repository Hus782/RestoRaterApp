//
//  Review+CoreDataProperties.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var comment: String
    @NSManaged public var dateVisited: Date
    @NSManaged public var rating: Int
    @NSManaged public var restaurant: Restaurant

}

extension Review : Identifiable {

}

extension Review: FetchRequestProvider {}
