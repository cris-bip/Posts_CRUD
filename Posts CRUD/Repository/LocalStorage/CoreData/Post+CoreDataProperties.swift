//
//  Post+CoreDataProperties.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import Foundation
import CoreData

extension Post{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }
    
    @NSManaged public var userId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    
}

extension Post : Identifiable {

}
