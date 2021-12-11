//
//  LikeHistory.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.01.22.
//

import AutoVliveApi
import CoreData
import Foundation

class LikeHistory: NSManagedObject, Identifiable {
    // MARK: Public

    @NSManaged public var id: UUID
    @NSManaged public var video: String
    @NSManaged public var likesPosted: Int32
    @NSManaged public var date: NSDate

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikeHistory> {
        NSFetchRequest<LikeHistory>(entityName: "LikeHistory")
    }

    // MARK: Internal

    static var allHistoryFetchRequest: NSFetchRequest<LikeHistory> {
        let request: NSFetchRequest<LikeHistory> = LikeHistory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return request
    }
}
