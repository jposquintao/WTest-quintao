//
//  PostalCode+CoreDataProperties.swift
//  WTest
//
//  Created by João Quintão on 15/04/2022.
//
//

import Foundation
import CoreData


extension PostalCode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostalCode> {
        return NSFetchRequest<PostalCode>(entityName: "PostalCode")
    }

    @NSManaged public var numCodPostal: String?
    @NSManaged public var extCodPostal: String?
    @NSManaged public var desigPostal: String?

}
