//
//  User+CoreDataProperties.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var name: String
    @NSManaged public var isAdmin: Bool

}

extension User : Identifiable {

}
